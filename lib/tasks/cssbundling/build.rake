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
      case tool
      when :bun then "bun install"
      when :yarn then "yarn install"
      when :pnpm then "pnpm install"
      when :npm then "npm install"
      else raise "cssbundling-rails: No suitable tool found for installing JavaScript dependencies"
      end
    end

    def build_command
      case tool
      when :bun then "bun run build:css"
      when :yarn then "yarn build:css"
      when :pnpm then "pnpm build:css"
      when :npm then "npm run build:css"
      else raise "cssbundling-rails: No suitable tool found for building CSS"
      end
    end

    def tool
      case
      when File.exist?('bun.lockb') then :bun
      when File.exist?('yarn.lock') then :yarn
      when File.exist?('pnpm-lock.yaml') then :pnpm
      when File.exist?('package-lock.json') then :npm
      when tool_exists?('bun') then :bun
      when tool_exists?('yarn') then :yarn
      when tool_exists?('pnpm') then :pnpm
      when tool_exists?('npm') then :npm
      end
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
