say "Install Bootstrap with Popperjs/core"
copy_file "#{__dir__}/application.bootstrap.scss",
   "app/assets/stylesheets/application.bootstrap.scss"
run "yarn add sass bootstrap @popperjs/core"

if Rails.root.join("app/javascript/application.js").exist?
  say "Appending Bootstrap JavaScript import to default entry point"
  append_to_file "app/javascript/application.js", %(import * as bootstrap from "bootstrap"\n)
else
  say %(Add import * as bootstrap from "bootstrap" to your entry point JavaScript file), :red
end

say "Add build:css script"
run %(npm set-script build:css "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules")
