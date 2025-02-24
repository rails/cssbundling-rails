require 'json'

module Helpers
  def bundler_cmd
    if using_bun?
      "bun"
    elsif tool_exists?('yarnpkg')
      "yarnpkg"
    else
      "yarn"
    end
  end

  def bundler_run_cmd
    if using_bun?
      "bun"
    elsif tool_exists?('yarnpkg')
      "yarnpkg"
    else
      "yarn"
    end
  end

  def bundler_x_cmd
    using_bun? ? "bunx" : "npx"
  end

  def using_bun?
    File.exist?('bun.lockb') || (tool_exists?('bun') && !File.exist?('yarn.lock'))
  end

  def tool_exists?(tool)
    system "command -v #{tool} > /dev/null"
  end

  def add_package_json_script(name, script, run_script=true)
    if using_bun?
      package_json = JSON.parse(File.read("package.json"))
      package_json["scripts"] ||= {}
      package_json["scripts"][name] = script.gsub('\\"', '"')
      File.write("package.json", JSON.pretty_generate(package_json))
      run %(bun run #{name}) if run_script
    else
      case `npx -v`.to_f
      when 7.1...8.0
        say "Add #{name} script"
        run %(npm set-script #{name} "#{script}")
        tool_exists?("yarnpkg") ? (run %(yarnpkg #{name}) if run_script) : (run %(yarn #{name}) if run_script)
      when (8.0..)
        say "Add #{name} script"
        run %(npm pkg set scripts.#{name}="#{script}")
        tool_exists?("yarnpkg") ? (run %(yarnpkg #{name}) if run_script) : (run %(yarn #{name}) if run_script)
      else
        say %(Add "scripts": { "#{name}": "#{script}" } to your package.json), :green
      end
    end
  end
end
