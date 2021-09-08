say "Install Bootstrap 5 with Popperjs"
copy_file "#{__dir__}/bootstrap_js_files.js", "bootstrap_js_files.js"
copy_file "#{__dir__}/application.scss", "app/assets/stylesheets/application.scss"

run "yarn add bootstrap@5.0.0-beta2"
run "yarn add @popperjs/core@2.0.0-alpha.1"

# todo fix:
# say "Add build:css script"
# run %(npm set-script build:css "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css")
