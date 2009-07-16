#!/usr/bin/env ruby
# wxRuby2 Sample Code. Copyright (c) 2004-2008 wxRuby development team
# Freely reusable code: see SAMPLES-LICENSE.TXT for details
require 'rubygems' 
require 'wx'
require 'wxrubyshoes'
include Wx

Calendar_Cal_Monday = 200
Calendar_Cal_Holidays = 201
Calendar_Cal_Special = 202
Calendar_Cal_Month = 203
Calendar_Cal_Year = 204
Calendar_Cal_SeqMonth = 205
Calendar_Cal_SurroundWeeks = 206


module MyCalendarModule
	def self.attach(calendar)
		calendar.extend(MyCalendarModule)
	    @weekday_names = %w|Sun Mon Tue Wed Thu Fri Sat|

	    calendar.evt_calendar calendar, :on_calendar
	    calendar.evt_calendar_month calendar, :on_cal_month_change
	    calendar.evt_calendar_year calendar, :on_cal_year_change
	    calendar.evt_calendar_sel_changed calendar, :on_calendar_change
	    calendar.evt_calendar_weekday_clicked calendar, :on_calendar_weekday_click
	end

	def on_calendar(event)
		@display.date = event.date
	end

	def on_calendar_change(event)
		@date = event.date
		log_status("Selected date: #{@date.strftime('%A %d %B %Y')}")
	end

	def on_cal_month_change
		log_status("Calendar month changed")
	end

	def on_cal_year_change
		log_status("Calendar year changed")
	end

	def on_calendar_weekday_click(event)
		wday = event.week_day
		log_status("Clicked on #{@weekday_names[wday]}")
	end

	attr_reader :date
end

module MyFrameController
	def on_quit
		# true is to force the frame to close
		close(true)
	end

	def on_about
		message_box("wxRuby CalendarCtrl sample\nby Kevin Smith\n" +
					"based on the wxWidgets version by Vadim Zeitlin",
					"About Calendar", OK | ICON_INFORMATION, self)
	end

  def on_cal_monday(event)
    enable = get_menu_bar().is_checked(event.get_id())
    toggle_cal_style(enable, CAL_MONDAY_FIRST)
  end

  def on_cal_holidays(event)
    enable = get_menu_bar().is_checked(event.get_id())
    @calendar.enable_holiday_display(enable)
  end

  def on_cal_special(event)
    highlight_special(get_menu_bar().is_checked(event.get_id()))
  end

  def on_cal_allow_month(event)
    allow = get_menu_bar().is_checked(event.get_id())
    @calendar.enable_month_change(allow)
  end

  def on_cal_allow_year(event)
    allow = get_menu_bar().is_checked(event.get_id())
    @calendar.enable_year_change(allow)
  end

  def on_cal_seq_month(event)
    allow = get_menu_bar().is_checked(event.get_id())
    toggle_cal_style(allow, CAL_SEQUENTIAL_MONTH_SELECTION)
  end

  def on_cal_show_surrounding_weeks(event)
    allow = get_menu_bar().is_checked(event.get_id())
    toggle_cal_style(allow, CAL_SHOW_SURROUNDING_WEEKS)
  end

  def on_allow_year_update(event)
    event.enable( get_menu_bar().is_checked(Calendar_Cal_Month))
  end

  def toggle_cal_style(on,flag)
    style = @calendar.get_window_style_flag
    date = @calendar.date
    @sizer.detach(@calendar)
    @calendar.destroy
    if  on
      style |= flag
    else
      style &= ~flag
    end
	@calendar = calendar_ctrl(:date => date, :style => style, :parent => @panel, :sizer => @sizer)
	MyCalendarModule.attach(@calendar)
    @sizer.add(@calendar, 0, Wx::ALIGN_CENTRE|Wx::ALL, 5)
    @panel.layout
  end

  def highlight_special(on)
    if on
      attr_red_circle = CalendarDateAttr.new(CAL_BORDER_ROUND, RED)
      attr_green_square = CalendarDateAttr.new(CAL_BORDER_SQUARE, GREEN)
      # This wraps correctly, but causes problems because the colour is freed
      # when the attribute is reset.
      #
      # attr_header_like = CalendarDateAttr.new(BLUE, LIGHT_GREY)

      @calendar.set_attr(17, attr_red_circle)
      @calendar.set_attr(29, attr_green_square)
      # @calendar.set_attr(13, attr_header_like)
    else
      @calendar.reset_attr(17)
      @calendar.reset_attr(29)
      # @calendar.reset_attr(13)
    end
    @calendar.refresh()
  end

  def set_date(d)
    str = "%s-%s-%s" % [ d.year, d.mon, d.day ]
    Wx::MessageDialog.new( self, "The selected date is #{str}", 
                           "Date chosen" ).show_modal
  end
end

WxShoes.App do
	frame(:controller => MyFrameController) do
		menu_bar do
			menu(:title => '&File') do
				menu_item(:text => "&About...\tCtrl-A", :helpString => "Show about dialog") { |event| on_about }
			    menu_separator
			    menu_item(:text => "E&xit\tAlt-X", :helpString => "Quit self program") { |event| on_quit }
			end
			menu(:title => '&Calendar') do
			    menu_item(:text => "Monday &first weekday\tCtrl-F", 
						  :helpString => "Toggle between Mon and Sun as the first week day",
						  :checked => true,
			              :style => ITEM_CHECK) { |event| on_cal_monday(event) }
			    menu_item(:text => "Show &holidays\tCtrl-H",
			              :helpString => "Toggle highlighting the holidays",
						  :checked => true,
			              :style => ITEM_CHECK) { |event| on_cal_holidays(event) }
			    menu_item(:text => "Highlight &special dates\tCtrl-S",
			              :helpString => "Test custom highlighting",
			              :style => ITEM_CHECK) { |event| on_cal_special(event) }
			    menu_item(:text => "Show s&urrounding weeks\tCtrl-W",
			              :helpString => "Show the neighbouring weeks in the prev/next month",
			              :style => ITEM_CHECK) { |event| on_cal_show_surrounding_weeks(event) }
			    menu_separator
			    menu_item(:text => "To&ggle month selector style\tCtrl-G",
			              :helpString => "Use another style for the calendar controls",
			              :style => ITEM_CHECK) { |event| on_cal_seq_month(event) }
			    menu_item(:text => "&Month can be changed\tCtrl-M",
			              :helpString => "Allow changing the month in the calendar",
						  :checked => true,
			              :style => ITEM_CHECK) { |event| on_cal_allow_month(event) }
			    menu_item(:text => "&Year can be changed\tCtrl-Y",
			              :helpString => "Allow changing the year in the calendar",
						  :checked => true,
			              :style => ITEM_CHECK) { |event| on_cal_allow_year(event) }
			end
			# menu_bar.check(Calendar_Cal_Monday, TRUE)
			# menu_bar.check(Calendar_Cal_Holidays, TRUE)
			# menu_bar.check(Calendar_Cal_Month, TRUE)
			# menu_bar.check(Calendar_Cal_Year, TRUE)
		end
		status_bar(:text => 'Welcome to Windows!')
		@panel = panel do
			@sizer = vbox_sizer do
				@calendar = calendar_ctrl(:date => Time.now, :style => (CAL_MONDAY_FIRST | CAL_SHOW_HOLIDAYS), :flag => (ALIGN_CENTRE|ALL))
				MyCalendarModule.attach(@calendar)
			end
		end
		@panel.layout
	end
end

class MyFrame < Frame
  def initialize(title)

  	evt_update_ui Calendar_Cal_Year, :on_allow_year_update
  end
  
end
