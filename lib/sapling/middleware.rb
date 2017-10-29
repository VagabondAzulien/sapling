require_relative './gardner'

class Middle
  attr_reader :tree

  def initialize(app)
    @app = app
    @tree = Gardner::Plot.new(YAML.load_file('lib/sapling/example.yaml'))
  end

  def call(env)
    @app.call(env)
  end
end
