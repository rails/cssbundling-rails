# frozen_string_literal: true

require 'json'

module Helpers
  TOOLS_COMMANDS = {
    yarn: { cmd: 'yarn', run: 'yarn', x: 'npx' },
    bun: { cmd: 'bun', run: 'bun run', x: 'bunx' },
    pnpm: { cmd: 'pnpm', run: 'pnpm run', x: 'pnpx' },
    npm: { cmd: 'npm', run: 'npm run', x: 'npx' },
  }.freeze
  SUPPORTED_TOOLS = TOOLS_COMMANDS.keys.freeze
  DEFAULT_TOOL = :yarn

  def bundler_cmd
    TOOLS_COMMANDS.dig(package_manager, :cmd)
  end

  def bundler_run_cmd
    TOOLS_COMMANDS.dig(package_manager, :run)
  end

  def bundler_x_cmd
    TOOLS_COMMANDS.dig(package_manager, :x)
  end

  def using_bun?
    package_manager == :bun
  end

  def package_manager
    @package_manager ||= tool_determined_by_config_file || tool_determined_by_executable || DEFAULT_TOOL
  end

  def add_package_json_script(name, script, run_script: true)
    case package_manager
    when :yarn
      npx_version = `npx -v`.to_f

      if npx_version >= 7.1 && npx_version < 8.0
        say "Add #{name} script"
        run %(npm set-script #{name} "#{script}")
      elsif npx_version >= 8.0
        say "Add #{name} script"
        run %(npm pkg set scripts.#{name}="#{script}")
      else
        say %(Add "scripts": { "#{name}": "#{script}" } to your package.json), :green
        return
      end
    when :npm
      say "Add #{name} script"
      npx_version = `npx -v`.to_f

      if npx_version >= 7.1 && npx_version < 8.0
        run %(npm set-script #{name} "#{script}")
      else
        run %(npm pkg set scripts.#{name}="#{script}")
      end
    when :pnpm
      say "Add #{name} script"
      run %(pnpm pkg set scripts.#{name}="#{script}")
    when :bun
      say "Add #{name} script to package.json manually"
      package_json = JSON.parse(File.read("package.json"))
      package_json["scripts"] ||= {}
      package_json["scripts"][name] = script.gsub('\\"', '"')
      File.write("package.json", JSON.pretty_generate(package_json))
    end

    run %(#{bundler_run_cmd} #{name}) if run_script
  end

  private

  def tool_exists?(tool)
    system "command -v #{tool} > /dev/null"
  end

  def tool_determined_by_config_file
    case
    when File.exist?("bun.lockb")         then :bun
    when File.exist?("bun.lock")          then :bun
    when File.exist?("yarn.lock")         then :yarn
    when File.exist?("pnpm-lock.yaml")    then :pnpm
    when File.exist?("package-lock.json") then :npm
    end
  end

  def tool_determined_by_executable
    SUPPORTED_TOOLS.each do |tool|
      return tool if tool_exists?(tool)
    end
  end
end
