#!/usr/bin/env ruby
# frozen string literal: true

require 'rack'
require 'thor'
require 'yaml'

Dir[File.join(__dir__, 'sapling', '*.rb')].each { |file| require file }

# The main Sapling interface.
class Sapling < Thor
  # CLI-based options
  desc 'read TREE', 'Load and traverse the TREE'
  def read(file)
    puts 'Welcome to Sapling, a Dialogue Tree Utility.'
    exit unless verify_tree(file)
    tree = Gardner::Plot.new(YAML.load_file(file))
    speaker = Dialogue::Speaker.new(tree, false)
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

  # Web-based options
  desc 'serve TREE', 'Load TREE in a web-based interface'
  def serve(file)
    exit unless verify_tree(file)
    tree = Gardner::Plot.new(YAML.load_file(file))
    Rack::Server.new(
      app: Greenhouse.new(tree),
      server: 'webrick',
      Port: 9000
    ).start
  end

  desc 'export TREE', 'Save a portable HTML version of TREE'
  def export(tree)
    exit unless verify_tree(tree)
    puts 'Cool feature, bro!'
  end

  # Miscellaneous options
  desc 'example', 'Play Example Quest!'
  def example
    file = File.join(__dir__, '..', 'var', 'trees', 'example_quest.yaml')
    puts 'Welcome to Sapling, a Dialogue Tree Utility.'
    exit unless verify_tree(file)
    tree = Gardner::Plot.new(YAML.load_file(file))
    speaker = Dialogue::Speaker.new(tree, false)
    speaker.conversation
  end
end
