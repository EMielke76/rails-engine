class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    json_response(ItemSerializer.new(Item.all))
  end

  def show
    json_response(ItemSerializer.new(@item))
  end

  def update
    item = Item.update(@item.id, item_params)
    if item.save
      json_response(ItemSerializer.new(item))
    else
      render json: { status: 'ERROR', message: 'Unable to save item. Please try again', data: item.errors}, status: :bad_request
    end
  end

  def create
    item = Item.create!(item_params)
    json_response(ItemSerializer.new(item), :created)
  end

  def destroy
    @item.destroy
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
