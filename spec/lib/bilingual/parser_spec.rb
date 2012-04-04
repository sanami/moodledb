require 'spec_helper'
require 'bilingual/parser.rb'

describe Bilingual::Parser do
  let(:test_file) { ROOT('lib/bilingual/data.xlsm') }
  let(:test_file2) { ROOT('lib/bilingual/data2.xlsx') }

  let(:test_data) {
    example = {:english => '"Who is our next patient?" asked the doctor.',
               :french => '"Qui est notre prochain patient?" demanda le docteur.',
               :top => false,
               :tags => %w{who next patient asked doctor}}

    section = {:ref => '55IF WHO - WHOSE - WHOM',
               :examples => [example]
    }
    #ap section
    section
  }

  it "should load small data" do
    all = subject.load(test_file, 100)
    all.should_not be_empty
    ap all
  end

  it "should load all data" do
    all = subject.load(test_file)
    all.should_not be_empty
    puts all.count
    ap all.first
    ap all.last
  end

  it "should load all data2" do
    all = subject.load(test_file2)
    all.should_not be_empty
    puts all.count
    ap all.first
    ap all.last
  end

  it "should create content page" do
    page, refs = subject.section_page test_data
    page.should_not be_empty
    puts page
  end

  it "should build data" do
    tool = Moodle.new('ege_test')

    course = Course.find(97)
    course.wikis.destroy_all
    course.print_info

    subject.build(course, test_data)

    course.print_info
    course.wikis.destroy_all
  end
end
