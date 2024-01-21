require "json"

module SharedInstallerTests
  extend ActiveSupport::Concern

  included do
    test "basic installation with pre-existing files" do
      with_new_rails_app do
        File.write(".gitignore", "# pre-existing\n", mode: "a+")
        File.write("package.json", %({ "name": "pre-existing" }\n))
        File.write("Procfile.dev", "pre: existing\n", mode: "a+")

        run_installer

        assert_equal 0, File.size("app/assets/builds/.keep")

        File.read(".gitignore").tap do |gitignore|
          assert_match "# pre-existing", gitignore
          assert_match "/app/assets/builds/*\n!/app/assets/builds/.keep", gitignore
          assert_match "/node_modules", gitignore
        end

        JSON.load_file("package.json").tap do |package_json|
          assert_equal "pre-existing", package_json["name"]
        end

        assert_not File.exist?("app/assets/stylesheets/application.css")

        File.read("Procfile.dev").tap do |procfile|
          assert_match "pre: existing", procfile
          assert_match "css: yarn", procfile
        end

        File.read("bin/dev").tap do |bin_dev|
          assert_equal File.read("#{__dir__}/../lib/install/dev"), bin_dev
          assert_equal 0700, File.stat("bin/dev").mode & 0700
        end
      end
    end

    test "basic installation without pre-existing files" do
      with_new_rails_app do
        FileUtils.rm("app/views/layouts/application.html.erb")
        FileUtils.rm(".gitignore")
        FileUtils.rm_rf("package.json")
        FileUtils.rm_rf("Procfile.dev")

        out, _err = run_installer

        assert_not File.exist?("app/views/layouts/application.html.erb")
        assert_match "Add <%= stylesheet_link_tag", out

        assert_not File.exist?(".gitignore")

        assert_instance_of Hash, JSON.load_file("package.json")

        File.read("Procfile.dev").tap do |procfile|
          assert_match "css: yarn", procfile
        end

        assert_match "STUBBED gem install foreman", out
      end
    end

    test "basic installation with Sprockets" do
      with_new_rails_app(*("--asset-pipeline=sprockets" if Rails::VERSION::MAJOR >= 7)) do
        File.write("app/assets/config/manifest.js", "// pre-existing\n", mode: "a+")

        run_installer

        File.read("app/assets/config/manifest.js").tap do |sprockets_manifest|
          assert_match "// pre-existing", sprockets_manifest
          assert_match "//= link_tree ../builds", sprockets_manifest
          assert_no_match "//= link_directory ../stylesheets .css", sprockets_manifest
        end
      end
    end

    if Rails::VERSION::MAJOR == 7
      test "basic installation with Propshaft" do
        with_new_rails_app("--asset-pipeline=propshaft") do
          run_installer

          assert_not File.exist?("app/assets/config/manifest.js")
        end
      end
    end

    if Rails::VERSION::MAJOR >= 7
      test "basic installation with Turbo" do
        with_new_rails_app do
          run_installer

          File.read("app/views/layouts/application.html.erb").tap do |layout|
            assert_match %(<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>), layout[%r{<head.*</head>}m]
          end
        end
      end
    end

    test "basic installation without Turbo" do
      with_new_rails_app(*("--skip-hotwire" if Rails::VERSION::MAJOR >= 7)) do
        run_installer

        File.read("app/views/layouts/application.html.erb").tap do |layout|
          assert_match %(<%= stylesheet_link_tag "application" %>), layout[%r{<head.*</head>}m]
        end
      end
    end

    test "basic installation with Bun" do
      with_new_rails_app do
        stub_bins("bun")

        run_installer

        File.read("Procfile.dev").tap do |procfile|
          assert_match "css: bun run", procfile
        end
      end
    end
  end
end
