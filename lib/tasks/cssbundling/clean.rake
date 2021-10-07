namespace :css do
  desc "Remove CSS builds"
  task :clean do
    rm_rf Dir["app/assets/builds/[^.]*.css"], verbose: false
  end
end

Rake::Task["assets:clean"].enhance(["css:clean"])
