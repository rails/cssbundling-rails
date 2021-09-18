namespace :css do
  namespace :install do
    desc "Install shared elements for all bundlers"
    task :shared do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../../install/install.rb",  __dir__)}"
    end

    desc "Install Tailwind"
    task tailwind: "css:install:shared" do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../../install/tailwind/install.rb",  __dir__)}"
    end

    desc "Install PostCSS"
    task postcss: "css:install:shared" do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../../install/postcss/install.rb",  __dir__)}"
    end

    desc "Install Sass"
    task sass: "css:install:shared" do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../../install/sass/install.rb",  __dir__)}"
    end

    desc "Install Bootstrap"
    task bootstrap: "css:install:shared" do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../../install/bootstrap/install.rb",  __dir__)}"
    end

    desc "Install Bulma"
    task bulma: "css:install:shared" do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../../install/bulma/install.rb",  __dir__)}"
    end
  end
end
