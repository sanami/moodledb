class WikiEntry < ActiveRecord::Base
  self.table_name = 'mdl_wiki_entries'

  # Relations
  belongs_to :wiki, :foreign_key => 'wikiid'
  has_many :wiki_pages, :foreign_key => 'wiki'

  # Scopes

  # Delegations

  # Validations
  validates_presence_of :wikiid, :pagename
  validates_associated :wiki
  validates_uniqueness_of :pagename

  # Defaults
  after_initialize do
    if new_record?
      self.timemodified = Time.now.to_i
    end
  end

end
