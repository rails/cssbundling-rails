say "Install Bootstrap with Popperjs/core"
copy_file "#{__dir__}/application.bootstrap.scss",
   "app/assets/stylesheets/application.bootstrap.scss"
copy_file "#{__dir__}/bootstrap.js", "app/javascript/bootstrap.js"
run "yarn add sass bootstrap @popperjs/core"

if Rails.root.join("app/javascript/application.js").exist?
  say "Appending Bootstrap JavaScript import to default entry point"
  append_to_file "app/javascript/application.js", %(import "./bootstrap"\n)
else
  say %(Add import "./bootstrap" to your entry point JavaScript file), :red
end

say "Add build:css script"
run %(npm set-script build:css "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map")
