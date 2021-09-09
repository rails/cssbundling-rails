say "Install Bootstrap with Popperjs/core"
copy_file "#{__dir__}/bootstrap_js_files.js", "bootstrap_js_files.js"
copy_file "#{__dir__}/application.scss", "app/assets/stylesheets/application.scss"

run "yarn add bootstrap@latest"
run "yarn add @popperjs/core@latest"

run %(npm set-script build:css "sass ./app/assets/stylesheets/application.scss ./app/assets/builds/application.css --no-source-map")
