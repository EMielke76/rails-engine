require 'rails_helper'

RSpec.describe 'the create item endpoint' do
  context 'happy path' do
    it 'can create an item' do
      merchant_1 = create(:merchant, name: "Bob")
      merchant_2 = create(:merchant, name: "Not Bob")
      item_params = ({
        name: "This thing",
        description: "This thing is a thing",
        unit_price: 12.32,
        merchant_id: merchant_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      expect(merchant_1.items.count).to eq(0)
      expect(merchant_2.items.count).to eq(0)

      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

      new_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(201)

      expect(merchant_1.items.count).to eq(1)
      expect(merchant_2.items.count).to eq(0)

      expect(new_item).to have_key(:data)
      expect(new_item[:data]).to be_a(Hash)

      new_item_data = new_item[:data]

      expect(new_item_data).to have_key(:id)
      expect(new_item_data[:id]).to be_a(String)

      expect(new_item_data).to have_key(:type)
      expect(new_item_data[:type]).to eq('item')

      expect(new_item_data).to have_key(:attributes)
      expect(new_item_data[:attributes]).to be_a(Hash)

      new_item_attributes = new_item_data[:attributes]

      expect(new_item_attributes).to have_key(:name)
      expect(new_item_attributes[:name]).to be_a(String)

      expect(new_item_attributes).to have_key(:description)
      expect(new_item_attributes[:description]).to be_a(String)

      expect(new_item_attributes).to have_key(:unit_price)
      expect(new_item_attributes[:unit_price]).to be_a(Float)

      expect(new_item_attributes).to have_key(:merchant_id)
      expect(new_item_attributes[:merchant_id]).to eq(merchant_1.id)
    end
  end

  context 'sad path' do
    it 'returns an error when item is unsucessfully created' do
      merchant_1 = create(:merchant, name: "Bob")

      item_params = ({
        name: "This thing",
        description: "This thing is a thing",
        unit_price: "A string",
        merchant_id: merchant_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      expect(merchant_1.items.count).to eq(0)

      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_1.items.count).to eq(0)

      expect(response).to have_http_status(422)

      expect(error).to have_key(:status)
      expect(error[:status]).to eq("ERROR")

      expect(error).to have_key(:message)
      expect(error[:message]).to eq("Unable to save item. Please try again")

      expect(error).to have_key(:data)
      expect(error[:data]).to be_a(Hash)

      error_data = error[:data]

      expect(error_data).to have_key(:unit_price)
      expect(error_data[:unit_price].first).to eq("is not a number")
    end
  end
end
