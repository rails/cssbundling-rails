namespace :css do
  desc "Build your CSS bundle"
  task :build do
    system "yarn install && yarn build:css"
  end
end

Rake::Task["assets:precompile"].enhance(["css:build"])

if Rake::Task.task_defined?("test:prepare")
  Rake::Task["test:prepare"].enhance(["css:build"])
elsif Rake::Task.task_defined?("db:test:prepare")
  Rake::Task["db:test:prepare"].enhance(["css:build"])
end
