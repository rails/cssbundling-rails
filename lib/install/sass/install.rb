say "Install Sass"
copy_file "#{__dir__}/application.sass.scss", "app/assets/stylesheets/application.sass.scss"
run "yarn add sass"

say "Add build:css script"
build_script = "sass ./app/assets/stylesheets/application.sass.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"

if (`npx -v`.to_f < 7.1 rescue "Missing")
  say %(Add "scripts": { "build:css": "#{build_script}" to your package.json), :green
else
  run %(npm set-script build:css "#{build_script}")
end
