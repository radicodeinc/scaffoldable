$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "scaffoldable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scaffoldable"
  s.version     = Scaffoldable::VERSION
  s.authors     = ["Yuki Kotera"]
  s.email       = ["kotera@radicode.co.jp"]
  s.homepage    = "http://radicode.co.jp/"
  s.summary     = "Summary of Scaffoldable."
  s.description = "Description of Scaffoldable."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec)/})
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 5.0.0", "< 5.3"
  s.add_dependency "ransack", ">= 2.0.0", "< 3.0.0"
  s.add_dependency "kaminari"
  s.add_dependency "active_type"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3", "~> 1.3.6"
end
