# Utility functionality for all of Sapling to reference

# Constants

# A series of constants for handing a brand new tree. The skeleton tree provides
# a very basic introduction to Sapling. More details can be found in the
# documentation.

# The default trunk text of a new tree
SKELE_TRUNK_TEXT = "Welcome to the Sapling Editor. For details, please see the
documentation!"

# The default first-branch text of a new tree
SKELE_BRANCH_TEXT = "The first branch is always shown by default. It should act
as the introduction to the story. From here, the user enters your world!"

# The default first-leaf text of the first branch of a new tree. The leaf points
# to it's own branch. The only way out of the program is to either force-quit or
# reply with option 0.
SKELE_LEAF_TEXT = "Each branch can have any number of leaves, which represent
the options a user has on that branch. Each leaf points to another branch, or
can point to branch 0 to immediately exit."

# The final tree
SKELETON_TREE = [
  {"trunk" => "#{SKELE_TRUNK_TEXT}"},
  {"branch" => {
    "number" => 1,
    "text" => "#{SKELE_BRANCH_TEXT}",
    "leaf" => [{
      "text" => "#{SKELE_LEAF_TEXT}",
      "branch" => 1
      }]
    }
  }
]


# Verify that a file is a dialogue tree file.
#
# @param file [File] The provided file
# @return [Boolean] True if the file is a tree; false otherwise
def verify_tree(file)
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
