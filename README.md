# Dialogue Tree CLI Tool

This tool allows for easy creation and use of dialogue trees.

A dialogue tree is a series of dialogues which follow sequentially, though with
branching options. Examples include "Choose Your Own Adventure" games, or the
dialogues seen in many video games.

## Structure

A dialogue tree can be broken down into three distinct parts: the trunk,
branches, and leafs. The trunk is the beginning of the dialogue. Generally
speaking, it is a branch, with the exception that it has no previous options. A
branch represents a choice taken in the dialogue. Branches flow to each other
through leafs, which are the actual choices. A leaf is a data point, allowing
for specific configuration of what information gets passed to the next branch,
or even an end to the entire tree.

## Building a New Tree

To build a new tree, you have two options. You can manually edit a configuration
file, or go through the construction wizard. Either way, the end result is a
plain-text configuration file, which can be easily shared, edited, and viewed.

### Manual Edit

1. Open your preferred text editor.
2. Refer to the Configuration File documentation (docs/config\_file.md)
3. Make your changes.
4. Save your changes.

### Automatic Edit

1. Run the configuration editor: `sapling --editor [--new][--file FILE]`
2. If you choose to create a new dialogue, `sapling` will generate a new file in
   your current directory.
3. If you choose to modify an existing file, `sapling` will show you the basic
   overview of the tree, and prompt you where you wish to edit.
4. Make your changes.
5. Save your changes.
