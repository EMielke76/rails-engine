class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :ok
    else
      render json: { status: 'ERROR', message: 'Unable to save item. Please try again', data: item.errors}, status: :bad_request
    end
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :no_content
    else
      render json: { status: 'ERROR', message: 'Unable to save item. Please try again', data: item.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    Item.find(params[:id]).destroy
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
