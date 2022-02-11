class Api::V1::ItemsSearchController < ApplicationController
  before_action :guard_house

  def index
    if @items.empty?
      render json: { status: 'SUCCESS', message: 'No item matches that name!', data: [] }, status: :ok
    else
      json_response ItemSerializer.new(@items)
    end
  end

  private
  def guard_house
    if params[:name] != nil && params[:min_price] != nil && params[:max_price] != nil
      bad_touch
    elsif params[:name] != nil && params[:min_price] != nil
      bad_touch
    elsif params[:name] != nil && params[:max_price] != nil
      bad_touch
    elsif params[:name]
      item_name_guard
    elsif params[:min_price]
      item_price_guard
    elsif params[:max_price]
      item_price_guard
    else
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    end
  end
end
