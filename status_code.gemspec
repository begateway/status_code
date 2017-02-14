Gem::Specification.new do |s|
  s.name        = 'status_code'
  s.version     = '0.0.1'
  s.date        = '2017-02-14'
  s.summary     = 'Decoding transactions bank codes'
  s.description = 'Responsible for decoding transactions result codes'
  s.authors     = ['Sergey Semaschyk']
  s.email       = ['Sergey.Semaschyk@bepaid.by']
  s.files       = Dir['{lib,spec}/**/*',
                      'Rakefile',
                      'Gemfile',
                      'Gemfile.lock',
                      'README.md']

  s.add_dependency 'i18n', '~> 0.7.0'
  s.add_development_dependency 'rake', '~> 11.3'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'pry', '~> 0.10.4'

  s.license = 'MIT'
end
