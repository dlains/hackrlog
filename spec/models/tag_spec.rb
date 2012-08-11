require 'spec_helper'

describe Tag do
  before(:each) do
    @tag = FactoryGirl.create(:tag)
  end
  
  it 'should be valid' do
    @tag.should be_valid
  end
  
  it 'is not valid without a name' do
    @tag.name = nil
    @tag.should_not be_valid
  end
  
  it 'is not valid with leading spaces' do
    @tag.name = ' bad'
    @tag.should_not be_valid
  end
  
  it 'is not valid with trailing spaces' do
    @tag.name = 'bar '
    @tag.should_not be_valid
  end
  
  it 'is not valid with embedded spaces' do
    @tag.name = 'bad tag'
    @tag.should_not be_valid
  end
  
  it 'is not valid with tab characters' do
    @tag.name = "bad\ttag"
    @tag.should_not be_valid
  end
  
  it 'is not valid with new-line characters' do
    @tag.name = "bad\ntag"
    @tag.should_not be_valid
  end
  
  it 'is not valid with return characters' do
    @tag.name = "bad\rtag"
    @tag.should_not be_valid
  end
  
  it 'is not valid with form-feed characters' do
    @tag.name = "bad\ftag"
    @tag.should_not be_valid
  end
  
  it 'returns the tag name for to_s' do
    @tag.name = 'testing'
    @tag.to_s.should eq('testing')
  end
  
  describe '::process_tag_names' do
    let(:params) { Hash.new }
    
    it 'should return nil if no tag names are given' do
      Tag.process_tag_names(params).should be_nil
    end
    
    it 'should find the ids of existing tags' do
      tag = FactoryGirl.create(:tag)
      params[:tags] = "#{tag.name}"
      
      ids = Tag.process_tag_names(params)
      ids.should include(tag.id)
    end
    
    it 'should create tags if they dont exist' do
      params[:tags] = 'new_tag'
      
      Tag.process_tag_names(params)
      Tag.find_by_name('new_tag').should_not be_nil
    end
    
    it 'should remove leading whitespace if it exists' do
      params[:tags] = 'new_tag  leading'
      
      Tag.process_tag_names(params)
      Tag.find_by_name('leading').should_not be_nil
    end
    
    it 'should remove trailing whitespace if it exists' do
      params[:tags] = 'new_tag trailing  '
      
      Tag.process_tag_names(params)
      Tag.find_by_name('trailing').should_not be_nil
    end
    
    it 'should downcase the tag name' do
      params[:tags] = 'new_tag Downcase'
      
      Tag.process_tag_names(params)
      Tag.find_by_name('downcase').should_not be_nil
    end
    
    it 'should remove duplicate tag ids' do
      params[:tags] = 'new_tag new_tag'
      
      ids = Tag.process_tag_names(params)
      ids.count.should eq(1)
    end
  end
end