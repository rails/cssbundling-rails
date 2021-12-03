say "Install Bulma"
copy_file "#{__dir__}/application.bulma.scss",
   "app/assets/stylesheets/application.bulma.scss"
run "yarn add sass bulma"

say "Add build:css script"
build_script = "sass ./app/assets/stylesheets/application.bulma.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"

if (`npx -v`.to_f < 7.1 rescue "Missing")
  say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :green
else
  run %(npm set-script build:css "#{build_script}")
  run %(yarn build:css)
end
