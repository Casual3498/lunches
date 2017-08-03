class MenusController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @options = {holidays: ['2017-01-01', '2017-07-28'], weekdays: ['2017-07-30']}
    @menus = Menu.all
    @menus_by_date = @menus.group_by(&:menu_date)
   # @menus_by_date_course = @menus.where("menu_date=#{:menu_date}  and course_type_id=#{:course_type_id}")
  end

  def show
  end
end
