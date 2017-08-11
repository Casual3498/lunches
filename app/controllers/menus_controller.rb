class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :destroy]


  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @options = {holidays: ['2017-01-01', '2017-07-28'], weekdays: ['2017-07-30']}
    @menus_today = Menu.all.where("menu_date='#{Date.today}' ")
    @currency =  CurrencyType.first
    @currency_name = @currency.name
    @currency_id = @currency.id

    @currency_type = CurrencyType.all

    @course_type = CourseType.all
    @course_type_by_id = @course_type.group_by(&:id)
    @menus_by_course_type = @menus_today.group_by(&:course_type_id)

  end

  def show
  end



  def create
  end

  def new
    @menu = Menu.new
  end

  def destroy
    @menu.destroy
    flash[:success] = "Menu item deleted"
    redirect_to menus_path
  end



  private

    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :cost)
    end  

end
