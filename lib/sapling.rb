#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

require_relative 'sapling/dialogue'
require_relative 'sapling/gardner'
require_relative 'sapling/planter'

# Sapling is the main module for the program. From here, the rest of the world
# starts building.
module Sapling

  # CLI is the class for option parsing, and the gateway to the program, on the
  # command line
  class CLI

    # Option parsing, and gateway to either reading and traversing a tree, or
    # editing/creating a tree.
    def talk(options)
      opt_parser = OptionParser.new do |opt|
        opt.banner = "Usage: sapling -t FILE\n" \
                     "Usage: sapling -e [FILE]"

        opt.on_tail("-h", "--help", "Show this menu") do
          puts opt
          exit
        end

        opt.on("-t", "--talk",
               "Begin traversing the provided dialogue tree") do

          if ARGV.empty?
            puts opt_parser
            exit
          end

          unless Gardner.verify_tree(ARGV[0])
            puts "\n#{opt}\n"
            exit
          end

          speaker = Dialogue::Speaker.new
          speaker.file = ARGV
          speaker.conversation
        end

        opt.on("-e", "--edit",
               "Create or edit a dialogue tree") do
          puts "We gonna make a tree!"
        end

      end
      opt_parser.parse!(options)

      if ARGV.empty?
        puts opt_parser
        exit
      end
    end
  end
end

Sapling::CLI.new.talk(ARGV)
