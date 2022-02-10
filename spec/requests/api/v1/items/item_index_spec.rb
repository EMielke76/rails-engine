require 'rails_helper'

RSpec.describe 'the items endpoints' do
  it 'sends information on all items' do
    create_list(:item, 5)

    get api_v1_items_path

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(items).to have_key(:data)
    expect(items[:data].count).to eq(5)

    item_data = items[:data]

    item_data.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end
end
