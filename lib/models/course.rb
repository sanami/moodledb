# For PHP unserialize
class StdClass
  attr_accessor :id, :cm, :mod, :section, :visible, :groupmode, :groupingid, :groupmembersonly, :extra, :icon, :name

  def to_assoc
    dat = {}
    [:id, :cm, :mod, :section, :visible, :groupmode, :groupingid, :groupmembersonly, :extra, :icon, :name].each do |key|
      value = self.instance_eval("self.#{key.to_s}")
      dat[key] = value if value
    end

    dat
  end
end

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

  # Delete
  def modinfo_update
    # http://stackoverflow.com/questions/9870846/what-should-i-do-with-the-database-when-i-create-a-course-in-php-with-moodle
    # http://moodle.org/mod/forum/discuss.php?d=176744
    # At any time you can just delete the contents of the modinfo field, and it will be
    # re-generated the next time someone view the course. Doing that is much safer than
    # trying to edit the contents of that field.
    self.modinfo = nil
  end

  def modinfo_unserialize
    if self.modinfo
      PHP.unserialize(self.modinfo, {'stdClass'.capitalize().to_sym => StdClass} )
    end
  end

  def modinfo_serialize(modinfo_obj)
    modinfo_str = PHP.serialize(modinfo_obj)
    modinfo_str.gsub!('"stdclass"', '"stdClass"')
    modinfo_str
  end
end
