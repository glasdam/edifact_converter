require 'optparse'
require 'pathname'

module EdifactConverter
  class CommandLineParser

    class << self
      attr_writer :options

      def options
        @options ||= {}
      end

      def parser
        @parser ||= begin
          OptionParser.new do|opts|
            # Set a banner, displayed at the top
            # of the help screen.
            opts.banner = "Usage: #{$COMMAND_NAME} [options] file"
            # Define the options, and what they do
            #options[:to_xml] = nil
            opts.on( '-x', '--xml', 'Convert from Edifact to XML' ) do
              options[:source] = :edifact
            end
            #options[:to_edi] = false
            opts.on( '-e', '--edi', 'Convert from XML to Edifact' ) do
              options[:source] = :xml
            end
            opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do|file|
              options[:logfile] = file
            end
            # This displays the help screen, all programs are
            # assumed to have this option.
            opts.on( '-h', '--help', 'Display this screen' ) do
              puts opts
              exit
            end
          end
        end

      end

      def parse
        parser.parse!
        if ARGV.size != 1
          puts "Wrong number of arguments, run #{$COMMAND_NAME} -h for a list of possible arguments."
          exit
        end
        options[:input] = Pathname.new ARGV.first
        p options[:input].extname
        unless options[:source]
          if options[:input].extname =~ /xml/
            options[:source] = :xml
          else
            options[:source] = :edifact
          end
        end
        options
      end

    end

  end
end
