<!--
# @markup markdown
# @title Configuration File
-->

# Configuration File Documentation

The configuration file for `sapling` is a standard YAML file. The general
outline looks something like this:

        ---
        trunk:
            desc: This is a description of the dialogue tree.
        - branch:
            number: 1
            text: "This is the overall text for the branch."
                - leaf: 1
                  text: "This is option 1."
                  branch: 2
                - leaf: 2
                  text: "This is option 2."
                  branch: 3
        - branch:
            number: 2
            text: "This is the overall text for the branch."
                - leaf: 1
                  text: "This is option 1, on branch 2!"
                  branch: 3
        - branch:
            number: 3
            text: "This is the overall text for the branch."
                - leaf: 1
                  text: "This is option 3, branch 3"
                  branch: 0

## Outline

Each branch has the following options:

- `number`: The branch number. This is a number, but must be unique.
- `text`: The text provided by getting to this branch. The first branch is
  shown by default when the tree is opened.
- `leaf`: Each leaf represents an option on the branch. The value of the leaf is
  the number of the option shown. For example, `leaf: 1` represents the first
  listed option.

Each leaf has the following options:

- `text`: The text shown as the option.
- `branch`: The branch this option takes the user to.
