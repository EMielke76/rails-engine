module ParamProtections
  def item_name_guard
    if params[:name] == nil
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name] == ""
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name].class == String && params[:name].length > 0
      @items = Item.search(params[:name])
    end
  end

  def item_price_guard
    if params[:min_price] && params[:max_price]
      if params[:min_price] == nil || params[:max_price] == nil
        render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
      elsif params[:min_price] == "" || params[:max_price] == ""
        render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
      else
        @items = Item.min_max_price_search(params[:min_price], params[:max_price])
      end
    elsif params[:min_price]
      if params[:min_price] == nil
        render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
      elsif params[:min_price] == ""
        render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
      else
        @items = Item.min_price_search(params[:min_price])
      end
    elsif params[:max_price]
      if params[:max_price] == nil
        render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
      elsif params[:max_price] == ""
        render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
      else
        @items = Item.max_price_search(params[:max_price])
      end
    end
  end

  def bad_touch
    render json: { status: 'BAD REQUEST', message: 'name and price search parameters cannot be combined', data: {} }, status: :bad_request
  end 

  def merchant_name_guard
    if params[:name] == nil
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name] == ""
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name].class == String && params[:name].length > 0
      @merchant = Merchant.search(params[:name]).first
    end
  end
end
