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
