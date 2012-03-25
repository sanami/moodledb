require 'moodle.rb'

# Tools for moodle db
namespace :moodle do

	desc "List all tables"
	task :list_tables, [:env] do |t, args|
    if args[:env]
      tool = Moodle.new(args[:env])
      pp tool.tables
    end
	end

  desc "List courses"
  task :list_courses, [:env] do |t, args|
    if args[:env]
      tool = Moodle.new(args[:env])

      Course.find_each do |course|
        course.print_info
      end

    end
  end

end
