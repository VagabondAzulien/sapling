#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

require_relative 'sapling/dialogue'
require_relative 'sapling/gardner'
require_relative 'sapling/planter'
require_relative 'sapling/utility'

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
            puts "No tree file provided. Please provide a tree file."
            puts opt_parser
            exit
          end

          unless verify_tree(ARGV[0])
            puts "\n#{opt}\n"
            exit
          end

          puts "Welcome to Sapling, a Dialogue Tree Utility.\n"
          speaker = Dialogue::Speaker.new
          speaker.file = YAML.load_file(ARGV[0])
          speaker.conversation
        end

        opt.on("-e", "--edit",
               "Create or edit a dialogue tree") do

          if ARGV.empty?
            puts "Creating a new tree."
            tree = SKELETON_TREE
          else
            puts "Using tree at #{ARGV[0]}."
            unless verify_tree(ARGV[0])
              puts "\n#{opt}\n"
              exit
            end
            tree = YAML.load_file(ARGV[0])
          end

          puts "Welcome to Sapling, a Dialogue Tree Utility.\n"
          gardner = Planter::Spade.new
          gardner.file = tree
          gardner.plant
        end

      end

      # Hacky way of dealing with bad options
      begin
        opt_parser.parse!(options)
      rescue OptionParser::InvalidOption
        puts "Invalid option."
        puts opt_parser
        exit
      end
    end
  end
end

Sapling::CLI.new.talk(ARGV)
