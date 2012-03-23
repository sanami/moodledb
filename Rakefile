#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../lib/config.rb', __FILE__)

#require 'tasks'
Dir[ROOT('lib/tasks/*.rake')].each do |task_file|
  load task_file
end
