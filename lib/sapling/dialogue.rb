require_relative './gardner'

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
