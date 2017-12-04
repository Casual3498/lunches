class MenusController < ApplicationController
  
  before_action :set_menu, only: [:destroy, :edit, :update]
  before_action :admin_user, only: [:new, :create, :destroy, :edit, :update]


  def index
    set_variables_for_index
    @menu = Menu.new
  end


  # def new
  #   #@menu = Menu.new
  # end

  def create

    @menu = Menu.new(menu_params)
    if @menu.save
      set_variables_for_index
    end

    respond_to do |format|
      format.js
    end    
  end

  def delete
    @menu = Menu.find(params[:menu_id]) 
  end

  def destroy
    if valid_destroy? && @menu.destroy
      set_variables_for_index
    end
    respond_to do |format|
      format.js
    end  
  end


  def update
    if @menu.update_attributes(menu_params)
      set_variables_for_index
    end
  end


  private

    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :cost, :course_type_id, :currency_type_id, :picture, :menu_date)
    end  

    #Confirms an admin user
    def admin_user
      if (!current_user.is_lunches_admin?)  
        flash[:alert] = "You not allowed to edit menu."
        redirect_to(root_url)
      end
    end
 
    def set_variables_for_index
 
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @options = {holidays: Rails.configuration.holidays, weekdays: Rails.configuration.weekdays}
      @menus_today = Menu.all.where("menu_date='#{Date.current}' ").order(:name)
      @currency_id =  @menus_today.first ? @menus_today.first.currency_type_id : CurrencyType.first.id
      @currency_name = CurrencyType.find_by_id(@currency_id).name

      @currency_type = CurrencyType.all
      @course_type = CourseType.all

      @menus_by_course_type = @menus_today.group_by(&:course_type_id)
    end

    def valid_destroy?
      if Order.find_by menu_id: @menu.id
        @menu.errors.add(:base, :invalid, message: "You can not delete the menu item because there is an order that includes this item.")
        return false
      end
      if @menu.menu_date != Date.current
        @menu.errors.add(:base, :invalid, message: "You can not delete the menu item because this item not from today menu.")
        return false
      end        
      true
    end


end
