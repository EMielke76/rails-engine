require 'rails_helper'

RSpec.describe 'the merchants index endpoint' do
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
end
