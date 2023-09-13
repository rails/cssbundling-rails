namespace :css do
  desc "Install JavaScript dependencies"
  task :install do
    command = Cssbundling::Tasks.install_command
    unless system(command)
      raise "cssbundling-rails: Command install failed, ensure #{command.split.first} is installed"
    end
  end

  desc "Build your CSS bundle"
  build_task = task :build do
    command = Cssbundling::Tasks.build_command
    unless system(command)
      raise "cssbundling-rails: Command build failed, ensure `#{command}` runs without errors"
    end
  end
  build_task.prereqs << :install unless ENV["SKIP_YARN_INSTALL"] || ENV["SKIP_BUN_INSTALL"]
end

module Cssbundling
  module Tasks
    extend self

    def install_command
      return "bun install" if File.exist?('bun.lockb') || (tool_exists?('bun') && !File.exist?('yarn.lock'))
      return "yarn install" if File.exist?('yarn.lock') || tool_exists?('yarn')
      raise "cssbundling-rails: No suitable tool found for installing JavaScript dependencies"
    end

    def build_command
      return "bun run build:css" if File.exist?('bun.lockb') || (tool_exists?('bun') && !File.exist?('yarn.lock'))
      return "yarn build:css" if File.exist?('yarn.lock') || tool_exists?('yarn')
      raise "cssbundling-rails: No suitable tool found for building CSS"
    end

    def tool_exists?(tool)
      system "command -v #{tool} > /dev/null"
    end
  end
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
