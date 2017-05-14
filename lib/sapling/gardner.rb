require 'yaml'

# Gardner is the module for working with a dialogue tree file
module Gardner
  # Parse the tree array into an array of numbered branches, and ordered leaves.
  #
  # @param tree [Array] The dialogue tree
  # @return [Array] An array of numbered branches, with numbered leaves
  def self.prune_branches(tree)
    branches = { 0 => { "desc" => "Thanks for using Sapling!" } }
    tree.each do |b|
      branches[b["branch"]["number"]] = {
        "desc" => b["branch"]["text"],
        "options" => prune_leaves(b["branch"]["leaf"]) }
    end

    return branches
  end

  # Parse the leaves of a branch into a numbered hash of options.
  #
  # @param leaves [Array] The option of leaf hashes
  # @return [Hash] A numbered hash of options
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

  # Parse the trunk of the tree.
  #
  # @param tree [Hash] The entire tree
  # @return [Array] The trunk, and the remainder of the tree
  def self.prune_trunk(tree)
    trunk = tree.shift

    return [trunk,tree]
  end

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
end
