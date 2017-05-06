<!--
# @markup markdown
# @title Example YAML File
-->
# Example Dialogue Tree
    ---
    # The trunk is a general introduction to the tree. It shouldn't include any
    # thematic details, rather a one-liner to let the user know what they're getting
    # into.
    -
      trunk: "This is a general introduction to the dialogue tree."

    # Branches are the content of a dialogue tree. Each branch is numbered, and that
    # number is used as the primary means of navigation. The text of a branch is the
    # story provided to the user; the result of getting to the branch. The leaves
    # (the section titled leaf) represent the options. Options are displayed in the
    # order they appear. Within a leaf, the text is what the option says, and the
    # branch is the branch number which this option will lead to. Leading to branch
    # number 0 will immediately exit the program.
    #
    # You can have as many branches and leaves as you wish, though having too many
    # leaves may lead to both display problems, and paralyzing indecision.
    -
      branch:
        number: 1
        text: "The first branch. Displayed first, by default."
        leaf:
          -
            text: "The first option for this branch. It leads to branch 2"
            branch: 2
          -
            text: "The second branch. It immediately exits the program."
            branch: 0

    # A terminal branch is a branch which has no leaves. This represents an ending.
    # Once a user hits a terminal branch, the program will display the branch text,
    # and then redirect the user to branch 0, to exit.
    -
      branch:
        number: 2
        text: "This is a terminal branch. After displaying this text,
          the program will exit."
