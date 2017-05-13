require_relative './dialogue'
require_relative './gardner'
require_relative './utility'

# Planter is the module for creating or editing a tree.
module Planter
  # A data class
  class Plot
    # The tree, trunk, and branches
    attr_accessor :tree, :trunk, :branches

  end

  # Utilities for editing specific parts of a tree.
  class Spade
    # The file we parse into a tree
    attr_writer :file

    # Establish a new Plot, which is basically an object for storing information
    # for us. From here, we start gardening.
    def plant
      @plot = Plot.new
      @plot.tree = @file
      @plot.trunk = @file.shift
      @plot.branches = Gardner.prune_branches(@file)

      dig(1)
    end

    # Function for displaying a single branch in debug mode. We also always
    # display the trunk, since otherwise it's displayed a single time then gone
    # forever (until next time).
    #
    # @param branch_no [Integer] The number of the branch to be displayed.
    def dig(branch_no)
      branch = @plot.branches[branch_no]

      Gardner.display_trunk(@plot.trunk)
      Gardner.display_branch(branch, branch_no, true)

    end

    # Edit the trunk of the tree
    def edit_trunk

    end

    # Edit a branch on the tree
    #
    # @param branch [Integer] The number of the branch to be edited.
    def edit_branch(branch)

    end

    # Edit a leaf on a branch, grasshopper
    #
    # @param branch [Integer] The number of the branch to be edited.
    # @param leaf [Hash] The leaf hash to be edited.
    def edit_leaf(branch, leaf)

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
    - B # - Go to Branch #
    - T - Edit Trunk
    - D - Edit Current Branch description
    - X - Delete Current Branch
    - L A - Add a new Leaf
    - L # D - Edit Leaf # description
    - L # B - Edit Leaf # branch destination
    - L # X - Remove Leaf #
    - S - Save Changes (write to the file)
    - Q - Quit without saving

Details:

- Regardless of the file existing, the user will be editing a Hash, not the actual YAML file
  - Use Gardner to build the tree (either existing or skeleton)
  - Use Dialog to interact with the tree
  - Overwrite prompt with Planter prompt
  - On changes, re-build the tree, and restart dialogue from most recent branch
- After each edit option, display the current branch with the new changes.

=end
