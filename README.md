# CSS Bundling for Rails

Use [Tailwind CSS](https://tailwindcss.com), [PostCSS](https://postcss.org), or [Dart Sass](https://sass-lang.com/) to bundle and process your stylesheets, then deliver it via the asset pipeline in Rails. This gem provides installers to get you going with the bundler of your choice in a new Rails application, and a convention to use `app/assets/builds` to hold your bundled output as artifacts that are not checked into source control (the installer adds this directory to `.gitignore` by default).

You develop using this approach by running the bundler in watch mode in a terminal with `yarn build:css --watch` (and your Rails server in another, if you're not using something like [puma-dev](https://github.com/puma/puma-dev)). Whenever the bundler detects changes to any of the stylesheet files in your project, it'll bundle `app/assets/stylesheets/application.[bundler].css` into `app/assets/builds/application.css`. This build output takes over from the regular asset pipeline default file. So you continue to refer to the build output in your layout using the standard asset pipeline approach with `<%= stylesheet_include_tag "application" %>`.

When you deploy your application to production, the `css:build` task attaches to the `assets:precompile` task to ensure that all your package dependencies from `package.json` have been installed via yarn, and then runs `yarn build:css` to process your stylesheet entrypoint, as it would in development. This output is then picked up by the asset pipeline, digested, and copied into public/assets, as any other asset pipeline file.

This also happens in testing where the bundler attaches to the `test:prepare` task to ensure the stylesheets have been bundled before testing commences. (Note that this currently only applies to rails `test:*` tasks (like `test:all` or `test:controllers`), not "rails test", as that doesn't load `test:prepare`).

That's it!

You can configure your bundler options in the `build:css` script in `package.json` or via the installer-generated `tailwind.config.js` for Tailwind or `postcss.config.js` for PostCSS.


## Installation

You must already have node and yarn installed on your system. Then:

1. Add `cssbundling-rails` to your Gemfile with `gem 'cssbundling-rails'`
2. Run `./bin/bundle install`
3. Run `./bin/rails css:install:[tailwind|postcss|sass]`

Or, in Rails 7+, you can preconfigure your new application to use a specific bundler with `rails new myapp --css [tailwind|postcss|sass]`.


## License

CSS Bundling for Rails is released under the [MIT License](https://opensource.org/licenses/MIT).
