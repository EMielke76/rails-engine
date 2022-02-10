require 'rails_helper'

RSpec.describe 'the merchants endpoints' do
  it 'sends a list of all merchants' do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
    end
  end

  it 'sends information about a single merchant' do

    bob = create(:merchant)

    get api_v1_merchant_path(bob.id)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(merchant[:data].count).to eq(3)

    merchant_data = merchant[:data]
    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to be_a(String)

    expect(merchant_data).to have_key(:type)
    expect(merchant_data[:type]).to eq("merchant")

    expect(merchant_data).to have_key(:attributes)
    expect(merchant_data[:attributes]).to have_key(:name)
    expect(merchant_data[:attributes][:name]).to be_a(String)
  end

  it 'sends information about a single merchant and its items' do
    bob = create(:merchant)
    items = create_list(:item, 5, merchant: bob)

    get api_v1_merchant_items_path(bob.id)

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(merchant_items[:data].count).to eq(5)

    merchant_items[:data].each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)


      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(bob.id)
    end
  end
end
