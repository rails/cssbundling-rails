require "cssbundling/package_manager"

namespace :css do
  desc "Install CSS dependencies"
  task :install do
    unless system(Cssbundling::PackageManager.install_command)
      raise "cssbundling-rails: Command install failed, ensure #{Cssbundling::PackageManager.package_manager} is installed"
    end
  end

  desc "Build your CSS bundle"
  build_task = task :build do
    unless system(Cssbundling::PackageManager.build_command)
      raise "cssbundling-rails: Command build failed, ensure `#{Cssbundling::PackageManager.build_command}` runs without errors"
    end
  end
  build_task.prereqs << :install unless ENV["SKIP_YARN_INSTALL"] || ENV["SKIP_BUN_INSTALL"]
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
