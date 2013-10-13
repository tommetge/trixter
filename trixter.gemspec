Gem::Specification.new do |s|
  s.name        = 'trixter'
  s.version     = '1.0.0'
  s.date        = '2013-10-13'
  s.summary     = "Trixter Dream Bike Controller"
  s.description = "Turns the Trixter Dream Bike into a real training platform"
  s.authors     = ["Tom Metge"]
  s.email       = 'tom@accident-prone.com'
  s.files       = [
    "lib/trixter.rb",
    "lib/trixter/difficulties.rb",
    "lib/trixter/event.rb",
    "lib/trixter/handler.rb",
    "lib/trixter/trixter.rb"
  ]
  s.executables << 'trixter'
  s.homepage    =
    'http://www.accident-prone.com'
  s.license       = 'MIT'
end