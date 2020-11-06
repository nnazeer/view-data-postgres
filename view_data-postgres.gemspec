# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name = 'view_data-postgres'
  spec.version = '0.0.0'
  spec.summary = 'View Data Postgres'
  spec.description = ' '

  spec.authors = ['Joseph Choe']
  spec.email = ['joseph@josephchoe.com']
  spec.homepage = 'https://github.com/hyperluminum/view-data-postgres'

  spec.require_paths = ['lib']
  spec.files = Dir.glob('{lib}/**/*')
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6'

  spec.add_runtime_dependency 'pg'

  spec.add_development_dependency 'test_bench'
end
