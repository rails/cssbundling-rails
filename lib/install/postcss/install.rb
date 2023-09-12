require_relative "../helpers"
self.extend Helpers

say "Install PostCSS w/ nesting and autoprefixer"
copy_file "#{__dir__}/postcss.config.js", "postcss.config.js"
copy_file "#{__dir__}/application.postcss.css", "app/assets/stylesheets/application.postcss.css"
run "#{bundler_cmd} add postcss postcss-cli postcss-import postcss-nesting autoprefixer"

say "Add build:css script"
add_package_json_script "build:css",
  "postcss ./app/assets/stylesheets/application.postcss.css -o ./app/assets/builds/application.css"
