Gem::Specification.new do |s|
  s.name        = 'Sapling'
  s.version     = '0.1.0'
  s.executables << 'sapling'
  s.date        = '2017-10-14'
  s.summary     = 'A Dialogue Tree Utility'
  s.description = 'Create, edit, and traverse Dialogue trees'
  s.authors     = ['Bill Niblock']
  s.email       = 'azulien@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.homepage    = 'http://www.theinternetvagabond.com/sapling/'
  s.license     = 'MIT'
end
