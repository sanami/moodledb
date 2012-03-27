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

  desc "Course info"
  task :course, [:env, :course_id] do |t, args|
    pp args
    course_id = args[:course_id] ? args[:course_id].to_i : nil

    if args[:env] && course_id
      tool = Moodle.new(args[:env])

      course = Course.find course_id
      course.print_info
      puts course.modinfo
      ap course.modinfo_unserialize

    end
  end

end
