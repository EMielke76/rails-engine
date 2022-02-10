require 'rails_helper'

RSpec.describe 'the item delete endpoint' do
  it 'allows for an item to be deleted' do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete api_v1_item_path(item.id)

    expect(response).to have_http_status(204)
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
