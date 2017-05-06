<!--
# @markup markdown
# @title README
-->

# Sapling: A Dialogue Tree CLI Utility

Sapling allows for easy creation and use of dialogue trees.

A dialogue tree is a series of dialogues which follow sequentially, though with
branching options. Examples include "Choose Your Own Adventure" games, or the
dialogues seen in many video games.

## Structure

A dialogue tree can be broken down into three distinct parts: the trunk,
branches, and leafs. The trunk represents the main structure of the tree. Unlike
a branch, which displays content and options, the trunk provides metadata.
Generally speaking, it is a branch, with the exception that it has no options. A
branch represents a choice taken in the dialogue. Branches flow to each other
through leafs, which are the actual choices.

You can experience this yourself, by loading "Example Quest! - A Meta Dialogue
Tree!". You can find the tree itself at [trees/example\_quest.yaml](
trees/example_quest.yaml). To run it, just type `sapling -t
trees/example_quest.yaml`.

## Building a New Tree

To build a new tree, you have two options. You can manually edit a configuration
file, or go through the construction wizard. Either way, the end result is a
plain-text configuration file, which can be easily shared, edited, and viewed.
For more details on the configuration file itself, check out the [Configuration
 File documentation](docs/config_file.md), or the self-documented [configuration
 file example](docs/config_file_example.yaml). Alternatively, you can checkout
[Example Quest](trees/example_quest.yaml) for a complete treel

### Manual Edit

1. Open your preferred text editor.
2. Refer to the [Configuration File documentation](docs/config_file.md)
3. Make your changes.
4. Save your changes.

### Automatic Edit -- Coming Soon(tm)!

1. Run the configuration editor: `sapling --edit [--new][--file FILE]`
2. If you choose to create a new dialogue, `sapling` will generate a new file in
   your current directory.
3. If you choose to modify an existing file, `sapling` will open the tree at the
   trunk, and show you the first branch.
4. Make your changes.
5. Save your changes.

More details on the editor can be found in the [Editor
documentation](docs/editor.md).

## Contributing

You can contribute to Sapling by following these instructions:
1. Fork this repository.
2. In your fork, make your changes.
3. Make sure your changes respect the [contribution
   guidelines](CONTRIBUTING.md).
4. Submit a pull request.

## License

Sapling is licensed under the MIT license. The full text can be found in
[LICENSE](LICENSE).

(c) 2017 Bill Niblock
