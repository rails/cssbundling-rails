require_relative "../helpers"
self.extend Helpers

apply "#{__dir__}/../install.rb"

say "Install Tailwind"
copy_file "#{__dir__}/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css"
run Cssbundling::PackageManager.add_command("tailwindcss@latest @tailwindcss/cli@latest")


say "Add build:css script"
add_package_json_script "build:css",
  "#{Cssbundling::PackageManager.run_x_command} @tailwindcss/cli -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
