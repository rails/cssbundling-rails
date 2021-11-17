namespace :css do
  desc "Build your CSS bundle"
  task :build do
    # yarn:install on Rails 6.x requires bin/yarn
    unless Rails::VERSION::MAJOR < 7 && !File.exist?('bin/yarn')
      Rake::Task["yarn:install"].invoke
    end

    unless system "yarn build:css"
      raise "cssbundling-rails: Command css:build failed, ensure yarn is installed and `yarn build:css` runs without errors"
    end
  end
end

Rake::Task["assets:precompile"].enhance(["css:build"])

if Rake::Task.task_defined?("test:prepare")
  Rake::Task["test:prepare"].enhance(["css:build"])
elsif Rake::Task.task_defined?("db:test:prepare")
  Rake::Task["db:test:prepare"].enhance(["css:build"])
end
