require_relative "../helpers"
self.extend Helpers

apply "#{__dir__}/../install.rb"

say "Install UnoCSS (via PostCSS + Autoprefixer)"
copy_file "#{__dir__}/application.uno.css", "app/assets/stylesheets/application.uno.css"
copy_file "#{__dir__}/uno.config.js", "uno.config.js"
copy_file "#{__dir__}/postcss.config.js", "postcss.config.js"
run "#{bundler_cmd} add @unocss/postcss@latest postcss@latest postcss-cli@latest autoprefixer@latest"


say "Add build:css script"
add_package_json_script "build:css",
  "postcss ./app/assets/stylesheets/application.uno.css -o ./app/assets/builds/application.css"
