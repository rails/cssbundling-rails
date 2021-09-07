require_relative "lib/cssbundling/version"

Gem::Specification.new do |spec|
  spec.name        = "cssbundling-rails"
  spec.version     = Cssbundling::VERSION
  spec.authors     = [ "David Heinemeier Hansson", "Dom Christie" ]
  spec.email       = "david@loudthinking.com"
  spec.homepage    = "https://github.com/rails/cssbundling-rails"
  spec.summary     = "Bundle and process CSS in Rails with Tailwind, PostCSS, and Sass via Node.js."
  spec.license     = "MIT"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "rails", ">= 6.0.0"
end
