namespace :css do
  desc "Install JavaScript dependencies"
  task :install do
    unless system "yarn install"
      raise "cssbundling-rails: Command install failed, ensure yarn is installed"
    end
  end

  desc "Build your CSS bundle"
  build_task = task :build do
    unless system "yarn build:css"
      raise "cssbundling-rails: Command css:build failed, ensure yarn is installed and `yarn build:css` runs without errors or use SKIP_CSS_BUILD env variable"
    end
  end
  build_task.prereqs << :install unless ENV["SKIP_YARN_INSTALL"]
end

unless ENV["SKIP_CSS_BUILD"]
  if Rake::Task.task_defined?("assets:precompile")
    Rake::Task["assets:precompile"].enhance(["css:build"])
  end

  if Rake::Task.task_defined?("test:prepare")
    Rake::Task["test:prepare"].enhance(["css:build"])
  elsif Rake::Task.task_defined?("spec:prepare")
    Rake::Task["spec:prepare"].enhance(["css:build"])
  elsif Rake::Task.task_defined?("db:test:prepare")
    Rake::Task["db:test:prepare"].enhance(["css:build"])
  end
end
