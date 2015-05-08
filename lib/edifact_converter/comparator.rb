require "diffy"
require "edifact_converter/difference"
require "edifact_converter/ftx_text"

module EdifactConverter

  class Comparator

    def initialize
      self.errors = []
    end

    def compare_docs(source, result, &proc)
      source = source.dup
      result = result.dup
      self.error_proc = proc || Proc.new { |n| :errors << n }
      if source.root.name == result.root.name
        order_s12_ftxs(source)
        order_s12_ftxs(result)
        verify_texts(source, result)
        compare_children source.root, result.root
      else
        error_proc.call(
          Difference.new(
            source: source.root,
            facit: result.root,
            kind: :root,
            type: only_warn ? :warnings : :errors
          )
        )
      end
      errors
    end

    private

    attr_accessor :error_proc, :errors, :only_warn

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
              kind: kind,
              type: only_warn ? :warnings : :errors
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
            kind: :text,
            type: only_warn ? :warnings : :errors
          )
        )
      end
    end

    def compare_children(source, facit)
      case source.name
      when 'SubElm'
        compare_subelms(source, facit)
      when 'FTX'
        self.only_warn = true
        compare_elements(source, facit)
        self.only_warn = false
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
            kind: :added_children,
            type: only_warn ? :warnings : :errors
          )
        )
        false
      when result_elms.empty?
        error_proc.call(
          Difference.new(
            source: source,
            facit: facit,
            kind: :removed_children,
            type: only_warn ? :warnings : :errors
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

    def verify_texts(source, facit)
      source_s14 = combine_ftxs source.xpath("//S14/FTX")
      facit_s14 = combine_ftxs facit.xpath("//S14/FTX")
      source_s12 = combine_ftxs source.xpath("//S12/FTX")
      facit_s12 = combine_ftxs facit.xpath("//S12/FTX")
      unless source_s14 == facit_s14
        error_proc.call(
          Difference.new(
            kind: :text,
            type: :errors,
            message: "Tekst i segment gruppe 14 bliver ikke ens konverteret!"
          )
        )
      end
      unless source_s12 == facit_s12
        error_proc.call(
          Difference.new(
            kind: :text,
            type: :errors,
            message: "Tekst i segment gruppe 12 bliver ikke ens konverteret!"
          )
        )
      end
    end

    def combine_ftxs(ftxs)
      chunked = ftxs.chunk { |ftx| ftx.xpath('Elm[1]/SubElm/text()').to_s }.to_a
      chunked.map do |set|
        [ set.first, FTXText.parse(set.last)]
      end
    end

    def order_s12_ftxs(xml)
      ftxs = xml.xpath("//S12/FTX")
      return xml unless ftxs.any?
      ftxs.each { |ftx| ftx.unlink }
      s12s = xml.xpath("//S12")
      s12s.each_with_index do |s12, index|
        next if index == 0
        s12.unlink
      end
      s12 = s12s.first
      ftx_sets = ftxs.chunk { |ftx| ftx.xpath("Elm[1]/SubElm/text()").first.to_s }.to_a
      ftx_sets = ftx_sets.sort_by { |set| set.first }
      ftxs = ftx_sets.map { |set| set.last }.flatten
      ftxs.each { |ftx| s12 << ftx }
      xml
    end

  end

end
