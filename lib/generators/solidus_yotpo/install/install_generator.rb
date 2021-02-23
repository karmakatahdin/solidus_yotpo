# frozen_string_literal: true

module SolidusYotpo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false
      source_root File.expand_path('templates', __dir__)

      def copy_initializer
        template 'initializer.rb', 'config/initializers/solidus_yotpo.rb'
      end

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_yotpo\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/solidus_yotpo\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_yotpo\n", before: %r{\*/}, verbose: true # rubocop:disable Layout/LineLength
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/solidus_yotpo\n", before: %r{\*/}, verbose: true # rubocop:disable Layout/LineLength
      end

      def add_migrations
        run 'bin/rails railties:install:migrations FROM=solidus_yotpo'
      end

      def run_migrations
        run_migrations = ENV['AUTO_ACCEPT'] || options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]')) # rubocop:disable Layout/LineLength
        if run_migrations
          run 'bin/rails db:migrate'
        else
          puts 'Skipping bin/rails db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end

      def install_overrides
        if ENV['RAILS_ENV'] == 'test'
          choice = true
        else
          choice = ENV['AUTO_ACCEPT'] || (ask('Do you want to install the solidus_yotpo deface overrides into your app?', limited_to: %w[y n]) == 'y')
          say('****************************************************************')
          say('**************INSTALL NOTE**************************************')
          say('****************************************************************')
          say("Since you've chosen to add the solidus_yotpo deface overrides,")
          say("please make sure you've included 'gem deface' in your Gemfile")
          say("(if it is not already a dependency of your solidus application).")
          say("See README for more details.")
          say('****************************************************************')
        end

        if choice
          copy_file '00_add_reviews_partial.html.erb.deface', 'app/overrides/spree/products/show/00_add_reviews_partial.html.erb.deface'
        end
      end
    end
  end
end
