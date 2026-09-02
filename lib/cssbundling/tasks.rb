module Cssbundling
  module Tasks
    extend self

    LOCK_FILES = {
      bun: %w[bun.lockb bun.lock],
      yarn: %w[yarn.lock],
      pnpm: %w[pnpm-lock.yaml],
      npm: %w[package-lock.json]
    }

    def install_command
      case
      when using_tool?(:bun) then "bun install"
      when using_tool?(:yarn) then "yarn install"
      when using_tool?(:pnpm) then "pnpm install"
      when using_tool?(:npm) then "npm install"
      else raise "cssbundling-rails: No suitable tool found for installing JavaScript dependencies"
      end
    end

    def build_command
      case
      when using_tool?(:bun) then "bun run build:css"
      when using_tool?(:yarn) then "yarn build:css"
      when using_tool?(:pnpm) then "pnpm build:css"
      when using_tool?(:npm) then "npm run build:css"
      else raise "cssbundling-rails: No suitable tool found for building CSS"
      end
    end

    private

    def tool_exists?(tool)
      system "command -v #{tool} > /dev/null"
    end

    def using_tool?(tool)
      tool_exists?(tool) && LOCK_FILES[tool].any? { |file| File.exist?(file) }
    end
  end
end
