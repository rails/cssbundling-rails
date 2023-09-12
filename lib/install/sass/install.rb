require_relative "../helpers"
self.extend Helpers

say "Install Sass"
copy_file "#{__dir__}/application.sass.scss", "app/assets/stylesheets/application.sass.scss"
run "#{bundler_cmd} add sass"

say "Add build:css script"
add_package_json_script "build:css",
  "sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"
