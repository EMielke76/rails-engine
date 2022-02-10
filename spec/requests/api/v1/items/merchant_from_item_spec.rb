require 'rails_helper'

RSpec.describe 'the merchant from item endpoint' do
  context 'happy path' do
    it 'returns merchant data for a given item' do
      merchant = create(:merchant, name: "Bob")
      item = create(:item)

      get api_v1_item_merchant_index_path(item.id)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to be_a(Hash)

      merchant_data = merchant[:data]

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_a(String)

      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to eq('merchant')

      expect(merchant_data).to have_key(:attributes)
      expect(merchant_data[:attributes]).to be_a(Hash)

      merchant_attributes = merchant_data[:attributes]

      expect(merchant_attributes).to have_key(:name)
      expect(merchant_attributes[:name]).to be_a(String)
    end
  end

  context 'sad path' do
    it 'returns a 404 if given invalid data' do
      bob = create(:merchant)
      item = create(:item, merchant: bob)
      
      get "/api/v1/items/0/merchant"

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(404)
    end
  end
end
