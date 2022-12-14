say "Install Tailwind (+PostCSS w/ autoprefixer)"
copy_file "#{__dir__}/tailwind.config.js", "tailwind.config.js"
copy_file "#{__dir__}/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css"
run "yarn add tailwindcss@latest postcss@latest autoprefixer@latest"

say "Add build:css script"
build_script = "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"

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
