class Api::V1::MerchantItemsController < ApplicationController
  def index
    if params[:item_id]
      merchant_id = Item.find(params[:item_id]).merchant_id
      merchant = Merchant.find(merchant_id)
      json_response(MerchantSerializer.new(merchant))
    else
      merchant = Merchant.find(params[:merchant_id])
      json_response(ItemSerializer.new(merchant.items))
    end
  end
end
