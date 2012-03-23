require 'spec_helper'
require 'moodle.rb'

describe Moodle do
  subject do
    Moodle.new('ege_full')
  end

  it "should establish_connection" do
    ap subject.config
  end

  it "should list tables" do
    all = subject.tables
    all.should_not be_empty
    ap all
  end

end

