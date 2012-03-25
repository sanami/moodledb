class Wiki < ActiveRecord::Base
  self.table_name = 'mdl_wiki'

  # Relations
  has_many :wiki_entries, :foreign_key => 'wikiid', :dependent => :destroy

  # Scopes

  # Delegations

  # Validations
  validates_presence_of :course, :name, :summary, :pagename
  #validates_uniqueness_of :pagename

  # Defaults
  after_initialize do
    if new_record?
      #pp 'Wiki#after_initialize'
      self.course = nil if self.course == 0
      self.htmlmode = 2
      self.setpageflags = 0
      self.strippages   = 0
      self.removepages  = 0
      self.revertchanges = 0
      self.timemodified = Time.now.to_i
    end
  end

end
