require 'rails_helper'

RSpec.describe 'the item update endpoints' do
  context 'happy path' do
    it 'allows for an item to be edited' do
      merchant_1 = create(:merchant, name: "Bob")
      item = create(:item, merchant: merchant_1)

      previous_data = Item.last.name

      item_params = ({name: "This thing"})
      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)

      result = Item.find_by(id: item.id)

      expect(response).to have_http_status(200)
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
end 
