require 'rails_helper'
RSpec.describe Merchant do

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns an exact match' do
        bob = create(:merchant, name: "Bob Barker")
        not_bob = create(:merchant, name: "Not Bob")

        expect(Merchant.search("Bob Barker")).to eq([bob])
      end

      it 'returns a collect of near matches' do
        bob = create(:merchant, name: "Bob Barker")
        not_bob = create(:merchant, name: "Not Bob")

        expect(Merchant.search("Bob")).to eq([bob, not_bob])
      end

      it 'returns near matches in alphabetical order' do
        bob = create(:merchant, name: "Bob Barker")
        not_bob = create(:merchant, name: "Not Bob")
        also_not_bob = create(:merchant, name: "Also Not Bob")

        expect(Merchant.search("Bob")).to eq([also_not_bob, bob, not_bob])
      end

      it 'is case insensitive' do
        bob = create(:merchant, name: "Bob Barker")
        not_bob = create(:merchant, name: "Not Bob")
        also_not_bob = create(:merchant, name: "Also Not Bob")

        expect(Merchant.search("Bob")).to eq([also_not_bob, bob, not_bob])
        expect(Merchant.search("bob")).to eq([also_not_bob, bob, not_bob])
      end
    end
  end
end
