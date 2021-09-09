say "Install Bootstrap with Popperjs/core"
copy_file "#{__dir__}/bootstrap.js", "bootstrap.js"
copy_file "#{__dir__}/application.scss", "app/assets/stylesheets/application.scss"

run "yarn add bootstrap@latest"
run "yarn add @popperjs/core@latest"

say "Add build:css script"
run %(npm set-script build:css "sass ./app/assets/stylesheets/application.scss ./app/assets/builds/application.css --no-source-map")
