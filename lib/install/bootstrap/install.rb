say "Install Bootstrap with Bootstrap Icons and Popperjs/core"
copy_file "#{__dir__}/application.bootstrap.scss",
   "app/assets/stylesheets/application.bootstrap.scss"
run "yarn add sass bootstrap bootstrap-icons @popperjs/core"

inject_into_file "config/initializers/assets.rb", after: /.*Rails.application.config.assets.paths.*\n/ do
  <<~RUBY
    Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
  RUBY
end

if Rails.root.join("app/javascript/application.js").exist?
  say "Appending Bootstrap JavaScript import to default entry point"
  append_to_file "app/javascript/application.js", %(import * as bootstrap from "bootstrap"\n)
else
  say %(Add import * as bootstrap from "bootstrap" to your entry point JavaScript file), :red
end

say "Add build:css script"
build_script = "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"

case `npx -v`.to_f
when 7.1...8.0
  run %(npm set-script build:css "#{build_script}")
  run %(yarn build:css)
when (8.0..)
  run %(npm pkg set scripts.build:css="#{build_script}")
  run %(yarn build:css)
else
  say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :green
end
