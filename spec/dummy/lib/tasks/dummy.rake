# frozen_string_literal: true

namespace :dummy do
  desc "Sets up the dummy application to the point just before blogit will be installed"
  task :setup do
    puts `bundle exec rake db:migrate`
  end

  desc "Cleans the dummy application so we can test the installation again"
  task :clean do
    remove_joined_file("db", "migrate", "*.blogify*.rb")
    remove_joined_file("config", "initializers", "blogify.rb")
    remove_joined_file("db", "schema.rb")
  end

  private

  def remove_joined_file(*args)
    filepath = Rails.root.join(*args)
    Dir[filepath].each do |path|
      FileUtils.rm(path)
      warn "Removed #{path}"
    end
  end
end
