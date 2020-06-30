Gem::Specification.new do |s|
  s.name        = 'status_code'
  s.version     = '0.0.15'
  s.date        = '2020-06-30'
  s.summary     = 'Decoding transactions bank codes'
  s.description = 'Responsible for decoding transactions result codes'
  s.authors     = ['Sergey Semaschyk']
  s.email       = ['Sergey.Semaschyk@bepaid.by']
  s.files       = Dir['{lib,spec}/**/*',
                      'Rakefile',
                      'Gemfile',
                      'Gemfile.lock',
                      'README.md']

  s.add_dependency 'i18n'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'

  s.license = 'MIT'
end
