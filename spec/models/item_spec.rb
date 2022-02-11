require 'rails_helper'

RSpec.describe Item  do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
    it { should validate_numericality_of(:unit_price)}
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns an exact match' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "Not Here")

        expect(Item.search("This one")).to eq([item])
      end

      it 'returns a collect of near matches' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "Not here")
        item_3 = create(:item, name: "And this one")

        expect(Item.search("This")).to eq([item_3, item])
      end

      it 'returns near matches in alphabetical and unicode case order' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "this one")
        item_3 = create(:item, name: "This apple")
        item_4 = create(:item, name: "And this one")

        expect(Item.search("This")).to eq([item_4, item_3, item, item_2])
      end

      it 'is case insensitive' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "this too")

        expect(Item.search("This")).to eq([item, item_2])
        expect(Item.search("this")).to eq([item, item_2])
      end
    end

    describe '::min_price_search' do
      it 'returns all items larger than or equal to a given threshold' do
        item = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 4.98)
        item_3 = create(:item, unit_price: 0.98)
        item_4 = create(:item, unit_price: 5.00)
        item_5 = create(:item, unit_price: 100.00)

        expect(Item.min_price_search(4.99)).to eq([item, item_4, item_5])
      end
    end

    describe '::max_price_search' do
      it 'returns all items less that a given threshold' do
        item = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 4.98)
        item_3 = create(:item, unit_price: 0.98)
        item_4 = create(:item, unit_price: 5.00)
        item_5 = create(:item, unit_price: 100.00)

        expect(Item.max_price_search(4.99)).to eq([item, item_2, item_3])
      end
    end

    describe '::min_max_price_search' do
      it 'returns items within a given range' do
        item = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 5.00)
        item_3 = create(:item, unit_price: 15.98)
        item_4 = create(:item, unit_price: 20.00)
        item_5 = create(:item, unit_price: 20.01)

        expect(Item.min_max_price_search(5.00, 20.00)).to eq([item_2, item_3, item_4])
      end
    end
  end
end
