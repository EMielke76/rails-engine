class Api::V1::SearchController < ApplicationController
  before_action :params_guard

  def show
    if @merchant == nil
      render json: { status: 'SUCCESS', message: 'No merchant matches that name!', data: {} }, status: :ok
    else
      json_response MerchantSerializer.new(@merchant)
    end
  end

  private
  def params_guard
    if params[:name] == nil
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name] == ""
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name].class == String && params[:name].length > 0
      @merchant = Merchant.search(params[:name]).first
    end
  end
end
