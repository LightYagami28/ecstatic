# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name             = 'ecstatic'
  s.version          = '0.0.0'
  s.authors          = ['John MacFarlane']
  s.email            = 'jgm@berkeley.edu'
  s.homepage         = 'https://github.com/jgm/cloudlib'
  s.summary          = 'Framework for maintaining a static website from templates and data in YAML files.'
  s.description      = 'Ecstatic is a framework for maintaining a static website from templates and data in YAML files.'
  s.date             = '2009-07-21'
  s.default_executable = 'ecstatic'

  # Specifying Ruby version requirement
  s.required_ruby_version = '>= 3.0.0' # Updated to Ruby 3.0 or later for modern compatibility

  # Defining the files included in the gem
  s.files = Dir.glob('**/*').reject { |f| f.match(/^(\.git|\.github)/) } # Exclude git-related files
  s.executables = ['ecstatic']
  s.extra_rdoc_files = ['ChangeLog', 'README.md']

  # Adding dependencies
  s.add_runtime_dependency 'activesupport', '>= 6.0'
  s.add_runtime_dependency 'rake', '>= 13.0'
  s.add_runtime_dependency 'rpeg-markdown', '>= 0.2'
  s.add_runtime_dependency 'tenjin', '>= 0.6.1'

  # Ensuring rdoc generation
  s.has_rdoc = true
  s.rdoc_options = ['--charset=UTF-8']

  # Specifying the directory structure for the gem
  s.require_paths = ['lib']

  # Adding metadata for better gem integration
  s.metadata = { 'homepage' => s.homepage }

  # Updating to the latest gemspec version
  if Gem::Specification.respond_to?(:specification_version)
    s.specification_version = 2
  end
end
