require 'wxrubyshoes'
include Wx

module MyFrameController
	def verify(event)
		self.cursor = HOURGLASS_CURSOR
		begin
			# Set up the Excel output file
			@status.push_status_text "Sorry, I've ripped the guts out.  It's only an example..."
		ensure
			self.cursor = STANDARD_CURSOR
		end
	end
	
	def open_file1(event)
		result, filename = open_file('Select a Ruby file:', '*.rb')
		@txtFile1.value = filename if result
	end
	
	def open_file2(event)
		result, filename = open_file('Select an XML file:', '*.xml')
		@txtFile2.value = filename if result
	end
	
	def open_file3(event)
		result, filename = open_file('Save to an Excel file:', '*.xls', FD_SAVE)
		@txtFile3.value = filename if result
	end
	
	def open_file(caption, wildcard, style = FD_OPEN)
		fd = Wx::FileDialog.new(self, caption, '', '', wildcard, style)
		result = (fd.show_modal == ID_OK)
		[result, "#{fd.directory}\\#{fd.filename}"]
	end
end

WxShoes.App do 
	frame :title => 'wxRubyShoes example', :controller => MyFrameController, :size => Size.new(600, 500) do
		set_min_size Size.new(300, 205)
		menu_bar do
			menu :title => '&File' do
				menu_item(:text => 'Hello') { puts "Hello" }
				menu_separator
				menu_item(:text => 'Goodbye') { puts "Goodbye" }
			end
			menu :title => '&Edit' do
				menu_item(:text => 'Bonjour') { puts "Bonjour" }
				menu_separator
				menu_item(:text => 'Au Revoir') { puts "Au Revoir" }
			end
		end
		notebook do
			panel(:title => 'Panel 1') do
				vbox_sizer do
					flex_grid_sizer :cols => 3, :rows => 4 do
						@sizers.last.add_growable_col(1)
						btn_size = Size.new(25, 25)
						
						static_text :label => 'First file:'
						@txtFile1 = text_ctrl(:value => 'file1.rb')
						button(:label => '...', :size => btn_size) { |event| open_file1(event) }
						
						static_text :label => 'Second file:'
						@txtFile2 = text_ctrl(:value => 'file2.xml')
						button(:label => '...', :size => btn_size) { |event| open_file2(event) }
						
						static_text :label => 'Third file:'
						@txtFile3 = text_ctrl(:value => 'file3.xls')
						button(:label => '...', :size => btn_size) { |event| open_file3(event) }
					end	
					vbox_sizer do
						button(:label => 'Do something', :flag => ALIGN_RIGHT|ALL) { |event| verify(event) }
					end
				end
			end
			listbook(:title => 'Listbox 1', :selected => true) do
				choicebook(:title => 'Choicebook 1') do
					panel(:title => 'Panel 3') do
						vbox_sizer do
							static_text(:label => 'Panel 3')
						end
					end
					grid(:title => 'Grid 1', :numRows => 3, :numCols => 4, :selected => true)
				end
				panel(:title => 'Panel 2')
			end
		end
		@status = status_bar(:text => 'Idle')
	end
end
