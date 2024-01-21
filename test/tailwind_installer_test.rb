require "test_helper"
require_relative "shared_installer_tests"

class TailwindInstallerTest < ActiveSupport::TestCase
  include RailsAppHelpers
  include SharedInstallerTests

  test "tailwind installer" do
    with_new_rails_app do
      out, _err = run_installer

      assert File.exist?("tailwind.config.js")

      assert File.exist?("app/assets/stylesheets/application.tailwind.css")

      assert_match %r{STUBBED yarn add.* tailwindcss@latest\s}, out

      assert_match %r{STUBBED npm (?:set-script |pkg set scripts.)build:css[= ]}, out

      File.read("Procfile.dev").tap do |procfile|
        assert_match "css: yarn build:css --watch", procfile
      end
    end
  end

  test "tailwind installer with Bun" do
    with_new_rails_app do
      stub_bins("bun")

      out, _err = run_installer

      assert_match %r{STUBBED bun add.* tailwindcss@latest\s}, out

      JSON.load_file("package.json").tap do |package_json|
        assert_includes package_json["scripts"], "build:css"
      end

      File.read("Procfile.dev").tap do |procfile|
        assert_match "css: bun run build:css --watch", procfile
      end
    end
  end

  private
    def run_installer
      stub_bins("gem", "yarn", "npm")
      run_command("bin/rails", "css:install:tailwind")
    end
end
