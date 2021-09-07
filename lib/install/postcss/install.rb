say "Install PostCSS w/ postcss-preset-env"
copy_file "#{__dir__}/postcss.config.js", "postcss.config.js"
copy_file "#{__dir__}/application.postcss.css", "app/assets/stylesheets/application.postcss.css"
run "yarn add postcss postcss-cli postcss-preset-env"

say "Add build:css script"
run %(npm set-script build:css "postcss ./app/assets/stylesheets/application.postcss.css -o ./app/assets/builds/application.css")
