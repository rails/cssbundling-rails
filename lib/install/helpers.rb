require 'json'
require "cssbundling/package_manager"

module Helpers
  def add_package_json_script(name, script, run_script=true)
    if Cssbundling::PackageManager.package_manager == :bun
      package_json = JSON.parse(File.read("package.json"))
      package_json["scripts"] ||= {}
      package_json["scripts"][name] = script.gsub('\\"', '"')
      File.write("package.json", JSON.pretty_generate(package_json))
      run Cssbundling::PackageManager.run_command(name) if run_script
    else
      case `npx -v`.to_f
      when 7.1...8.0
        say "Add #{name} script"
        run %(npm set-script #{name} "#{script}")
        run Cssbundling::PackageManager.run_command(name) if run_script
      when (8.0..)
        say "Add #{name} script"
        run %(npm pkg set scripts.#{name}="#{script}")
        run Cssbundling::PackageManager.run_command(name) if run_script
      else
        say %(Add "scripts": { "#{name}": "#{script}" } to your package.json), :green
      end
    end
  end
end
