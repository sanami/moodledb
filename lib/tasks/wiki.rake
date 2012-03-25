require 'bilingual/parser.rb'

namespace :wiki do

  desc "Import wiki pages to course"
  task :import, [:env, :course_id, :row_limit] do |t, args|
    pp args
    course_id = args[:course_id] ? args[:course_id].to_i : nil
    row_limit = args[:row_limit] ? args[:row_limit].to_i : nil

    if args[:env] && course_id
      tool = Moodle.new(args[:env])

      parser = Bilingual::Parser.new
      parser.run(args[:env], course_id, row_limit)
    end
  end

  desc "Delete wiki pages from course"
  task :delete, [:env, :course_id] do |t, args|
    pp args
    course_id = args[:course_id] ? args[:course_id].to_i : nil

    if args[:env] && course_id
      tool = Moodle.new(args[:env])

      course = Course.find(course_id)
      course.print_info
      course.wikis.destroy_all
      course.print_info
    end
  end

end
