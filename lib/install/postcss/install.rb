say "Install PostCSS w/ nesting and autoprefixer"
copy_file "#{__dir__}/postcss.config.js", "postcss.config.js"
copy_file "#{__dir__}/application.postcss.css", "app/assets/stylesheets/application.postcss.css"
run "yarn add postcss postcss-cli postcss-nesting autoprefixer"

say "Add build:css script"
build_script = "postcss ./app/assets/stylesheets/application.postcss.css -o ./app/assets/builds/application.css"

if (`npx -v`.to_f < 7.1 rescue "Missing")
  say %(Add "scripts": { "build:css": "#{build_script}" } to your package.json), :green
else
  run %(npm set-script build:css "#{build_script}")
  run %(yarn build:css)
end
