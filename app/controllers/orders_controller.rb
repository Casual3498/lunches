class OrdersController < ApplicationController
  
  before_action :permit_user, only: [:all_index]


  def index

    if params[:order_date]
      @order_date = Date.parse(params[:order_date])  
      @course_type = CourseType.all
      orders = Menu.select("menus.*", "orders.menu_id").joins("LEFT JOIN orders ON menus.id = orders.menu_id and orders.user_id='#{current_user.id}' ").where("menu_date='#{@order_date}' ").order('orders.menu_id' , 'name')
      @currency_id =  orders.first ? orders.first.currency_type_id : CurrencyType.first.id
      @currency_name = CurrencyType.find_by_id(@currency_id).name
      
      @order_exist = false
      orders.each do |order|
        if order.menu_id
          @order_exists = true
          break
        end
      end
      @edit_order_enable = !@order_exists && (@order_date == Date.current) && !orders.empty?

      @orders_by_course_type = orders.group_by(&:course_type_id)
      
      @order = Order.new
   
      respond_to do |format|
        format.js
      end 
    else #if not fom js
      redirect_to(root_url)
    end

  end


  def all_index

    @options =  {holidays: Rails.configuration.holidays, weekdays: Rails.configuration.weekdays}
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @order_date = params[:order_date] ? Date.parse(params[:order_date]) : Date.current
    @all_orders = Order.includes(:user).where("order_date='#{@order_date}' ").order(:user_id, :course_type_id)
    currency_id =  @all_orders.first ? @all_orders.first.menu.currency_type_id : CurrencyType.first.id
    @currency_name = CurrencyType.find_by_id(currency_id).name
    @all_sum = 0.00
    if @all_orders.size > 0
      sum = Order.select("sum(menus.cost) as all_sum").joins("JOIN menus on orders.menu_id = menus.id").where("order_date='#{@order_date}' ").order("all_sum")
      @all_sum = sum.first.all_sum
    end

    
    @users = User.all.sort

    @all_orders_by_user_id = @all_orders.group_by(&:user_id)


    respond_to do |format|
      format.html {render 'all_index'}
 
      format.js
    end
  end

  def create
    empty = true #for check that order is not empty
    temp_date = nil #for check that all order items on same date
    Order.transaction do
      course_type = CourseType.all
      course_type.each do |ct| 
        menu_item = params["order_item#{ct.id}"]
        if menu_item != nil
          empty = false
          @order_item = Order.new
          @order_item.menu_id = menu_item
          @order_item.course_type_id = ct.id
          @order_item.user_id = current_user.id
          @order_item.order_date = params[:order][:order_date]

          #check that order_date is equal of all order_items
          if temp_date 
            if temp_date != @order_item.order_date
              @order_item.errors.add(:base, :invalid, message: "All order items must be on same date")
              raise ActiveRecord::Rollback
              break
            end
          else
            temp_date = @order_item.order_date
          end

          if !@order_item.save         
            raise ActiveRecord::Rollback
            break
          end

        end
      end  
    end

    if empty 
      @order_item = Order.new
      @order_item.errors.add(:base, :blank, message: "Order cannot be blank")
    end

    respond_to do |format|
      format.js
    end 

  end

  def show
    @menu_item = Menu.find(params[:id])
    respond_to do |format|
      format.js
    end 
  end

  private

    #Confirms that permit user
  def permit_user
    if (!current_user.is_lunches_admin?) 
      flash[:alert] = "You not allowed to see all orders."
      respond_to do |format| 
        format.html {redirect_to(root_url)}
      end
    end
  end

end