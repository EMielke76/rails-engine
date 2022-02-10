require 'rails_helper'

RSpec.describe 'Find All Items endpoint' do
  context 'happy path' do
    it 'returns all items' do
    end

    it 'returns an empty array if no matches found' do
    end

    it 'returns all items that share a name' do
    end

    it 'allows for searches based on minimum dollar ammount' do
    end

    it 'allows for searches based on maximum dollar ammount' do
    end

    it 'allows for seraches of both min and max dollar ammount' do
    end

  end

  context 'sad path' do
    it 'does not allow for a search with empty parameters' do
    end

    it 'does not allow for name and min_price searches' do
    end

    it 'does not allow for name and max_price searches' do
    end

    it 'does not allow for name, min, and max_price searches' do
    end 
  end
end
