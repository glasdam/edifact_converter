require "diffy"
require "edifact_converter/difference"

module EdifactConverter

  class Comparator

    def initialize
      self.errors = []
    end

    def compare_docs(source, result, &proc)
      self.error_proc = proc || Proc.new { |n| :errors << n }
      if source.root.name == result.root.name
        compare_children source.root, result.root
      else
        error_proc.call(
          Difference.new(
            source: source.root,
            facit: result.root,
            kind: :root
          )
        )
      end
      errors
    end

    private

    attr_accessor :error_proc, :errors

    def compare_elements(source, facit)
      return unless children? source, facit
      source_elms = source.element_children
      facit_elms = facit.element_children
      source_str = elms_to_s source_elms
      facit_str = elms_to_s facit_elms
      diff_str source_str, facit_str do |source_i, facit_i, kind|
        source_elm = source_elms[source_i] || source_elms.last
        facit_elm = facit_elms[facit_i] || facit_elms.last
        if kind == :equal
          compare_children source_elm, facit_elm
        else
          error_proc.call(
            Difference.new(
              source: source_elm,
              facit: facit_elm,
              kind: kind
            )
          )
        end
      end
    end

    def compare_subelms(source, facit)
      unless source.text == facit.text
        error_proc.call (
          Difference.new(
            source: source,
            facit: facit,
            kind: :text
          )
        )
      end
    end

    def compare_children(source, facit)
      if source.name == 'SubElm'
        compare_subelms(source, facit)
      else
        compare_elements(source, facit)
      end
    end

    def diff_str(source, facit)
      source_index = facit_index = 0
      Diffy::Diff.new(source, facit, :allow_empty_diff => false).each do |line|
        case line
        when /^ /
          yield source_index, facit_index, :equal
        when /^\+/
          yield source_index, facit_index, :added
          source_index -= 1
        when /^-/
          yield source_index, facit_index, :removed
          facit_index -= 1
        end
        facit_index += 1
        source_index += 1
      end
    end

    def children?(source, facit)
      source_elms = source.element_children
      result_elms = facit.element_children
      case
      when source_elms.empty? && result_elms.empty?
        false
      when source_elms.empty?
        error_proc.call(
          Difference.new(
            source: source,
            facit: facit,
            kind: :added_children
          )
        )
        false
      when result_elms.empty?
        error_proc.call(
          Difference.new(
            source: source,
            facit: facit,
            kind: :removed_children
          )
        )
        false
      else
        true
      end
    end

    def elms_to_s(elements)
      str = elements.map { |element| element.name }.join("\n")
      str << "\n"
    end

  end

end
