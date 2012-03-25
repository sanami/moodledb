class WikiPage < ActiveRecord::Base
  self.table_name = 'mdl_wiki_pages'

  # Relations
  belongs_to :wiki_entry, :foreign_key => 'wiki'

  # Scopes

  # Delegations

  # Validations
  validates_presence_of :wiki, :pagename, :content, :refs
  validates_associated :wiki_entry

  # Defaults
  after_initialize do
    if new_record?
      self.version = 1
      self.flags = 1
      self.author = 'Mark (127.0.0.1:20123)'
      self.userid = 5
      self.meta = ''
      self.created = Time.now.to_i
      self.lastmodified = Time.now.to_i
    end
  end

  before_save do
    if new_record?
      #pp 'WikiPage#before_save'
      old_page = self.wiki_entry.wiki_pages.where(:pagename => self.pagename).order('version DESC').first
      if old_page
        #pp old_page.version
        self.version = old_page.version + 1
      end
    end
  end

end
