class MenuController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  #  @date = Date.today
    @holidays = ['2017-01-01', '2017-07-28']
    @weekdays = ['2017-07-30']
  end
end
