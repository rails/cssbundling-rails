namespace :css do
  desc "Build your CSS bundle"
  task :build do
    unless system "yarn install && yarn build:css"
      raise "cssbundling-rails: Command css:build failed, ensure yarn is installed and `yarn build:css` runs without errors or use CSS_BUILD=false env variable"
    end
  end
end

skip_css_build = %w(no false n f).include?(ENV["CSS_BUILD"])

unless skip_css_build
  if Rake::Task.task_defined?("assets:precompile")
    Rake::Task["assets:precompile"].enhance(["css:build"])
  end

  if Rake::Task.task_defined?("test:prepare")
    Rake::Task["test:prepare"].enhance(["css:build"])
  elsif Rake::Task.task_defined?("db:test:prepare")
    Rake::Task["db:test:prepare"].enhance(["css:build"])
  end
end
