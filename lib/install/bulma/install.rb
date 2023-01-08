say "Install Bulma"
copy_file "#{__dir__}/application.bulma.scss",
   "app/assets/stylesheets/application.bulma.scss"
run "yarn add sass bulma"

say "Add build:css script"
build_script = "sass ./app/assets/stylesheets/application.bulma.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"

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
