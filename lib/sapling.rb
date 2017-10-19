#!/usr/bin/env ruby

require 'thor'
require 'yaml'

Dir[File.join(__dir__, 'sapling', '*.rb')].each { |file| require file }

# The main Sapling interface.
class Sapling < Thor
  desc 'read TREE', 'Load and traverse the TREE'
  def read(file)
    puts 'Welcome to Sapling, a Dialogue Tree Utility.'
    exit unless verify_tree(file)
    tree = Gardner::Plot.new(YAML.load_file(file), false)
    speaker = Dialogue::Speaker.new(tree)
    speaker.conversation
  end

  desc 'edit TREE', 'Edit a new or existing TREE'
  def edit(file = '')
    puts 'Welcome to Sapling, a Dialogue Tree Utility.'
    if !tree.empty?
      puts "Loading tree: #{file}"
      exit unless verify_tree(file)
      gardner = Planter::Spade.new(YAML.load_file(tree, false))
    else
      puts 'Creating a new tree!'
      gardner = Planter::Spade.new(SKELETON_TREE)
    end
    gardner.plant
  end

  desc 'serve TREE', 'Load TREE in a web-based interface'
  def serve(tree)
    exit unless verify_tree(tree)
    puts 'Sinatra will be cool.'
  end

  desc 'export TREE', 'Save a portable HTML version of TREE'
  def export(tree)
    exit unless verify_tree(tree)
    puts 'Cool feature, bro!'
  end
end
