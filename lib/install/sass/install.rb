say "Install Sass"
copy_file "#{__dir__}/application.sass.scss", "app/assets/stylesheets/application.sass.scss"
run "yarn add sass"

say "Add build:css script"
run %(npm set-script build:css "sass ./app/assets/stylesheets/application.sass.scss ./app/assets/builds/application.css --no-source-map")
