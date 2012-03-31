require 'roo'
require 'moodle.rb'

module Bilingual
  class Parser
    def load(xls_file, sheet_name, row_limit = nil)
      sheet = Excelx.new(xls_file.to_s, nil, :ignore)
      sheet.default_sheet = sheet_name
      puts "row_limit: #{row_limit}"
      puts sheet.info

      all = []
      current_section = nil

      sheet.first_row.upto(row_limit || sheet.last_row) do |row|
        ref_str = (sheet.cell(row, 'A') || '').strip
        if ref_str != ''
          # New section
          #puts "#{row} #{ref_str}"

          current_section = {}
          current_section[:ref] = ref_str.gsub("\n", ' ').gsub(/\s+/, ' ')
          current_section[:examples] = []
          all << current_section
        end

        # Example
        example = {}
        example[:english] = sheet.cell(row, 'C')
        example[:french] = sheet.cell(row, 'D')
        example[:top] = sheet.cell(row, 'E') != nil
        example[:tags] = ('F'..'P').map { |column| sheet.cell(row, column) }.compact

        if example[:english]
          raise "Bad row #{row}: #{example}" unless example[:french]

          example[:english].strip!
          example[:french].strip!
          example[:tags].each { |tag| tag.strip! }
          current_section[:examples] << example
        end
      end

      all
    end

    def section_page(section)
      @template ||= Tilt.new(ROOT('lib/bilingual/template.html.erb').to_s)

      page = []
      page << section[:ref] << ''

      refs = []

      section[:examples].each do |example|
        page << example[:english]
        page << example[:french] << ''

        refs += example[:tags]
      end

      #page = page.join("<br>\n")
      page = @template.render(self, :section => section)
      page.force_encoding 'UTF-8'

      [page, refs.uniq.join("\n") ]
    end

    def build(course, section)
      puts section[:ref]
      wiki = course.wikis.build :name => section[:ref], :summary => section[:ref], :pagename => section[:ref]
      wiki.save!

      wiki_entry = wiki.wiki_entries.build :pagename => section[:ref]
      wiki_entry.save!

      page = section_page(section)

      wiki_page = wiki_entry.wiki_pages.build :pagename => section[:ref], :content => page[:content], :refs => page[:refs]
      wiki_page.save!
    end

    def run_to_course(course_id, row_limit)
      course = Course.find(course_id)
      #course.print_info

      file = ROOT('lib/bilingual/data.xlsm')
      all = load(file, 'Caro', row_limit)
      all.each do |section|
        #ap section
        build(course, section)
      end

      course.modinfo_update
      course.save!
      course.print_info
    end

    def run_to_wiki(wiki_id, row_limit)
      wiki = Wiki.find(wiki_id)
      wiki.course.print_info

      wiki_entry = wiki.wiki_entries.first
      unless wiki_entry
        wiki_entry = wiki.wiki_entries.build(:pagename => wiki.pagename)
        wiki_entry.save!
      end

      file = ROOT('lib/bilingual/data.xlsm')
      all = load(file, 'Caro', row_limit)
      all.each do |section|
        #ap section
        content, refs = section_page(section)

        wiki_page = wiki_entry.wiki_pages.build :pagename => section[:ref], :content => content, :refs => refs
        wiki_page.save!
      end

      wiki.course.modinfo_update
      wiki.course.save!
      wiki.course.print_info
    end

    def run_to_wiki_entry(wiki_entry_id, row_limit)
      wiki_entry = WikiEntry.find(wiki_entry_id)
      wiki_entry.wiki.course.print_info

      file = ROOT('lib/bilingual/data.xlsm')
      all = load(file, 'Caro', row_limit)
      all.each do |section|
        #ap section
        content, refs = section_page(section)

        wiki_page = wiki_entry.wiki_pages.build :pagename => section[:ref], :content => content, :refs => refs
        wiki_page.save!
      end

      wiki_entry.wiki.course.modinfo_update
      wiki_entry.wiki.course.save!
      wiki_entry.wiki.course.print_info
    end
    
  end
end
