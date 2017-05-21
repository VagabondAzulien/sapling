require_relative './dialogue'
require_relative './gardner'
require_relative './utility'

# Planter is the module for creating or editing a tree.
module Planter
  # In-memory tree
  class Plot
    # The tree, trunk, and branches
    attr_accessor :tree, :trunk, :branches

    # Edit the trunk of the tree
    def edit_trunk
      puts "Current Trunk:\n"
      Gardner.display_trunk(@trunk, true)
      print "\n[ =EDITING= ](CTRL-C to abort)> "
      STDOUT.flush
      begin
        new_trunk = STDIN.gets.to_s
      rescue Interrupt
        puts "\n**Aborting edit**\n\n"
        new_trunk = @trunk["trunk"]
      end
      @trunk["trunk"] = new_trunk
    end

    # Edit a branch on the tree
    #
    # @param branch [Integer] The number of the branch to be edited.
    def edit_branch(branch_no)
      puts "Current Branch:\n"
      Gardner.display_branch(@branches[branch_no], branch_no, true)
      print "\n[ =EDITING= ](CTRL-C to abort)> "
      STDOUT.flush
      begin
        new_branch = STDIN.gets.to_s
      rescue Interrupt
        puts "\n**Aborting edit**\n\n"
        new_branch = @branches[branch_no]["desc"]
      end
      @branches[branch_no]["desc"] = new_branch
    end

    # Edit a leaf on a branch, grasshopper
    #
    # @param branch [Integer] The number of the branch to be edited.
    # @param leaf [Hash] The leaf hash to be edited.
    def edit_leaf(branch, leaf)

    end
  end

  # Utilities for editing specific parts of a tree.
  class Spade
    # The file we parse into a tree
    attr_writer :file

    def initialize(file)
      @file = file
    end

    # Establish and populate a new Plot (in-memory tree), then control the flow
    # of editing the Plot
    def plant
      @plot = Plot.new
      @plot.tree = @file
      @plot.trunk = @file.shift
      @plot.branches = Gardner.prune_branches(@file)

      next_branch = dig(1)
      until next_branch == 0 do
        next_branch = dig(next_branch)
      end

      puts "\n#{@plot.branches[0]["desc"]}"
      exit
    end

    # Function for displaying a single branch in debug mode. We also always
    # display the trunk, since otherwise it's displayed a single time then gone
    # forever (until next time).
    #
    # @param branch_no [Integer] The number of the branch to be displayed.
    def dig(branch_no)
      branch = @plot.branches[branch_no]

      Gardner.display_trunk(@plot.trunk, true)
      Gardner.display_branch(branch, branch_no, true)

      response = get_response(branch)
      to_branch = parse_response(response, branch_no)

      return to_branch
    end

    # Get a response for the displayed branch
    #
    # @param branch [Hash] A branch data set
    # @return [Integer] the next branch
    def get_response(branch)
      total_branches = @plot.branches.count - 1
      valid_options = ["1-#{total_branches}","t","a","b","x","l","s","q"]
      print_options = valid_options.join(",")

      print "\n[#{print_options}]> "
      STDOUT.flush
      response = STDIN.gets.chomp.to_s.downcase

      until valid_options.include?(response) or response.to_i.between?(1,total_branches)
        print "[## Invalid response. "
        print "Valid options are #{print_options}"
        print "\n[#{print_options}]> "
        response = STDIN.gets.chomp.to_s.downcase
      end

      return response
    end

    # Parse the response from get_response
    #
    # @param response [String] The option selected
    # @param branch_no [Integer] The currently-displayed branch
    # @return [Integer] the branch to display
    def parse_response(response, branch_no)
      10.times { print "*" }
      print "\n(Your choice: "

      if response.to_i >= 1
        print "Change to branch #{response.to_i})\n\n"
        return response.to_i

      end

      case response.to_s.downcase
      when "t"
        print "Edit the trunk.)\n\n"
        @plot.edit_trunk
        return branch_no
      when "a"
        print "Add a new branch.)\n\n"
        return branch_no
      when "b"
        print "Edit the current branch.)\n\n"
        @plot.edit_branch(branch_no)
        return branch_no
      when "x"
        print "Delete the current branch.)\n\n"
        return branch_no
      when "l"
        print "Edit leaves of current branch.)\n\n"
        return branch_no
      when "s"
        print "Save changes.)\n\n"
        return branch_no
      when "q"
        print "Quit without saving.)\n\n"
        print "Unsaved changes will be lost. Still quit? [y/n]> "
        verify = STDIN.gets.chomp.to_s.downcase

        return 0 if verify == "y"

        return branch_no
      else
        print "Unknown option. Returning to current branch.)\n\n"
        return branch_no
      end
    end
  end
end

=begin

Process:
- User selects to create/edit a tree
  - If the user presented a file, use it as the tree file
  - If the user failed to provide a file, create a new tree file in the current directory

- Check if the file is empty.
  - If so, assume a new tree
  - If not, verify formatting

- If new tree, prompt for trunk
- If existing tree, display trunk and first branch

- At this point, editing is the same
  - Prompt provides options:
    - #: Go to that branch number
    - T: Modify the tree trunk
    - A: Add a new branch (append to list of branches)
    - B: Modify the current branch description
    - X: Delete the current branch (does this renumber branches?)
    - L: Modify the current leaves, respond with leaf prompt
    - S: Save changes
    - Q: Quit

- Example prompt:
  [ 0-5,T,A,B,X,L,S,Q ]>
- Leaf prompt:

Details:

- Regardless of the file existing, the user will be editing a Hash, not the actual YAML file
- Use Gardner to build and interact with the tree
- Use Planter to modify the tree "in memory" (aka, the hash)
- Use Dialog to interact with the tree "in memory", to test-run it
- After each edit option, display the current branch with the new changes.

=end
