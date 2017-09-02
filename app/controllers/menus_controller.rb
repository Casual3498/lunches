class MenusController < ApplicationController
  before_action :set_menu, only: [:destroy, :edit, :update]
 # before_action :set_variables_for_index, only: []


  def index
    set_variables_for_index
    @menu = Menu.new
  end


  def new
    debugger
    @menu = Menu.new
    debugger
  end

  def create
    #debugger
    @menu = Menu.new(menu_params)
    @menu.menu_date = Date.today
    #debugger 
    respond_to do |format|
      if @menu.save
        set_variables_for_index

        #format.html { redirect_to menus_path, notice: 'Menu item was successfully created.'}
        format.js
        # format.json { render json: @menu, status: :created, location: menus_path }
        #byebug
        #@menu = Menu.new
      else
        #format.html { render action: "index" }
        #byebug
        format.js
        #format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end    

  end




  def delete
    #debugger
    @menu = Menu.find(params[:menu_id])
  end


  def destroy
   # debugger
    @menu.destroy
    flash[:success] = "Menu item deleted"  
    redirect_to menus_path 
  end


  def update


    @menu.update_attributes(menu_params)
    set_variables_for_index
    #@menu.update!(menu_params)
    #debugger
  end


  private

    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :cost, :course_type_id, :currency_type_id, :picture)
    end  
 
    def set_variables_for_index
    
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @options = {holidays: ['2017-01-01', '2017-07-28'], weekdays: ['2017-07-30']}
      @menus_today = Menu.all.where("menu_date='#{Date.today}' ").order(:name)
      @currency_id =  @menus_today.first ? @menus_today.first.currency_type_id : CurrencyType.first.id
      @currency_name = CurrencyType.find_by_id(@currency_id).name

      #debugger
      @currency_type = CurrencyType.all
      @course_type = CourseType.all

      @menus_by_course_type = @menus_today.group_by(&:course_type_id)
    end


end
