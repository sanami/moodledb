require 'spec_helper'
require 'bilingual/parser.rb'

describe Bilingual::Parser do
  let(:test_file) { ROOT('lib/bilingual/data.xlsm') }

  it "should load data file" do
    subject.load(test_file, 'Caro')

  end
end
