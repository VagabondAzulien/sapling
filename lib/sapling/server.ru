require 'erb'

require_relative './gardner'

# Rack Stuff
class Greenhouse

  def initialize
    @response = ERB.new(File.read('lib/sapling/index.erb')).result(binding)
  end

  def call(_env)
    ['200', { 'Content-Type' => 'text/html' }, [@response]]
  end
end

run Greenhouse.new
