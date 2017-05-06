#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

# Gardner is the module for working with a dialogue tree file
module Gardner

  # Parse the branch
  #
  # @param tree [Array] The dialogue tree
  # @return branches [Array] The array of options on the branch.
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
  # @return options [Hash] A has of options
  def self.prune_leaves(leaves)
    x = 1
    options = {}
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
  # @return tree [Hash] The tree without the trunk
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
  # @return branches [Hash] The final, constructed data set
  def self.grow(file)
      tree = YAML.load_file(file[0])
      tree = Gardner.prune_trunk(tree)
      branches = Gardner.prune_branches(tree)

      return branches
  end

  # Verify that a file is a dialogue tree file.
  #
  # @param file [File] The provided file
  # @return status [Boolean] True if the file is a tree; false otherwise
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

  class Speaker
    attr_accessor :file

    def initialize
      @file = ""
    end

    # Scribe generates the new data set, which provides properly organized
    # branches and choices
    def scribe
      tree = Gardner.grow(@file)
      conversation(tree)
    end

    # Conversation handles navigating the tree, until the option to end is
    # reached.
    #
    # @param tree [Hash] The data set of branches and associated choices
    def conversation(tree)
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
    # @return response [Integer] The number of the next branch
    def talk(branch)
      puts "\n#{branch["desc"]}\n\n"
      branch["options"].each_pair do |k,v|
        puts "\t#{k}: #{v.keys[0]}"
      end

      print "> "
      STDOUT.flush
      response = STDIN.gets.chomp.to_i

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

# Parsing is the class for option parsing, and the gateway to the program
class Parsing

  # Option parsing, and gateway to either reading and traversing a tree, or
  # editing/creating a tree.
  #
  # @params file [String] The location of the file to read, or write.
  def talk(options)
    opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: sapling [-t][-e] FILE" \

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
        speaker.scribe
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

Parsing.new.talk(ARGV)

=begin

For a given tree:

tree[0] is the trunk. We want to display this, then pull it out of the array.
With the trunk gone, the remaining tree top-level elements are branches.
Now, we can parse each branch by doing tree.each { |b| parse_branch(b) }
parse_branch puts each branch into an array, at the location of it's number
At branch[0], it puts logic to end the program.
Now, we have a convenient way of moving around: when a leaf points to a branch,
we just reference branch[n] to get to that branch.

Traversing the tree thus goes like such:
- Start the loop by pulling in the appropriate branch. If the branch called is [0],
then we're done. End the program.
- Display all relevant information, formatted to display the text, followed by a
blank line, followed by the options, 1 per line, and numbered accordingly. At the
bottom is a prompt.
- The prompt expects a number. Anything not a number just displays another prompt
on the next line.
- Upon choosing that option, restart the loop with the new branch.

Parsing a branch:
- Format is tree[x] = branch element
            tree[x]["branch"]["number"] is the branch number, aka the @branches array place
            tree[x]["branch"]["text"] is the branch text
  branches[tree[x]["branch"]["number"] = {
    "desc" => tree[x]["branch"]["text"],
    "options" => options_hash }
  options_hash = {}

  { branch_number =>
    { "desc" => branch_text,
      "options" => {
      { 1 => { leaf_text => next_branch },
        2 => { leaf_text => next_branch }}

=end
