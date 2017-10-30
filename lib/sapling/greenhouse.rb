require 'erb'

# The rack application
class Greenhouse
  attr_reader :tree

  def initialize(file)
    @tree = file
    @response = ERB.new(File.read('lib/sapling/index.erb')).result(binding)
  end

  def call(_env)
    ['200', { 'Content-Type' => 'text/html' }, [@response]]
  end
end
