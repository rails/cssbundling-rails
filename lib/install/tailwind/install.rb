say "Install Tailwind (+PostCSS w/ autoprefixer)"
copy_file "#{__dir__}/tailwind.config.js", "tailwind.config.js"
copy_file "#{__dir__}/application.tailwind.css", "app/assets/stylesheets/application.tailwind.css"
run "yarn add tailwindcss@latest postcss@latest autoprefixer@latest"

say "Add build:css script"
run %(npm set-script build:css "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css")
