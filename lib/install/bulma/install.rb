say "Install Bulma"
copy_file "#{__dir__}/application.bulma.scss",
   "app/assets/stylesheets/application.bulma.scss"
run "yarn add sass bulma"

say "Add build:css script"
run %(npm set-script build:css "sass ./app/assets/stylesheets/application.bulma.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules")
