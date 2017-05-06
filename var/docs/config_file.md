<!--
# @markup markdown
# @title Configuration File
-->

# Configuration File Documentation

The configuration file for `sapling` is a standard YAML file. The general
outline looks something like this:

        ---
        -
          trunk: "This is a description of the dialogue tree."
        -
          branch:
            number: 1
            text: "This is the overall text for the branch."
            leaf:
              -
                text: "This is option 1."
                branch: 2
              -
                text: "This is option 2."
                branch: 3
        -
          branch:
            number: 2
            text: "This is the overall text for the branch."
            leaf:
              -
                text: "This is option 1."
                branch: 1
              -
                text: "This is option 2."
                branch: 3
        -
          branch:
            number: 3
            text: "This is the overall text for the branch."

## Outline

#### Trunk

The `trunk` is a metadata list. Currently, the only information we really care
about is a general description for the tree. Because of this, `trunk` is the
key, and the description is the value.

#### Branch

Branches are the content of a dialogue tree. Each `branch` has the following
options:

- `number`: The branch number. This is how leaves get around. It must be unique.
- `text`: The text provided by getting to this branch. The first branch is shown
  by default when the tree is opened.
- `leaf`: [Optional] The list of options for the branch. Details for leaves are
  below. If no leaves are provided, the branch is considered a "terminal
  branch", and the program will end after reaching it.

#### Leaf

Leaves are the options of a branch. Each `leaf` has the following options:

- `text`: The text shown as the option.
- `branch`: The branch this option takes the user to.
