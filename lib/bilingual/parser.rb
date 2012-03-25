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
      page = ''
      page << section[:ref] << "\n"
      page << "\n"

      refs = ''

      section[:examples].each do |example|
        page << example[:english] << "\n"
        page << example[:french] << "\n"
        page << "\n"

        refs << example[:tags].join(', ') << "\n"
      end

      { :content => page, :refs => refs }
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

    def run(env, course_id, row_limit)
      course = Course.find(course_id)
      #course.print_info

      file = ROOT('lib/bilingual/data.xlsm')
      all = load(file, 'Caro', row_limit)
      all.each do |section|
        #ap section
        build(course, section)
      end

      #course.print_info
    end

  end
end
