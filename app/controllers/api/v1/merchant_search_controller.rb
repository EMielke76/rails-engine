class Api::V1::MerchantSearchController < ApplicationController
  before_action :guard_house, only: [:show]

  def show
    if @merchant == nil
      render json: { status: 'SUCCESS', message: 'No merchant matches that name!', data: {} }, status: :ok
    else
      json_response MerchantSerializer.new(@merchant)
    end
  end

  private
  def guard_house
    merchant_name_guard
  end
end
