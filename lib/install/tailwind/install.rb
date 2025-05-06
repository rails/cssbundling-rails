require_relative "../helpers"
self.extend Helpers

apply "#{__dir__}/../install.rb"

say "Install Tailwind"
copy_file "#{__dir__}/application.css", "app/assets/tailwind/application.css"
run "#{bundler_cmd} add tailwindcss@latest @tailwindcss/cli@latest"

say "Add build:css script"
add_package_json_script "build:css",
  "#{bundler_x_cmd} @tailwindcss/cli -i ./app/assets/tailwind/application.css -o ./app/assets/builds/application.css --minify"
