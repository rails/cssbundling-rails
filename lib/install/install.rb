say "Build into app/assets/builds"
empty_directory "app/assets/builds"
keep_file "app/assets/builds"
append_to_file "app/assets/config/manifest.js", %(//= link_tree ../builds\n)

if Rails.root.join(".gitignore").exist?
  append_to_file(".gitignore", %(/app/assets/builds\n!/app/assets/builds/.keep\n))
end

say "Remove app/assets/stylesheets/application.css so build output can take over"
remove_file "app/assets/stylesheets/application.css"

unless Rails.root.join("package.json").exist?
  say "Add default package.json"
  copy_file "#{__dir__}/package.json", "package.json"
end

if Rails.root.join("Procfile.dev").exist?
  append_to_file "Procfile.dev", "css: yarn build:css --watch"
else
  say "Add default Procfile.dev"
  copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"

  say "Ensure foreman is install"
  run "gem install foreman"
end

say "Add bin/dev to start foreman"
copy_file "#{__dir__}/dev", "bin/dev"
chmod "bin/dev", 0755, verbose: false
