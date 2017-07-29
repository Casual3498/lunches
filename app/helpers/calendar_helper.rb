module CalendarHelper
  START_DAY = :monday

  def calendar(date = Date.today, holidays=[], workdays=[], &block)

    Calendar.new(self, date, holidays, workdays, block).table
  end

  def month_of_week(date)
    first = date.beginning_of_week(START_DAY)
    last = date.end_of_week(START_DAY)
    (first.strftime("%B") << ((first.mday > last.mday)? "&ndash;" << last.strftime("%B"):"")).html_safe
  end

  class Calendar < Struct.new(:view, :date, :holidays, :workdays, :callback)

    

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header_row + week_row
      end
    end

    def header_row
      hr = []
      hr << "<tr>"
      #debugger
      header.each { |day| 
        day.each { |key,value| 
          hr << "<th " << "class=#{day_classes(key).inspect}"  <<">" << "#{value}" << "</th>" 
        }
      }
      hr << '</tr>'

      hr.join.html_safe

    end

    def week_row
      content_tag :tr do
        week.map { |day| day_cell(day) }.join.html_safe
      end
    end


    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.today
      #classes << "notmonth" if day.month != date.month
      classes << "holidays" if ( [0,6].include?(day.wday)  || holidays.include?(day.to_s) ) && !workdays.include?(day.to_s)
      classes << "weekdays" if ( (1..5).include?(day.wday) && !holidays.include?(day.to_s) ) || workdays.include?(day.to_s)
      classes.empty? ? nil : classes.join(" ")
    end


    def week
      first = date.beginning_of_week(START_DAY)
      last = date.end_of_week(START_DAY)
      (first..last).to_a
    end

    def header
      first = date.beginning_of_week(START_DAY)
      last = date.end_of_week(START_DAY)
      (first..last).map { |day| { day => day.strftime("%A") } }  
    end
      
  end
end