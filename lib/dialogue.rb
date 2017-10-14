require_relative './gardner'

# Dialogue is the module for traversing an existing tree.
module Dialogue

  # Format and display the trunk
  #
  # @param trunk [Hash] The trunk hash
  # @param debug [Boolean] The status of showing debug information
  def self.display_trunk(trunk, debug=false)
    40.times { print "-" }
    puts "\n[ Trunk ]\n" if debug
    puts "\n#{trunk["trunk"]}"
    40.times { print "-" }
    puts "\n"
  end

  # Format and display a branch and the options
  #
  # @param branch [Hash] A branch data set
  # @param branch_no [Integer] The branch number
  # @param debug [Boolean] Status of showing debug information
  def self.display_branch(branch, branch_no, debug=false)
    puts "\n[ Branch: #{branch_no} ]" if debug
    puts "\n#{branch["desc"]}\n\n"

    branch["options"].each_pair do |k,v|
      puts "\t#{k}: #{v.keys[0]}"
      puts "\t\t[ Goes to branch #{v.values[0]} ]\n" if debug
    end
  end

  # Speaker holds the functionality for going through a dialogue tree.
  class Speaker
    # The file, which should be a dialogue tree YAML file.
    attr_accessor :file
    # Status of verbose/debug mode. True = on; false = off.
    attr_accessor :debug

    def initialize(file="", debug=false)
      @file = file
      @debug = debug
    end

    # Conversation handles navigating the tree, until the option to end is
    # reached.
    def conversation()
      tree = Gardner.prune_trunk(@file)

      Dialogue.display_trunk(tree[0], false)
      branches = Gardner.prune_branches(tree[1])

      next_branch = 1
      until next_branch == 0 do
        next_branch = talk(branches[next_branch], next_branch)
      end

      puts "\n#{branches[0]["desc"]}"
      exit
    end

    # Talk displays a branch, the options, and prompts for a response.
    #
    # @param branch [Hash] A branch data set
    # @param branch_no [Integer] The branch number
    # @return [Integer] The number of the next branch
    def talk(branch, branch_no)
      # If there are no options on this branch, we assume it's a terminal
      # branch. Return 0, and end the program.
      if branch["options"].empty?
        puts "\n#{branch["desc"]}\n\n"
        return 0
      end

      Dialogue.display_branch(branch, branch_no, @debug)

      response = get_response(branch)

      unless response == 0
        puts "\n"
        10.times { print "*" }
        puts "\n(Your choice: #{branch["options"][response].keys[0]})"
        response = branch["options"][response].values[0].to_i
      end

      return response
    end

    # Get a response for the displayed branch
    #
    # @param branch [Hash] A branch data set
    # @return [Integer] the next branch
    def get_response(branch)
      valid_options = branch["options"].keys.join(", ")

      print "\n[#{valid_options}]> "
      STDOUT.flush
      response = STDIN.gets.chomp.to_i

      until branch["options"].keys.include?(response) or response == 0
        print "[## Invalid options. "
        print "Valid options are #{valid_options}, or 0 to exit."
        print "\n[#{valid_options}]> "
        response = STDIN.gets.chomp.to_i
      end

      return response
    end
  end
end
