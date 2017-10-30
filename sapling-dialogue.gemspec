Gem::Specification.new do |s|
  s.name        = 'sapling-dialogue'
  s.version     = '0.1.2'
  s.executables << 'sapling'
  s.date        = '2017-10-19'
  s.summary     = 'A Dialogue Tree Utility'
  s.description = 'Create, edit, and traverse dialogue trees'
  s.authors     = ['Bill Niblock']
  s.email       = 'azulien@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + 
                  Dir['bin/*'] +
                  Dir['var/trees/*']
  s.homepage    = 'http://www.theinternetvagabond.com/sapling/'
  s.license     = 'MIT'
end
