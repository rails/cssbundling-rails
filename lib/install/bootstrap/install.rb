say "Install Bootstrap 5 with Popperjs/core"
copy_file "#{__dir__}/bootstrap_js_files.js", "bootstrap_js_files.js"
copy_file "#{__dir__}/application.scss", "app/assets/stylesheets/application.scss"

run "yarn add bootstrap@5.1.1"
run "yarn add @popperjs/core@2.10.1"

run %(npm set-script build:css "sass ./app/assets/stylesheets/application.scss ./app/assets/builds/application.css --no-source-map")
