module CalendarHelper
  START_DAY = :monday

  def calendar(date = Date.today, options = {}, &block)
    defaults = {
      :holidays => [],
      :weekdays => []
    }
    options = defaults.merge options

    Calendar.new(self, date, options , block).table
  end

  def text_of_week(date)
    return_text = "";
    first = date.beginning_of_week(START_DAY)
    last = date.end_of_week(START_DAY)
    
    return_text << "week " << ((START_DAY == :monday)? date.strftime("%W ") : date.strftime("%U "));
    return_text << (first.strftime("%B") << ((first.mday > last.mday)? "&ndash;" << last.strftime("%B"):""))
    return_text << date.strftime(" %Y")
    return_text.html_safe
  end

  class Calendar < Struct.new(:view, :date, :options, :callback)

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header_row + week_row
      end
    end

    def header_row
      hr = []
      hr << "<tr>"
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
      holidays = options[:holidays]
      #debugger
      weekdays = options[:weekdays]
      #:options['holidays']
      classes = []
      classes << "today" if day == Date.today
      #classes << "notmonth" if day.month != date.month
      classes << "holidays" if ( [0,6].include?(day.wday)  || holidays.include?(day.to_s) ) && !weekdays.include?(day.to_s)
      classes << "weekdays" if ( (1..5).include?(day.wday) && !holidays.include?(day.to_s) ) || weekdays.include?(day.to_s)
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