class V1::OrdersController < ApplicationController
skip_before_action :authenticate_user! 
acts_as_token_authentication_handler_for User, fallback_to_devise: false  


respond_to :json



  def index
    puts "============================index============================================="
    organization_id = 1 #for jsonapi 
    begin_time = "10:00am" #which can request the order for today through our API at a specific time
    if Time.now < begin_time   

      render json: errors_json("You not allowed to get orders list before #{begin_time}"), status: :not_acceptable, content_type: "application/vnd.api+json"
      return
    end

    date = params[:date] ? Date.parse(params[:date]) : Date.today
    all_orders = Order.includes(:user).where("order_date='#{date}' ").order(:user_id, :course_type_id)
puts "========================================================================="
puts "all_orders"
puts "#{all_orders.size}"
puts "========================================================================="
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
    
    #if all_orders.size > 0
      json_api_data["data"] = {}
      json_api_data["data"]["id"] = "#{organization_id}"
      json_api_data["data"]["type"] = "order"
      json_api_data["data"]["attributes"] = {}
      json_api_data["data"]["attributes"]["order_date"] = date
      json_api_data["data"]["attributes"]["total"] = all_sum
      json_api_data["data"]["attributes"]["currency"] = currency_name
      json_api_data["data"]["attributes"]["detailed_orders"] = json_orders
    #else
    #  json_api_data["data"] = []
    #end

    render json: json_api_data, status: :ok, content_type: "application/vnd.api+json"

  end


end