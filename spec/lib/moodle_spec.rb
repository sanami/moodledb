require 'spec_helper'
require 'moodle.rb'

describe Moodle do
  subject do
    Moodle.new('ege_test')
  end

  before(:each) do
    subject
  end

  it "should establish_connection" do
    ap subject.config
  end

  it "should list tables" do
    all = subject.tables
    all.should_not be_empty
    ap all
  end

  it "should create wiki" do
    wiki = Wiki.new :course => 2, :name => 'name', :summary => 'summary', :pagename => 'pagename'
    ap wiki
    expect {
      wiki.save!
    }.to_not raise_error
  end

  it "should show wiki entries" do
    wiki = Wiki.find 21
    ap wiki
    wiki.wiki_entries.should_not be_empty

    pp wiki.wiki_entries
  end

  it "should create wiki entry" do
    wiki = Wiki.find_by_name 'name'
    ap wiki
    expect {
      entry = wiki.wiki_entries.build :pagename => 'pagename'
      ap entry
      entry.save!
    }.to_not raise_error

    pp wiki.wiki_entries

  end

  it "should show wiki pages" do
    entry = WikiEntry.find 10
    ap entry
    entry.wiki_pages.should_not be_empty

    pp entry.wiki_pages
  end

  it "should create wiki page" do
    entry = WikiEntry.find_by_pagename 'pagename'
    ap entry

    entry.wiki_pages.destroy_all
    COUNT = 10

    COUNT.times do |i|
      expect {
        page = entry.wiki_pages.build :pagename => 'pagename', :content => "content #{i}", :refs => 'refs'
        page.save!
        #ap page
      }.to_not raise_error
    end

    entry.wiki_pages.count.should == COUNT
    pp entry.wiki_pages
  end

  it "should unserialize/serialize course modinfo" do
    course = Course.find(2)

    # as parsed object
    modinfo_obj = course.modinfo_unserialize
    modinfo_obj.should_not be_empty
    ap modinfo_obj

    # new string
    modinfo_str = course.modinfo_serialize(modinfo_obj)
    # equal to original
    modinfo_str.should == course.modinfo
  end

  it "should update course modinfo" do
    course = Course.find(2)
    ap course

    course.modinfo_update
    course.save!

    ap course.modinfo_unserialize
  end

  it "should find by author" do
    #pp WikiEntry.by_author 'Mark (127.0.0.1:20123)'
    Wiki.delete_wiki_by_author 'Mark (127.0.0.1:20123)'
  end

end

