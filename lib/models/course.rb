class Course < ActiveRecord::Base
  self.table_name = 'mdl_course'

  # Relations
  has_many :wikis, :foreign_key => 'course', :dependent => :destroy

  # Scopes

  # Delegations

  # Validations

  def print_info
    puts "course #{id}: #{fullname}"
    wikis.each do |wiki|
      puts "\twiki #{wiki.id}: #{wiki.name}"
      wiki.wiki_entries.each do |entry|
        puts "\t\tentry #{entry.id}: #{entry.pagename} \t #{entry.wiki_pages.count}"
      end
    end

  end

end
