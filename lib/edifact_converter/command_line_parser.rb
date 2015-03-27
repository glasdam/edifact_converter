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
            opts.banner = "Usage: #{$COMMAND_NAME} [options] file"
            opts.on( '-x', '--xml', 'Convert from Edifact to XML' ) do
              options[:source] = :edifact
            end
            opts.on( '-e', '--edi', 'Convert from XML to Edifact' ) do
              options[:source] = :xml
            end
            opts.on( '-1', '--xml11', 'Only convert to XML 1-1') do
              options[:xml11] = true
            end
            opts.on( '-f', '--format', 'Format edifact output with newlines') do
              options[:format] = true
            end
            opts.on( '--html', 'Only convert to XML 1-1') do
              options[:html] = true
            end
            opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do |file|
              options[:logfile] = file
            end
            opts.on( '-o', '--output FILE', 'Write output to FILE' ) do |file|
              options[:to_file] = file
            end
            opts.on( '-v', '--version', "Prints version of #{$COMMAND_NAME}") do
              puts "#{$COMMAND_NAME} version #{VERSION}"
              exit
            end
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
