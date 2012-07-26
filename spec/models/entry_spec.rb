require 'spec_helper'

describe Entry do
  before(:each) do
    @entry = FactoryGirl.create(:entry)
  end
  
  it 'is valid with valid attributes' do
    @entry.should be_valid
  end
  
  it 'is not valid without content' do
    @entry.content = nil
    @entry.should_not be_valid
  end
  
  it 'is not valid without a hacker' do
    @entry.hacker_id = nil
    @entry.should_not be_valid
  end
  
  it 'is not valid with a negative hacker_id' do
    @entry.hacker_id = -1
    @entry.should_not be_valid
  end
  
  it 'is not valid with a zero hacker_id' do
    @entry.hacker_id = 0
    @entry.should_not be_valid
  end
  
  describe '#export_csv' do
    it 'creates an csv string of the entry' do
      value = @entry.export_csv
      value.should eq("\"#{@entry.content}\",\"\",\"#{@entry.created_at.to_s}\",\"#{@entry.updated_at.to_s}\"")
    end
  end
  
  describe '#csv_header' do
    it 'returns the entry csv header' do
      value = @entry.csv_header
      value.should eq("Content,Tags,Created At,Updated At")
    end
  end
  
  describe '#export_json' do
    it 'creates a JSON string of the entry' do
      value = @entry.export_json
      value.should eq("{\"entry\":{\"content\":\"#{@entry.content}\",\"tags\":\"\",\"created_at\":\"#{@entry.created_at}\",\"updated_at\":\"#{@entry.updated_at}\"}}")
    end
  end
  
  describe '#export_yml' do
    it 'creates a YAML string of the entry' do
      value = @entry.export_yml
      value.should eq("Entry:\n  Content: #{@entry.content}\n  Tags: \n  Created: #{@entry.created_at}\n  Updated: #{@entry.updated_at}\n\n")
    end
  end
  
  describe '#export_txt' do
    it 'creates a text string of the entry' do
      value = @entry.export_txt
      value.should eq("Content: #{@entry.content}\nTags: \nCreated: #{@entry.created_at}\nUpdated: #{@entry.updated_at}\n\n")
    end
  end
end