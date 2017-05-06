#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

# Gardner is the module for working with a dialogue tree file
module Gardner

  # Parse the branch
  #
  # @param tree [Array] The dialogue tree
  # @return [Array] The array of options on the branch.
  def self.prune_branches(tree)
    branches = { 0 => { "desc" => "Thanks for using Sapling!" } }
    tree.each do |b|
      branches[b["branch"]["number"]] = {
        "desc" => b["branch"]["text"],
        "options" => prune_leaves(b["branch"]["leaf"]) }
    end

    return branches

  end

  # Parse the options
  #
  # @param leaves [Array] The option of leaf hashes
  # @return [Hash] A has of options
  def self.prune_leaves(leaves)
    x = 1
    options = {}

    return options if leaves.nil?

    leaves.each do |l|
      options[x] = { l["text"] => l["branch"] }
      x += 1
    end

    return options

  end

  # Parse the trunk
  # The trunk is like the introduction to the tree.
  #
  # @param tree [Hash] The entire tree
  # @return [Hash] The tree without the trunk
  def self.prune_trunk(tree)
    trunk = tree.shift
    puts "Welcome to Sapling, a Dialogue Tree Utility.\n"
    40.times { print "-" }
    puts "\n#{trunk["trunk"]}"
    40.times { print "-" }
    puts "\n"

    return tree

  end

  # The main method for Sapling. From here, the tree is grown.
  #
  # @param file [File] The dialogue tree file
  # @return [Hash] The final, constructed data set
  def self.grow(file)
      tree = YAML.load_file(file[0])
      tree = Gardner.prune_trunk(tree)
      branches = Gardner.prune_branches(tree)

      return branches
  end

  # Verify that a file is a dialogue tree file.
  #
  # @param file [File] The provided file
  # @return [Boolean] True if the file is a tree; false otherwise
  def self.verify_tree(file)
    results = []
    begin
      tree = YAML.load_file(file)
      results << tree[0].keys.include?("trunk")
      results << tree[1]["branch"].keys.include?("number")
      results << tree[1]["branch"].keys.include?("text")
      results << tree[1]["branch"].keys.include?("leaf")
    rescue
      puts "Sorry chummer, I don't think this is a tree."
      puts "Verify your YAML file is formatted properly."
      results << false
    end

    results.include?(false) ? false : true

  end

end

# Dialogue is the module for traversing an existing tree.
module Dialogue

  # Spealer holds the functionality for viewing and going through a dialogue
  # tree.
  class Speaker
    # The file, which should be a dialogue tree YAML file.
    attr_accessor :file

    def initialize
      @file = ""
    end

    # Conversation handles navigating the tree, until the option to end is
    # reached.
    def conversation()
      tree = Gardner.grow(@file)

      10.times { print "*" }
      next_branch = talk(tree[1])
      until next_branch == 0 do
        next_branch = talk(tree[next_branch])
      end

      puts tree[0]["desc"]
      exit
    end

    # Talk displays a branch, the options, and prompts for a response
    #
    # @param branch [Hash] A branch data set
    # @return [Integer] The number of the next branch
    def talk(branch)
      # If there are no options on this branch, we assume it's a terminal
      # branch. Return 0, and end the program.
      if branch["options"].empty?
        puts "\n#{branch["desc"]}\n\n"
        return 0
      end

      valid_options = branch["options"].keys.join(", ")

      puts "\n#{branch["desc"]}\n\n"
      branch["options"].each_pair do |k,v|
        puts "\t#{k}: #{v.keys[0]}"
      end

      print "\n[#{valid_options}]> "
      STDOUT.flush
      response = STDIN.gets.chomp.to_i

      until branch["options"].keys.include?(response)
        print "[## Invalid options. "
        print "Valid options are #{valid_options}, or 0 to exit."
        print "\n[#{valid_options}]> "
        response = STDIN.gets.chomp.to_i
      end

      puts "\n"
      10.times { print "*" }
      puts "\n(Your choice: #{branch["options"][response].keys[0]})"
      return branch["options"][response].values[0].to_i
    end

  end

end

# Planter is the module for creating or editing a tree.
module Planter

end

# Sapling is the main module for the program. From here, the rest of the world
# starts building.
module Sapling

  # CLI is the class for option parsing, and the gateway to the program
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
