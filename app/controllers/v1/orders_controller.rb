class V1::OrdersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_user_from_token!

  def index
    begin_time = "10:00am"
    if Time.now < begin_time
      errors = {}
      errors["errors"] = []
      errors["errors"][0] = {}
      errors["errors"][0]["detail"] = "You not allowed to get order list before #{begin_time}"     

      render json: errors, status: 404, content_type: "application/vnd.api+json"
      return
    end

    date = params[:date] ? Date.parse(params[:date]) : Date.today
    all_orders = Order.includes(:user).where("order_date='#{date}' ").order(:user_id, :course_type_id)
    currency_id =  all_orders.first ? all_orders.first.menu.currency_type_id : CurrencyType.first.id
    currency_name = CurrencyType.find_by_id(currency_id).name
    all_sum = 0.00
    if all_orders.size > 0
      sum = Order.select("sum(menus.cost) as all_sum").joins("JOIN menus on orders.menu_id = menus.id").where("order_date='#{date}' ").order("all_sum")
      all_sum = sum.first.all_sum
    end

    users = User.all.sort

    all_orders_by_user_id = all_orders.group_by(&:user_id)


    json_orders = []
    i=0 #array of users
    users.each do |user|
      if all_orders_by_user_id[user.id]
        j=0 #array of order items
        all_orders_by_user_id[user.id].each do |order|
          if j == 0 
            json_orders[i] = {}
            json_orders[i]["person"] = user.name
            json_orders[i]["order_items"] = []
          end
          json_orders[i]["order_items"][j]={}
          json_orders[i]["order_items"][j]["#{order.course_type.name}"] = order.menu.name
          json_orders[i]["order_items"][j]["cost"] = order.menu.cost
          j += 1
        end
        i += 1
      end
    end

    json_api_data = {}
    
    if all_orders.size > 0
      json_api_data["data"] = {}
      json_api_data["data"]["id"] = "1"
      json_api_data["data"]["type"] = "order"
      json_api_data["data"]["meta"] = {}
      json_api_data["data"]["meta"]["order_date"] = date
      json_api_data["data"]["meta"]["total"] = all_sum
      json_api_data["data"]["meta"]["currency"] = currency_name
      json_api_data["data"]["meta"]["detailed_orders"] = json_orders
    else
      json_api_data["data"] = nil
    end

    render json: json_api_data, status: :ok, content_type: "application/vnd.api+json"




  end


  private
  
  def authenticate_user_from_token!
    user_email = params[:email].presence
    user       = user_email && User.find_by_email(user_email)
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:authentication_token])
      sign_in user, store: false
      
    end
  end

end