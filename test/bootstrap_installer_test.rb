require "test_helper"
require_relative "shared_installer_tests"

class BootstrapInstallerTest < ActiveSupport::TestCase
  include RailsAppHelpers
  include SharedInstallerTests

  test "bootstrap installer with pre-existing files" do
    with_new_rails_app do
      FileUtils.mkdir("app/javascript")
      File.write("app/javascript/application.js", "// pre-existing\n", mode: "a+")
      File.write("Procfile.dev", "pre: existing\n", mode: "a+")

      out, _err = run_installer

      assert File.exist?("app/assets/stylesheets/application.bootstrap.scss")

      assert_match %r{STUBBED yarn add.* bootstrap\s}, out
      assert_match %r{STUBBED yarn add.* bootstrap-icons\s}, out
      assert_match %r{STUBBED yarn add.* @popperjs/core\s}, out

      File.read("config/initializers/assets.rb") do |initializer|
        assert_match %(config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")), initializer
      end

      File.read("app/javascript/application.js") do |app_js|
        assert_match "// pre-existing", app_js
        assert_match %(import * as bootstrap from "bootstrap"), app_js
      end

      JSON.load_file("package.json").tap do |package_json|
        assert_includes package_json, "browserslist"
        assert_match %r{STUBBED npm (?:set-script |pkg set scripts.)build:css:compile[= ]}, out
        assert_match %r{STUBBED npm (?:set-script |pkg set scripts.)build:css:prefix[= ]}, out
        assert_match %r{STUBBED npm (?:set-script |pkg set scripts.)build:css[= ]}, out
        assert_match %r{STUBBED npm (?:set-script |pkg set scripts.)watch:css[= ]}, out
      end

      File.read("Procfile.dev").tap do |procfile|
        assert_match "pre: existing", procfile
        assert_match "css: yarn watch:css", procfile
      end
    end
  end

  test "bootstrap installer without pre-existing files" do
    with_new_rails_app do
      FileUtils.rm_rf("app/javascript/application.js")
      FileUtils.rm_rf("Procfile.dev")

      out, _err = run_installer

      assert_not File.exist?("app/javascript/application.js")
      assert_match %(import * as bootstrap from "bootstrap"), out

      File.read("Procfile.dev").tap do |procfile|
        assert_match "css: yarn watch:css", procfile
      end
    end
  end

  test "bootstrap installer with Bun" do
    with_new_rails_app do
      stub_bins("bun")

      out, _err = run_installer

      assert_match %r{STUBBED bun add.* bootstrap\s}, out
      assert_match %r{STUBBED bun add.* bootstrap-icons\s}, out
      assert_match %r{STUBBED bun add.* @popperjs/core\s}, out

      JSON.load_file("package.json").tap do |package_json|
        assert_includes package_json["scripts"], "build:css:compile"
        assert_includes package_json["scripts"], "build:css:prefix"
        assert_includes package_json["scripts"], "build:css"
        assert_includes package_json["scripts"], "watch:css"
      end

      File.read("Procfile.dev").tap do |procfile|
        assert_match "css: bun run watch:css", procfile
      end
    end
  end

  private
    def run_installer
      stub_bins("gem", "yarn", "npm")
      run_command("bin/rails", "css:install:bootstrap")
    end
end
