require 'yaml'

# Gardner is the module for working with a dialogue tree file
module Gardner
  # The Plot class handles a specific tree file. It provides functionality for
  # parsing trunks and branches, and provides these as class attributes.
  class Plot
    # The trunk and branches instance variables
    attr_reader :branches, :tree, :trunk

    # Initialize a new Plot from a tree file
    #
    # @param tree [File] The dialogue tree file
    def initialize(file)
      @tree = file
      prune_trunk
      prune_branches
    end

    # Parse the tree array into an array of numbered branches, and ordered
    # leaves.
    #
    # @param tree [File] The dialogue tree
    # @return [Array] An array of numbered branches, with numbered leaves
    def prune_branches
      @branches = { 0 => { 'desc' => 'Thanks for using Sapling!' } }
      @tree.each do |b|
        @branches[b['branch']['number']] = {
          'desc' => b['branch']['text'],
          'options' => prune_leaves(b['branch']['leaf'])
        }
      end
    end

    # Parse the leaves of a branch into a numbered hash of options.
    #
    # @param leaves [Array] The option of leaf hashes
    # @return [Hash] A numbered hash of options
    def prune_leaves(leaves)
      x = 1
      options = {}

      return options if leaves.nil?

      leaves.each do |l|
        options[x] = { l['text'] => l['branch'] }
        x += 1
      end

      options
    end

    # Parse the trunk of the tree.
    #
    # @return [Array] The trunk, and the remainder of the tree
    def prune_trunk
      @trunk = @tree.shift
    end
  end

  # Digiplot represents a Plot used for editing. The Digiplot functions exactly
  # like a Plot, except with additional functionality for over-writing existing
  # branches, leaves, and the trunk.
  class Digiplot < Plot
    # Duplicate the "old" trunk and branches, for restoration purposes
    attr_reader :old_branches, :old_trunk

    # Enable editing for the trunk
    attr_writer :trunk

    # Initialize a Digiplot just like a Plot, but also copy the trunk and
    # branches to "old" instance variables.
    def initialize
      super
      @old_trunk = @trunk
      @old_branches = @branches
    end

    # Change a branch
    #
    # @param branch [Integer] the number of the branch to be edited
    def branch=(branch, text)
      @branches[branch]['desc'] = text
    end

    # Change a leaf on a branch, grasshopper
    #
    # @param branch [Integer] the number of the branch to be edited
    # @param leaf [Integer] the number of the leaf to be edited
    # @param text [String] the new text for the leaf
    # @param target [Integer] the branch number target for the leaf option
    def leaf=(branch, leaf, text, target)
      @branches[branch]['options'][leaf] = { text => target }
    end
  end
end
