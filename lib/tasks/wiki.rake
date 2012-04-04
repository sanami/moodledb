require 'bilingual/parser.rb'

namespace :wiki do

  desc "Import wiki pages to course"
  task :import_to_course, [:env, :course_id, :row_limit] do |t, args|
    pp args
    course_id = args[:course_id] ? args[:course_id].to_i : nil
    row_limit = args[:row_limit] ? args[:row_limit].to_i : nil

    if args[:env] && course_id
      tool = Moodle.new(args[:env])

      parser = Bilingual::Parser.new
      parser.run_to_course(course_id, row_limit)
    end
  end

  task :import_to_wiki, [:env, :wiki_id, :row_limit] do |t, args|
    pp args
    wiki_id = args[:wiki_id] ? args[:wiki_id].to_i : nil
    row_limit = args[:row_limit] ? args[:row_limit].to_i : nil

    if args[:env] && wiki_id
      tool = Moodle.new(args[:env])

      parser = Bilingual::Parser.new
      parser.run_to_wiki(wiki_id, row_limit)
    end
  end

  task :import_to_entry, [:env, :wiki_entry_id, :file, :row_limit] do |t, args|
    pp args
    wiki_entry_id = args[:wiki_entry_id] ? args[:wiki_entry_id].to_i : nil
    row_limit = args[:row_limit] ? args[:row_limit].to_i : nil

    if args[:env] && args[:file] && wiki_entry_id
      tool = Moodle.new(args[:env])

      parser = Bilingual::Parser.new
      parser.run_to_wiki_entry(wiki_entry_id, args[:file], row_limit)
    end
  end

  desc "Delete wiki pages from course"
  task :delete_by_course, [:env, :course_id] do |t, args|
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

  desc "Delete wiki pages by author"
  task :delete_by_author, [:env] do |t, args|
    if args[:env]
      tool = Moodle.new(args[:env])

      Wiki.delete_wiki_by_author 'Mark (127.0.0.1:20123)'
    end
  end

end
