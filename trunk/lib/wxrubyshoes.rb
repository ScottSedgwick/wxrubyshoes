require 'rubygems'
require 'wx'

module WxShoesControls
#########################################################################################################
# Miscellaneous Windows
#########################################################################################################
	def choicebook(params = {})			# Choicebook			Similar to notebook but using a choice (dropdown) control
		parent, id, pos, size, style = read_default_params(params, 0)
		my_choicebook = Wx::Choicebook.new(parent, id, pos, size, style)
		add_to_parent(my_choicebook, parent, params)
		push_container(my_choicebook) { yield } if block_given?
	end
	
	def collapsible_pane(params = {})	# TODO: CollapsiblePane		A container with a button to collapse or expand contents
	# Displays, but I can't figure out how it is supposed to work.
		parent, id, pos, size, style = read_default_params(params, 0) #Wx::CP_DEFAULT_STYLE)
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_collapsible_pane = Wx::CollapsiblePane.new(parent, id, label, pos, size, style, validator)
		add_to_parent(my_collapsible_pane, parent, params)
		push_container(my_collapsible_pane) { yield } if block_given?
	end
	
	def grid(params = {})				# TODO: Grid					A grid (table) window
	# Displays and works, but ruby exits strangely if I edit anything.
		parent, id, pos, size, style = read_default_params(params, Wx::WANTS_CHARS)
		my_grid = Wx::Grid.new(parent, id, pos, size, style)
		
		selmode = params[:selmode] || Wx::Grid::GridSelectCells
		numRows = params[:numRows]
		numCols = params[:numCols]
		table = params[:table]
		if table
			my_grid.set_table(table, selmode)
		elsif numRows && numCols
			my_grid.create_grid(numRows, numCols, selmode)
		end		
		
		add_to_parent(my_grid, parent, params)
		push_container(my_grid) { yield } if block_given?
	end
	
	def listbook(params = {})			# Listbook				Similar to notebook but using a list control
		parent, id, pos, size, style = read_default_params(params, 0)
		my_listbook = Wx::Listbook.new(parent, id, pos, size, style)
		add_to_parent(my_listbook, parent, params)
		push_container(my_listbook) { yield } if block_given?
	end
	
	def notebook(params = {})			# Notebook				Tabbed Notebook for layout out controls
		parent, id, pos, size, style = read_default_params(params, 0)
		my_notebook = Wx::Notebook.new(parent, id, pos, size, style)
		add_to_parent(my_notebook, parent, params)
		push_container(my_notebook) { yield } if block_given?
	end
	
	def panel(params = {})				# Panel					A window whose colour changes according to current user settings
		parent, id, pos, size, style = read_default_params(params, Wx::TAB_TRAVERSAL)
		my_panel = Wx::Panel.new(parent, id, pos, size, style)
		add_to_parent(my_panel, parent, params)
		push_container(my_panel) { yield } if block_given?
	end
	
	def sash_window_layout(params = {})	# TODO: SashLayoutWindow		Window that can be involved in an IDE-like layout arrangement
		parent, id, pos, size, style = read_default_params(params, Wx::SW_3D)
		my_sash_layout_window = Wx::SashLayoutWindow.new(parent, id, pos, size, style)
		add_to_parent(my_sash_layout_window, parent, params)
		push_container(my_sash_layout_window) { yield } if block_given?
	end
	
	def sash_window(params = {})		# TODO: SashWindow			Window with four optional sashes that can be dragged
		parent, id, pos, size, style = read_default_params(params, Wx::SW_3D)
		my_sash_window = Wx::SashWindow.new(parent, id, pos, size, style)
		add_to_parent(my_sash_window, parent, params)
		push_container(my_sash_window) { yield } if block_given?
	end
	
	def scrolled_window(params = {})	# TODO: ScrolledWindow		Window with automatically managed scrollbars
		parent, id, pos, size, style = read_default_params(params, (Wx::VSCROLL | Wx::HSCROLL))
		my_scrolled_window = Wx::ScrolledWindow.new(parent, id, pos, size, style) 
		add_to_parent(my_scrolled_window, parent, params)
		push_container(my_scrolled_window) { yield } if block_given?
	end
	
	def splitter_window(params = {})	# TODO: SplitterWindow		Window which can be split vertically or horizontally
		parent, id, pos, size, style = read_default_params(params, Wx::SP_3D)
		my_splitter_window = Wx::SplitterWindow.new(parent, id, pos, size, style)
		add_to_parent(my_grid, parent, params)
		push_container(my_grid) { yield } if block_given?
	end
	
	def status_bar(params = {})			# StatusBar			A status bar on a frame
		parent, id, pos, size, style = read_default_params(params, Wx::ST_SIZEGRIP)
		text = params[:text]
		my_status_bar = Wx::StatusBar.new(parent, id, style)
		parent.status_bar = my_status_bar
		my_status_bar.push_status_text text if text
		my_status_bar
	end
		
	def vscrolled_window(params = {})	# TODO: VScrolledWindow		As ScrolledWindow but supports lines of variable height
		parent, id, pos, size, style = read_default_params(params, 0)
		my_vscrolled_window = VScrolledWindow.new(parent, id, pos, size, style) 
		add_to_parent(my_vscrolled_window, parent, params)
		push_container(my_vscrolled_window) { yield } if block_given?
	end
	
	# TODO:WizardPage			A base class for a page in wizard dialog.
	# TODO:WizardPageSimple		A page in wizard dialog.
	# ToolBar				Toolbar with buttons - will not implement here.  Use Frame#create_tool_bar instead.
	
#########################################################################################################
# Window Layout
#########################################################################################################
	def box_sizer(orientation, params = {})		# BoxSizer				A sizer for laying out windows in a row or column
		my_sizer = Wx::BoxSizer.new(orientation)
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	def hbox_sizer(params = {})
		box_sizer(Wx::HORIZONTAL, params) { yield } if block_given?
	end	
	
	def vbox_sizer(params = {})
		box_sizer(Wx::VERTICAL, params) { yield } if block_given?
	end
	
	def flex_grid_sizer(params = {})			# FlexGridSizer			A sizer for laying out windows in a flexible grid
		rows = params[:rows]
		cols = params[:cols] || 0
		vgap = params[:vgap] || 0 
		hgap = params[:hgap] || 0
		my_sizer = if rows
			Wx::FlexGridSizer.new(rows, cols, vgap, hgap)
		else
			Wx::FlexGridSizer.new(cols, vgap, hgap)
		end
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	def grid_bag_sizer(params = {})				# TODO: GridBagSizer			Another grid sizer that lets you specify the cell an item is in, and items can span rows and/or columns.
		vgap = params[:vgap] || 0 
		hgap = params[:hgap] || 0
		my_sizer = Wx::GridBagSizer.new(vgap, hgap)
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	def grid_sizer(params = {})					# TODO: GridSizer				A sizer for laying out windows in a grid with all fields having the same size
		rows = params[:rows]
		cols = params[:cols] || 0
		vgap = params[:vgap] || 0 
		hgap = params[:hgap] || 0
		my_sizer = if rows
			Wx::GridSizer.new(rows, cols, vgap, hgap)
		else
			Wx::GridSizer.new(cols, vgap, hgap)
		end
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	def static_box_sizer(params = {})			# TODO: StaticBoxSizer			Same as wxBoxSizer, but with a surrounding static box
		orient = params[:orient] || Wx::VERTICAL
		my_sizer = if params[:box]
			Wx::StaticBoxSizer.new(params[:box], orient)
		else
			label = params[:label] || ''
			Wx::StaticBoxSizer.new(orient, parms[:parent], label)
		end
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	def std_dialog_button_sizer(params = {})	# StdDialogButtonSizer		Sizer for arranging buttons on a dialog, in platform-standard order
		my_sizer = Wx::StdDialogButtonSizer.new
		push_sizer(my_sizer, params) { yield } if block_given?
	end
			
	def add_spacer(params = {})
		sizer = params[:sizer] || @sizers.last
		width = params[:width] || 0 
		height = params[:height] || 0
		proportion = params[:proportion] || 0
		flag = params[:flags] || 0
		border = params[:border] || 0
		userData = params[:userData]
		sizer.add(width, height, proportion, flag, border, userData)
	end
	
#########################################################################################################
# Controls
#########################################################################################################
	def animation_ctrl(params = {})		# TODO: AnimationCtrl		For displaying a looping animation
		parent, id, pos, size, style = read_default_params(params, Wx::AC_DEFAULT_STYLE)
		anim = params[:anim]
		my_animation_ctrl = Wx::AnimationCtrl.new(parent, id, anim, pos, size, style) 
		add_to_sizer(my_animation_ctrl, params)
	end
		
	def bitmap_button(params = {})		# TODO: BitmapButton		Push button control, displaying a bitmap
		parent, id, pos, size, style = read_default_params(params, 0)
		bitmap = params[:bitmap]
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR	
		my_bitmap_button = Wx::BitmapButton.new(parent, id, bitmap, pos, size, style, validator)
		evt_button(my_bitmap_button.get_id()) { |event| yield(event) } if block_given?
		add_to_sizer(my_bitmap_button, params)
	end
	
	def bitmap_combo_box(params = {})	# TODO: BitmapComboBox	A ComboBox where each item can have an image
		parent, id, pos, size, style = read_default_params(params, 0)
		value = params[:value] || ''
		n = params[:n] || 0
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_bitmap_combo_box = Wx::BitmapComboBox.new(parent, id, value, pos, size, n, choices, style, validator)
		add_to_sizer(my_bitmap_combo_box, params)
	end
	
	def button(params = {})				# Button		Push button control, displaying text
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR		
		my_button = Wx::Button.new(parent, id, label, pos, size, style, validator)
		evt_button(my_button.get_id()) { |event| yield(event) } if block_given?
		add_to_sizer(my_button, params)
	end
	
	def calendar_ctrl(params = {})		# TODO: CalendarCtrl		Control showing an entire calendar month
		parent, id, pos, size, style = read_default_params(params, Wx::CAL_SHOW_HOLIDAYS)
		date = params[:date] || Wx::DefaultDateTime
		my_calendar_ctrl = Wx::CalendarCtrl.new(parent, id, date, pos, size, style) 
		add_to_sizer(my_calendar_ctrl, params)
	end
	
	def check_box(params = {})			# TODO: CheckBox		Checkbox control
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_checkbox = Wx::CheckBox.new(parent, id, label, pos, size, style, val)
		add_to_sizer(my_checkbox, params)
	end
	
	def check_list_box(params = {})		# TODO: CheckListBox		A listbox with a checkbox to the left of each item
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_checklistbox = Wx::CheckListBox.new(parent, id, pos, size, choices, style, validator)
		add_to_sizer(my_checklistbox, params)
	end
	
	def choice(params = {})				# TODO: Choice		Drop-down list from which the user can select one option
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_choice = Wx::Choice.new(parent, id, pos, size, choices, style, validator) 
		add_to_sizer(my_choice, params)
	end
	
	def combo_box(params = {})			# ComboBox		A drop-down Choice with an editable text area
		parent, id, pos, size, style = read_default_params(params, 0)
		value = params[:value] || ''
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_combo_box = Wx::ComboBox.new(parent, id, value, pos, size, choices, style, validator) 
		add_to_sizer(my_combo_box, params)
	end
	
	def date_picker_ctrl(params = {})	# TODO: DatePickerCtrl	Small date picker control
		parent, id, pos, size, style = read_default_params(params, (Wx::DP_DEFAULT | Wx::DP_SHOWCENTURY))
		dt = params[:dt] || Wx::DefaultDateTime
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_date_picker_ctrl = Wx::DatePickerCtrl.new(parent, id, dt, pos, size, style, validator) 
		add_to_sizer(my_date_picker_ctrl, params)
	end
	
	def gauge(params = {})				# TODO: Gauge			A control to represent a varying quantity, such as time remaining
		parent, id, pos, size, style = read_default_params(params, Wx::GA_HORIZONTAL)
		range = params[:range] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_gauge = Wx::Gauge.new(parent, id, range, pos, size, style, validator) 
		add_to_sizer(my_gauge, params)
	end
	
	def generic_dir_ctrl(params = {})	# TODO: GenericDirCtrl	A control for displaying a directory tree
		parent, id, pos, size, style = read_default_params(params, (Wx::DIRCTRL_3D_INTERNAL|Wx::SUNKEN_BORDER))
		dir = params[:dir] || Wx::DirDialogDefaultFolderStr
		filter = params[:filter] || ''
		defaultFilter = params[:defaultFilter] || 0
		my_generic_dir_ctrl = Wx::GenericDirCtrl.new(parent, id, dir, pos, size, style, filter, defaultFilter) 
		add_to_sizer(my_generic_dir_ctrl, params)
	end
	
	def html_list_box(params = {})		# TODO: HtmlListBox		A listbox showing HTML content
		parent, id, pos, size, style = read_default_params(params, 0)
		my_html_list_box = Wx::HtmlListBox.new(parent, id, pos, size, style) 
		add_to_sizer(my_html_list_box, params)
	end
	
	def hyperlink_ctrl(params = {})		# TODO: HyperlinkCtrl		Displays a clickable URL that will launch a browser
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		url = params[:url]
		my_hyperlink_ctrl = Wx::HyperlinkCtrl.new(parent, id, label, url, pos, size, style) 
		add_to_sizer(my_hyperlink_ctrl, params)
	end
	
	def list_box(params = {})			# TODO: ListBox		A list of strings for single or multiple selection
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_list_box = Wx::ListBox.new(parent, id, pos, size, choices, style, validator) 
		add_to_sizer(my_list_box, params)
	end
	
	def list_ctrl(params = {})			# TODO: ListCtrl		A control for displaying lists of strings and/or icons, plus a multicolumn report view
		parent, id, pos, size, style = read_default_params(params, Wx::LC_ICON)
		range = params[:range] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_list_ctrl = Wx::ListCtrl.new(parent, id, pos, size, style, validator) 
		add_to_sizer(my_list_ctrl, params)
	end
	
	def media_ctrl(params = {})			# TODO: MediaCtrl		A control for playing sound and video
		parent, id, pos, size, style = read_default_params(params, 0)
		fileName = params[:fileName] || ''
		backend = params[:backend] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_media_ctrl = Wx::MediaCtrl.new(parent, id, fileName, pos, size, style, backend, validator) 
		add_to_sizer(my_media_ctrl, params)
	end
	
	def radio_box(params = {})			# RadioBox		A group of radio buttons
		parent, id, pos, size, style = read_default_params(params, Wx::RA_SPECIFY_COLS)
		label = params[:label] 
		n = params[:n] || 0 
		choices = params[:choices]
		major_dimension = params[:major_dimension] || 0 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_radio_box = Wx::RadioBox.new(parent, id, label, pos, size, choices, major_dimension, style, validator) 
		evt_radiobox(my_radio_box.get_id()) {|event| yield(event)} if block_given?
		add_to_sizer(my_radio_box, params)
	end
	
	def radio_button(params = {})		# TODO: RadioButton		A round button to be used with others in a mutually exclusive way
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_radio_button = Wx::RadioButton.new(parent, id, label, pos, size, style, validator) 
		add_to_sizer(my_radio_button, params)
	end
	
	def rich_text_ctrl(params = {})		# TODO: RichTextCtrl		Advanced text-editing control with styles and inline images
		parent, id, pos, size, style = read_default_params(params, Wx::RE_MULTILINE)
		value = params[:value] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_rich_text_ctrl = Wx::RichTextCtrl.new(parent, id, value, pos, size, style, validator) 
		add_to_sizer(my_rich_text_ctrl, params)
	end
	
	def scroll_bar(params = {})			# TODO: ScrollBar		Scrollbar control
		parent, id, pos, size, style = read_default_params(params, Wx::SB_HORIZONTAL)
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_scroll_bar = Wx::ScrollBar.new(parent, id, pos, size, style, validator) 
		add_to_sizer(my_scroll_bar, params)
	end 

	def slider(params = {})				# TODO: Slider		A slider that can be dragged by the user
		parent, id, pos, size, style = read_default_params(params, Wx::SL_HORIZONTAL)
		value = params[:value] 
		minValue = params[:minValue] 
		maxValue = params[:maxValue] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_slider = Wx::Slider.new(parent, id, value, minValue, maxValue, pos, size, style, validator) 
		add_to_sizer(my_slider, params)
	end

	def spin_button(params = {})		# TODO: SpinButton		A spin or up-down control
		parent, id, pos, size, style = read_default_params(params, Wx::SP_HORIZONTAL)
		my_spin_button = Wx::SpinButton.new(parent, id, pos, size, style) 
		add_to_sizer(my_spin_button, params)
	end

	def spin_ctrl(params = {})			# TODO: SpinCtrl		A spin control - i.e. spin button and text control
		parent, id, pos, size, style = read_default_params(params, Wx::SP_ARROW_KEYS)
		value = params[:value] || ''
		min = params[:min] || 0 
		max = params[:max] || 100
		initial = params[:initial] || 0
		my_spin_ctrl = Wx::SpinCtrl.new(parent, id, value, pos, size, style, min, max, initial) 
		add_to_sizer(my_spin_ctrl, params)
	end

	def static_bitmap(params = {})		# TODO: StaticBitmap		A control to display a bitmap
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		my_static_bitmap = Wx::StaticBitmap.new(parent, id, label, pos, size, style) 
		add_to_sizer(my_static_bitmap, params)
	end
	
	def static_box(params = {})			# TODO: StaticBox		A static, or group box for visually grouping related controls
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		my_static_box = Wx::StaticBox.new(parent, id, label, pos, size, style)
		add_to_sizer(my_static_box, params)
	end
	
	def static_text(params = {})		# StaticText		One or more lines of non-editable text
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		my_label = Wx::StaticText.new(parent, id, label, pos, size, style)
		add_to_sizer(my_label, params)		
        my_label
	end
	
	# TODO:StyledTextCtrl	Sophisticated code text editor based on Scintilla
	# Do later - the wxRuby documentation doesn't include the contructor...WTF?
	
	def text_ctrl(params = {})			# TextCtrl		Single or multiline text editing control
		parent, id, pos, size, style = read_default_params(params, 0)
		value = params[:value] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_text_ctrl = Wx::TextCtrl.new(parent, id, value, pos, size, style, validator)
		add_to_sizer(my_text_ctrl, params)
	end
	
	def toggle_button(params = {})		# TODO: ToggleButton		A button which stays pressed when clicked by user.
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_toggle_button = Wx::ToggleButton.new(parent, id, label, pos, size, style, validator) 
		add_to_sizer(my_toggle_button, params)
	end

	def tree_ctrl(params = {})			# TODO: TreeCtrl		Tree (hierarchy) control
		parent, id, pos, size, style = read_default_params(params, Wx::TR_HAS_BUTTONS)
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_tree_ctrl = Wx::TreeCtrl.new(parent, id, pos, size, style, validator) 
		add_to_sizer(my_tree_ctrl, params)
	end 

	def vlist_box(params = {})			# TODO: VListBox		A listbox supporting variable height rows
		parent, id, pos, size, style = read_default_params(params, 0)
		countItems = params[:countItems] || 0
		my_vlist_box = Wx::VListBox.new(parent, id, pos, size, countItems, style) 
		add_to_sizer(my_vlist_box, params)
	end

	
#########################################################################################################
# Menus
#########################################################################################################
	def menu(title = '', style = 0)		# Menu			Displays a series of menu items for selection
		my_menu = Wx::Menu.new('', style)
		@containers.last.append(my_menu, title)
		push_container(my_menu) { yield } if block_given?
	end
	
	def menu_bar(style = 0)				# MenuBar		Contains a series of menus for use with a frame
		my_menu_bar = Wx::MenuBar.new(style)
		@containers.first.set_menu_bar(my_menu_bar)
		push_container(my_menu_bar) { yield } if block_given?
	end
	
	def menu_item(parentMenu = nil, id = -1, text = '', helpString = '', kind = Wx::ITEM_NORMAL, subMenu = nil, checked = false)		# MenuItem		Represents a single menu item
		puts "Creating menu item #{text}. Checked = #{checked}.  Kind = #{kind}"
		puts "Normal = #{Wx::ITEM_NORMAL}"
		puts "Checked = #{Wx::ITEM_CHECK}"
		parentMenu = @containers.last unless parentMenu
		if parentMenu.class.method_defined?(:append_item)
			my_menu_item = Wx::MenuItem.new(parentMenu, id, text, helpString, kind)
			parentMenu.append_item(my_menu_item)
			if (kind == Wx::ITEM_CHECK) && params[:checked]
				puts "Checking menu item #{text}"
				my_menu_item.check(true) 
			end
			@containers.first.evt_menu(my_menu_item) { |event| yield(event) } if block_given?
		end
	end
	
	def menu_separator
		menu_item(:id => Wx::ID_SEPARATOR, :kind => Wx::ITEM_SEPARATOR)
	end

#########################################################################################################
# Rich text classes
#########################################################################################################
	# TODO: RichTextAttr							Definition of text style properties
	# TODO: RichTextBuffer						The internal representation of a RichTextCtrl’s contents
	# TODO: RichTextCharacterStyleDefinition		A named character-level style
	# TODO: RichTextCtrl							GUI widget for editing rich text
	# TODO: RichTextEvent							Events specific to RichText
	# TODO: RichTextFileHandler					Base class for reading and writing rich text
	# TODO: RichTextFormattingDialog				Dialog for editing rich text styles
	# TODO: RichTextHeaderFooterData				Helper class for printing headers and footers
	# TODO: RichTextHTMLHandler					Export rich text to HTML
	# TODO: RichTextStyleDefinition				Base class for named styles
	# TODO: RichTextParagraphStyleDefinition		A named style for paragraph properties
	# TODO: RichTextPrinting						Convenient printing of rich text content
	# TODO: RichTextPrinting						Helper class for printing rich text
	# TODO: RichTextStyleListBox					Control which previews and allows selection of styles from a stylesheet
	# TODO: RichTextStyleListCtrl					Combined control for choosing styles from a stylesheet
	# TODO: RichTextStyleSheet					A collection of named styles that can be applied to text
	# TODO: RichTextXMLHandler					Import and export rich text in XML

#########################################################################################################
# HTML classes
#########################################################################################################
	# TODO: HtmlHelpController	HTML help controller class
	# TODO: HtmlWindow			HTML window class, for displaying HTML
	# TODO: HtmlEasyPrinting		Simple but useful class for printing HTML
	
#########################################################################################################
# Helper methods
#########################################################################################################
private
	def add_to_page(container, parent, params)
		title = params[:title] || ''
		selected = params[:selected] || false
		imageId = params[:imageId] || -1
		parent.add_page(container, title, selected, imageId) 
	end
	
	def add_to_parent(container, parent, params)
		add_to_page(container, parent, params) if parent.class.method_defined?(:add_page)
	end
	
	def add_to_sizer(control, params = {})
		sizer = params[:sizer] || @sizers.last
		if sizer
			proportion = params[:proportion] || 0
			flag = params[:flag] || (Wx::GROW|Wx::ALL)
			border = params[:border] || 2 
			userData = params[:userData]
			sizer.add(control, proportion, flag, border, userData)
		end
		control
	end
	
	def push_container(container)
		@containers.push(container)
		yield
		@containers.pop
		container
	end
	
	def push_sizer(sizer, params = {})
		if params[:container]
			params[:container].set_sizer(sizer)
		elsif @sizers.empty?
			@containers.last.set_sizer(sizer)
		else
			add_to_sizer(sizer, params)
		end
		@sizers.push sizer
		yield
		@sizers.pop
		sizer
	end
	
	def read_default_params(params, default_style)
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
		pos = params[:pos] || Wx::DEFAULT_POSITION
		size = params[:size] || Wx::DEFAULT_SIZE
		style = params[:style] || default_style
		return [parent, id, pos, size, style]
	end
end

class WxShoesFrame < Wx::Frame
	include WxShoesControls
	def initialize(params = {})		
		@containers = []
		@containers.push(self)
		@sizers = []
		parent, id, pos, size, style = read_default_params(params, Wx::DEFAULT_FRAME_STYLE)
		parent = parent.instance_of?(Wx::Window) ? parent : nil
		title = params[:title]
		controller = params[:controller]
		super(parent, id, title, pos, size, style)
		self.icon = params[:icon] if params[:icon]
		extend(controller) if controller
	end
end

class WxShoesApp < Wx::App	
	def initialize &block
		super()
		@block = block if block_given?
	end
	
	def on_init
		cloaker(&@block).bind(self).call if @block
	end
	
	def frame(params, &block)
		@frame = WxShoesFrame.new(params, &block)
		@frame.icon = params[:icon] if params[:icon]
		@frame.show
	end
	
  	def cloaker(&block)
		(class << self; self; end).class_eval do
			define_method :cloaker_, &block
			meth = instance_method( :cloaker_ )
			remove_method :cloaker_
			meth
		end 
	end
end

module WxShoes
	def self.App(&block)
		my_app = WxShoesApp.new &block
		my_app.main_loop
	end
end
