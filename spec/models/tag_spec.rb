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
end