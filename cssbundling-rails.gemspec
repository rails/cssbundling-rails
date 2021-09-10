require_relative "lib/cssbundling/version"

Gem::Specification.new do |spec|
  spec.name        = "cssbundling-rails"
  spec.version     = Cssbundling::VERSION
  spec.authors     = [ "David Heinemeier Hansson", "Dom Christie" ]
  spec.email       = "david@loudthinking.com"
  spec.homepage    = "https://github.com/rails/cssbundling-rails"
  spec.summary     = "Bundle and process CSS with Tailwind, Bootstrap, PostCSS, Sass in Rails via Node.js."
  spec.license     = "MIT"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "railties", ">= 6.0.0"
  spec.add_dependency "sprockets-rails", ">= 2.0.0"
end
