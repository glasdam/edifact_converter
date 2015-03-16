require 'edifact_converter/comparator'

module EdifactConverter

  class AbstractSyntaxTree

    attr_accessor :document

    def initialize(document)
      self.document = document
    end

    def pack
      pack_root(document.root)
    end

    def compare(document, &proc)
      Comparator.new.compare_docs(self.document, document, &proc)
    end

    def verify_segments_checksum(&proc)
      errors = []
      proc ||= Proc.new { |n| errors << n }
      document.xpath("//Brev").each do |brev|
        sum = 0
        brev.traverse do |elm|
          sum += 1 if elm.name =~ /[A-Z][A-Z0-9]{2}/
        end
        unt = brev.at("UNT")
        if unt
          unt_sum = unt.at("Elm[1]/SubElm/text()") || '0'
          if sum != unt_sum.to_s.to_i
            proc.call(
              Difference.new(
                source: unt,
                facit: sum,
                kind: :unt
              )
            )
          end
        else
          proc.call(
            Difference.new(
              source: brev,
              facit: sum,
              kind: :no_unt
            )
          )
        end
      end
      errors
    end

    private

    def pack_root(root)
      root.elements.each do |segment|
        pack_segment segment
      end
    end

    def pack_element(element)
      element.elements.reverse.each do |subelm|
        if subelm.children.empty?
          subelm.unlink
        else
          break
        end
      end
    end

    def pack_segment(segment)
      if 'Elm' == first_child_name(segment)
        segment.elements.each { |elm| pack_element elm }
        segment.elements.reverse.each do |elm|
          break if elm.elements.any?
          elm.unlink
        end
      else
        segment.elements.each do |child|
          pack_segment(child)
        end
      end
    end

    def first_child_name(element)
      element.first_element_child && element.first_element_child.name
    end

  end

end
