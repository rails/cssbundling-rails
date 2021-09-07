say "Build into app/assets/builds"
empty_directory "app/assets/builds"
keep_file "app/assets/builds"
append_to_file "app/assets/config/manifest.js", %(//= link_tree ../builds\n)

if Rails.root.join(".gitignore").exist?
  append_to_file(".gitignore", %(/app/assets/builds\n))
end

say "Remove app/assets/stylesheets/application.css so build output can take over"
remove_file "app/assets/stylesheets/application.css"

unless Rails.root.join("package.json").exist?
  say "Add default package.json"
  copy_file "#{__dir__}/package.json", "package.json"
end
