class Api::V1::MerchantItemsController < ApplicationController
  def index
    if params[:item_id]
      merchant_id = Item.find(params[:item_id]).merchant_id
      merchant = Merchant.find(merchant_id)
      render json: MerchantSerializer.new(merchant)
    else
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    end
  end
end
