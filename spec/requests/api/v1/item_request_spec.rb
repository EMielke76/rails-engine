require 'rails_helper'

RSpec.describe 'the items endpoints' do

  context 'items index endpoint' do
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

  context 'item show endpoint' do
    it 'sends information about a single item' do
      item = create(:item)

      get api_v1_item_path(item.id)

      item_hash = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(item_hash).to have_key(:data)

      item_data = item_hash[:data]

      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)

      expect(item_data).to have_key(:type)
      expect(item_data[:type]).to eq("item")

      expect(item_data).to have_key(:attributes)
      expect(item_data[:attribues])

      item_attributes = item_data[:attributes]

      expect(item_attributes).to have_key(:name)
      expect(item_attributes[:name]).to be_a(String)

      expect(item_attributes).to have_key(:description)
      expect(item_attributes[:description]).to be_a(String)

      expect(item_attributes).to have_key(:unit_price)
      expect(item_attributes[:unit_price]).to be_a(Float)

      expect(item_attributes).to have_key(:merchant_id)
      expect(item_attributes[:merchant_id]).to be_a(Integer)
    end
  end

  context 'create item endpoint' do
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

  context 'update item endpoint' do
    context 'happy path' do
      it 'allows for an item to be edited' do
        merchant_1 = create(:merchant, name: "Bob")
        item = create(:item, merchant: merchant_1)

        previous_data = Item.last.name

        item_params = ({name: "This thing"})
        headers = {"CONTENT_TYPE" => "application/json"}

        patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)

        result = Item.find_by(id: item.id)

        expect(response).to have_http_status(204)
        expect(result.name).to_not eq(previous_data)
        expect(result.name).to eq("This thing")
      end
    end

    context 'sad path' do
      it 'throws a 400 error if update is invalid' do
        merchant_1 = create(:merchant, name: "Bob")
        item = create(:item, merchant: merchant_1)

        previous_data = Item.last.name

        item_params = ({name: 123})
        headers = {"CONTENT_TYPE" => "application/json"}

        patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)

        result = Item.find_by(id: item.id)

        expect(response).to have_http_status(400)
        expect(result.name).to eq(previous_data)
      end
    end

    context 'delete item endpoint' do
      it 'allows for an item to be deleted' do
        item = create(:item)

        expect(Item.count).to eq(1)

        delete api_v1_item_path(item.id)

        expect(response).to have_http_status(204)
        expect(Item.count).to eq(0)
        expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it 'returns merchant data for a given item' do
    end
  end
end
