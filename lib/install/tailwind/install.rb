require_relative "../helpers"
self.extend Helpers

apply "#{__dir__}/../install.rb"

say "Install Tailwind (+PostCSS w/ autoprefixer)"
copy_file "#{__dir__}/tailwind.config.js", "tailwind.config.js"
copy_file "#{__dir__}/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css"
run "#{bundler_cmd} add tailwindcss@3 postcss@latest autoprefixer@latest"

say "Add build:css script"
add_package_json_script "build:css",
  "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
