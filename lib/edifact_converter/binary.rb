require 'base64'

module EdifactConverter

  class Binary

    MIME_TYPES = { 
      "pcx" => 'image/x-pcx',
      "tiff" => 'image/tiff',
      "jpeg" => 'image/jpeg',
      "gif" => 'image/gif',
      "bmp" => 'image/bmp',
      "png" => 'image/png',
      "mpg" => 'video/mpeg',
      "dcm" => 'application/dicom',
      "scp" => 'application/dicom',
      "txt" => 'text/plain',
      "rtf" => 'text/rtf',
      "doc" => 'application/msword',
      "xls" => 'application/vnd.ms-excel',
      "wpd" => 'application/wordperfect',
      "exe" => 'application/octet-stream',
      "pdf" => 'application/pdf',
      "wav" => 'audio/wav',
      "avi" => 'video/avi',
      "mid" => 'audio/midi',
      "rmi" => 'audio/mid',
      "com" => 'application/octet-stream',
      "zip" => 'application/zip',
      'bin' => 'application/octet-stream',
      'inh' => 'application/octet-stream',
      'fnx' => 'application/zip'
       }

    ATTRIBUTES = [:base64, :code, :extension, :size, :identifier]

    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end

    def initialize(options)
      options.each do |name, value|
        if ATTRIBUTES.include? name.to_sym
          send "#{name}=", value
        end
      end
    end

    def binary
      Base64.decode64 base64 
    end

    def mime_type
      MIME_TYPES.fetch extension, "application/octet-stream" 
    end

    def self.from_element(element)
      self.new(
        base64: element.at("Object_Base64Encoded/text()").to_s,
        code: element.at("ObjectCode/text()").to_s,
        extension: element.at("ObjectExtensionCode/text()").to_s,
        size: element.at("OriginalObjectSize/text()").to_s,
        identifier: element.at("ObjectIdentifier/text()").to_s
        )
    end

  end

end