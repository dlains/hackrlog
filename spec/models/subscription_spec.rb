require 'spec_helper'

describe Subscription do
  
  describe '#can_create_entry?' do
    
    context 'when the subscription is the free account' do
      
      context 'when the free entry limit has not been reached' do
        let(:hacker) { FactoryGirl.create(:hacker) }
        
        it 'returns true' do
          hacker.subscription.can_create_entry?.should be_true
        end
      end
      
      context 'when the free entry limit has been reached' do
        let(:hacker) { FactoryGirl.create(:hacker_with_entries, entries_count: 51) }
        
        it 'returns false' do
          hacker.subscription.can_create_entry?.should_not be_true
        end
      end
    end
    
    context 'when the subsciption is the premium account' do
      let(:hacker) { FactoryGirl.create(:hacker_with_entries, entries_count: 55) }
      
      before(:each) do
        hacker.subscription.premium_account = true
        hacker.save!
      end
      
      it 'returns true' do
        hacker.subscription.can_create_entry?.should be_true
      end
    end
  end
end
