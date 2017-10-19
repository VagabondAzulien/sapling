require_relative './gardner'

# Dialogue is the module for traversing an existing tree.
module Dialogue
  # Format and display the trunk
  #
  # @param trunk [Hash] The trunk hash
  # @param debug [Boolean] The status of showing debug information
  def self.display_trunk(trunk, debug = false)
    40.times { print '-' }
    puts "\n[ Trunk ]\n" if debug
    puts "\n#{trunk['trunk']}"
    40.times { print '-' }
    puts "\n"
  end

  # Format and display a branch and the options
  #
  # @param branch [Hash] A branch data set
  # @param branch_no [Integer] The branch number
  # @param debug [Boolean] Status of showing debug information
  def self.display_branch(branch, branch_no, debug = false)
    puts "\n[ Branch: #{branch_no} ]" if debug
    puts "\n#{branch['desc']}\n\n"

    branch['options'].each_pair do |k, v|
      puts "\t#{k}: #{v.keys[0]}"
      puts "\t\t[ Goes to branch #{v.values[0]} ]\n" if debug
    end
  end

  # Speaker holds the functionality for going through a dialogue tree.
  class Speaker
    # The tree, an instance of Gardner::Plot
    attr_reader :tree
    # Status of verbose/debug mode. True = on; false = off.
    attr_reader :debug

    def initialize(tree, debug = false)
      @tree = tree
      @debug = debug
    end

    # Conversation handles navigating the tree, until the option to end is
    # reached.
    def conversation
      Dialogue.display_trunk(@tree.trunk, @debug)

      next_branch = 1
      until next_branch.zero?
        next_branch = talk(@tree.branches[next_branch], next_branch)
      end

      puts "\n#{@tree.branches[0]['desc']}"
      exit
    end

    # Talk displays a branch, the options, and prompts for a response.
    #
    # @param branch [Hash] A branch data set
    # @param branch_no [Integer] The branch number
    # @return [Integer] The number of the next branch
    def talk(branch, branch_no)
      return 0 if terminal?(branch)

      Dialogue.display_branch(branch, branch_no, @debug)

      response = get_response(branch)

      unless response.zero?
        puts "(Your choice: #{branch['options'][response].keys[0]})"
        response = branch['options'][response].values[0].to_i
      end

      response
    end

    # Get a response for the displayed branch
    #
    # @param branch [Hash] A branch data set
    # @return [Integer] the next branch
    def get_response(branch)
      valid_options = branch['options'].keys.join(', ')

      print "\n[#{valid_options}]> "
      STDOUT.flush
      response = STDIN.gets.chomp.to_i

      until branch['options'].keys.include?(response) || response.zero?
        print '[## Invalid options. '
        print "Valid options are #{valid_options}, or 0 to exit."
        print "\n[#{valid_options}]> "
        response = STDIN.gets.chomp.to_i
      end

      response
    end

    # Check if a branch is terminal
    #
    # @param branch [Hash] A branch data set
    # @return [Boolean] true if the branch is terminal, false otherwise
    def terminal?(branch)
      if branch['options'].empty?
        puts "\n#{branch['desc']}\n\n"
        return true
      end

      false
    end
  end
end
