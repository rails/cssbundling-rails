say "Install Bootstrap with Bootstrap Icons, Popperjs/core and Autoprefixer"
copy_file "#{__dir__}/application.bootstrap.scss",
   "app/assets/stylesheets/application.bootstrap.scss"
run "yarn add sass bootstrap bootstrap-icons @popperjs/core postcss postcss-cli autoprefixer nodemon"

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

def add_npm_script(name, script, run_script=true)
  case `npx -v`.to_f
  when 7.1...8.0
    say "Add #{name} script"
    run %(npm set-script #{name} "#{script}")
    run %(yarn #{name}) if run_script
  when (8.0..)
    say "Add #{name} script"
    run %(npm pkg set scripts.#{name}="#{script}")
    run %(yarn #{name}) if run_script
  else
    say %(Add "scripts": { "#{name}": "#{script}" } to your package.json), :green
  end
end

add_npm_script("build:css:compile", "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules")
add_npm_script("build:css:prefix", "postcss ./app/assets/builds/application.css --use=autoprefixer --output=./app/assets/builds/application.css")
add_npm_script("build:css", "yarn build:css:compile && yarn build:css:prefix")
add_npm_script("watch:css", "nodemon --watch ./app/assets/stylesheets/ --ext scss --exec \\\"yarn build:css\\\"", false)

gsub_file "Procfile.dev", "build:css --watch", "watch:css"

case `npx -v`.to_f
when (7.1..)
  say "Add browserslist config"
  run %(npm pkg set browserslist[]=defaults)
else
  say %(Add "browserslist": ["defaults"] to your package.json), :green
end
