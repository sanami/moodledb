class WikiEntry < ActiveRecord::Base
  self.table_name = 'mdl_wiki_entries'

  # Relations
  belongs_to :wiki, :foreign_key => 'wikiid'
  has_many :wiki_pages, :foreign_key => 'wiki', :dependent => :destroy

  # Scopes
  scope :by_author, lambda { |author| joins(:wiki_pages).where('mdl_wiki_pages.author' => author).uniq }

  # Delegations

  # Validations
  validates_presence_of :wikiid, :pagename
  validates_associated :wiki
  #validates_uniqueness_of :pagename

  # Defaults
  after_initialize do
    if new_record?
      self.timemodified = Time.now.to_i
    end
  end

end
