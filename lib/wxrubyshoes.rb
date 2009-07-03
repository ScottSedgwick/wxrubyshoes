require 'rubygems'
require 'wx'

module WxShoesControls
#########################################################################################################
# Miscellaneous Windows
#########################################################################################################
	# TODO: Choicebook			Similar to notebook but using a choice (dropdown) control
	def choicebook(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		my_choicebook = Wx::Choicebook.new(parent, id, pos, size, style)
		add_to_parent(my_choicebook, parent, params)
		push_container(my_choicebook) { yield } if block_given?
	end
	
	# TODO: CollapsiblePane		A container with a button to collapse or expand contents
	def collapsible_pane(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::CP_DEFAULT_STYLE)
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_collapsible_pane = Wx::CollapsiblePane.new(parent, id, label, pos, size, style, validator)
		add_to_parent(my_collapsible_pane, parent, params)
		push_container(my_collapsible_pane) { yield } if block_given?
	end
	
	# TODO: Grid					A grid (table) window
	def grid(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::WANTS_CHARS)
		my_grid = Wx::Grid.new(parent, id, pos, size, style)
		add_to_parent(my_grid, parent, params)
		push_container(my_grid) { yield } if block_given?
	end
	
	# TODO: Listbook				Similar to notebook but using a list control
	def listbook(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		my_listbook = Wx::Listbook.new(parent, id, pos, size, style)
		add_to_parent(my_listbook, parent, params)
		push_container(my_listbook) { yield } if block_given?
	end
	
	# Notebook				Tabbed Notebook for layout out controls
	def notebook(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		my_notebook = Wx::Notebook.new(parent, id, pos, size, style)
		add_to_parent(my_notebook, parent, params)
		push_container(my_notebook) { yield } if block_given?
	end
	
	# Panel				A window whose colour changes according to current user settings
	def panel(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::TAB_TRAVERSAL)
		my_panel = Wx::Panel.new(parent, id, pos, size, style)
		add_to_parent(my_panel, parent, params)
		push_container(my_panel) { yield } if block_given?
	end
	
	# TODO: SashLayoutWindow		Window that can be involved in an IDE-like layout arrangement
	def sash_window_layout(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SW_3D)
		my_sash_layout_window = Wx::SashLayoutWindow.new(parent, id, pos, size, style)
		add_to_parent(my_sash_layout_window, parent, params)
		push_container(my_sash_layout_window) { yield } if block_given?
	end
	
	# TODO: SashWindow			Window with four optional sashes that can be dragged
	def sash_window(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SW_3D)
		my_sash_window = Wx::SashWindow.new(parent, id, pos, size, style)
		add_to_parent(my_sash_window, parent, params)
		push_container(my_sash_window) { yield } if block_given?
	end
	
	# TODO: ScrolledWindow		Window with automatically managed scrollbars
	def scrolled_window(params = {})
		parent, id, pos, size, style = read_default_params(params, (Wx::VSCROLL | Wx::HSCROLL))
		my_scrolled_window = Wx::ScrolledWindow.new(parent, id, pos, size, style) 
		add_to_parent(my_scrolled_window, parent, params)
		push_container(my_scrolled_window) { yield } if block_given?
	end
	
	# TODO: SplitterWindow		Window which can be split vertically or horizontally
	def splitter_window(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SP_3D)
		my_splitter_window = Wx::SplitterWindow.new(parent, id, pos, size, style)
		add_to_parent(my_grid, parent, params)
		push_container(my_grid) { yield } if block_given?
	end
	
	# StatusBar			A status bar on a frame
	def status_bar(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::ST_SIZEGRIP)
		text = params[:text]
		my_status_bar = Wx::StatusBar.new(parent, id, style)
		parent.status_bar = my_status_bar
		my_status_bar.push_status_text text if text
		my_status_bar
	end
	
	##ToolBar				Toolbar with buttons - will not implement here.  Use Frame#create_tool_bar instead.
	
	# TODO: VScrolledWindow		As ScrolledWindow but supports lines of variable height
	def vscrolled_window(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		my_vscrolled_window = VScrolledWindow.new(parent, id, pos, size, style) 
		add_to_parent(my_vscrolled_window, parent, params)
		push_container(my_vscrolled_window) { yield } if block_given?
	end
	
	# TODO:WizardPage			A base class for a page in wizard dialog.
	# TODO:WizardPageSimple		A page in wizard dialog.
	
	def push_container(container)
		@containers.push(container)
		yield
		@containers.pop
		container
	end
	
	def add_to_parent(container, parent, params)
		add_to_page(container, parent, params) if parent.class.method_defined?(:add_page)
	end
	
	def add_to_page(container, parent, params)
		title = params[:title] || ''
		selected = params[:selected] || false
		imageId = params[:imageId] || -1
		parent.add_page(container, title, selected, imageId) 
	end
	
#########################################################################################################
# Window Layout
#########################################################################################################
	# BoxSizer				A sizer for laying out windows in a row or column
	def box_sizer(orientation, params = {})
		my_sizer = Wx::BoxSizer.new(orientation)
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	def hbox_sizer(params = {})
		box_sizer(Wx::HORIZONTAL, params) { yield } if block_given?
	end	
	
	def vbox_sizer(params = {})
		box_sizer(Wx::VERTICAL, params) { yield } if block_given?
	end
	
	# FlexGridSizer			A sizer for laying out windows in a flexible grid
	def flex_grid_sizer(params = {})
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
	
	# TODO: GridBagSizer			Another grid sizer that lets you specify the cell an item is in, and items can span rows and/or columns.
	def grid_bag_sizer(params = {})
		vgap = params[:vgap] || 0 
		hgap = params[:hgap] || 0
		my_sizer = Wx::GridBagSizer.new(vgap, hgap)
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	# TODO: GridSizer				A sizer for laying out windows in a grid with all fields having the same size
	def grid_sizer(params = {})
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
	
	# TODO: StaticBoxSizer			Same as wxBoxSizer, but with a surrounding static box
	def static_box_sizer(params = {})
		orient = params[:orient] || Wx::VERTICAL
		my_sizer = if params[:box]
			Wx::StaticBoxSizer.new(params[:box], orient)
		else
			label = params[:label] || ''
			Wx::StaticBoxSizer.new(orient, parms[:parent], label)
		end
		push_sizer(my_sizer, params) { yield } if block_given?
	end
	
	# StdDialogButtonSizer		Sizer for arranging buttons on a dialog, in platform-standard order
	def std_dialog_button_sizer(params = {})
		my_sizer = Wx::StdDialogButtonSizer.new
		push_sizer(my_sizer, params) { yield } if block_given?
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
	
	def add_to_sizer(control, params = {})
		sizer = params[:sizer] || @sizers.last
		proportion = params[:proportion] || 0
		flag = params[:flag] || (Wx::GROW|Wx::ALL)
		border = params[:border] || 2 
		userData = params[:userData]
		sizer.add(control, proportion, flag, border, userData)
		control
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
	# TODO: AnimationCtrl		For displaying a looping animation
	def animation_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::AC_DEFAULT_STYLE)
		anim = params[:anim]
		my_animation_ctrl = Wx::AnimationCtrl.new(parent, id, anim, pos, size, style) 
		add_to_sizer(my_animation_ctrl, params)
	end
	
	# TODO: BitmapButton		Push button control, displaying a bitmap
	def bitmap_button(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		bitmap = params[:bitmap]
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR	
		my_bitmap_button = Wx::BitmapButton.new(parent, id, bitmap, pos, size, style, validator)
		evt_button(my_bitmap_button.get_id()) { |event| yield(event) } if block_given?
		add_to_sizer(my_bitmap_button, params)
	end
	
	# TODO: BitmapComboBox	A ComboBox where each item can have an image
	def bitmap_combo_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		value = params[:value] || ''
		n = params[:n] || 0
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_bitmap_combo_box = Wx::BitmapComboBox.new(parent, id, value, pos, size, n, choices, style, validator)
		add_to_sizer(my_bitmap_combo_box, params)
	end
	
	# Button		Push button control, displaying text
	def button(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR		
		my_button = Wx::Button.new(parent, id, label, pos, size, style, validator)
		evt_button(my_button.get_id()) { |event| yield(event) } if block_given?
		add_to_sizer(my_button, params)
	end
	
	# TODO: CalendarCtrl		Control showing an entire calendar month
	def calendar_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::CAL_SHOW_HOLIDAYS)
		date = params[:date] || Wx::DefaultDateTime
		my_calendar_ctrl = Wx::CalendarCtrl.new(parent, id, date, pos, size, style) 
		add_to_sizer(my_calendar_ctrl, params)
	end
	
	# TODO: CheckBox		Checkbox control
	def check_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_checkbox = Wx::CheckBox.new(parent, id, label, pos, size, style, val)
		add_to_sizer(my_checkbox, params)
	end
	
	# TODO: CheckListBox		A listbox with a checkbox to the left of each item
	def check_list_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_checklistbox = Wx::CheckListBox.new(parent, id, pos, size, choices, style, validator)
		add_to_sizer(my_checklistbox, params)
	end
	
	# TODO: Choice		Drop-down list from which the user can select one option
	def choice(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_choice = Wx::Choice.new(parent, id, pos, size, choices, style, validator) 
		add_to_sizer(my_choice, params)
	end
	
	# TODO: ComboBox		A drop-down Choice with an editable text area
	def combo_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] || []
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_combo_box = Wx::ComboBox.new(parent, id, pos, size, choices, style, validator) 
		add_to_sizer(my_combo_box, params)
	end
	
	# TODO: DatePickerCtrl	Small date picker control
	def date_picker_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, (Wx::DP_DEFAULT | Wx::DP_SHOWCENTURY))
		dt = params[:dt] || Wx::DefaultDateTime
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_date_picker_ctrl = Wx::DatePickerCtrl.new(parent, id, dt, pos, size, style, validator) 
		add_to_sizer(my_date_picker_ctrl, params)
	end
	
	# TODO: Gauge			A control to represent a varying quantity, such as time remaining
	def gauge(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::GA_HORIZONTAL)
		range = params[:range] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_gauge = Wx::Gauge.new(parent, id, range, pos, size, style, validator) 
		add_to_sizer(my_gauge, params)
	end
	
	# TODO: GenericDirCtrl	A control for displaying a directory tree
	def generic_dir_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, (Wx::DIRCTRL_3D_INTERNAL|Wx::SUNKEN_BORDER))
		dir = params[:dir] || Wx::DirDialogDefaultFolderStr
		filter = params[:filter] || ''
		defaultFilter = params[:defaultFilter] || 0
		my_generic_dir_ctrl = Wx::GenericDirCtrl.new(parent, id, dir, pos, size, style, filter, defaultFilter) 
		add_to_sizer(my_generic_dir_ctrl, params)
	end
	
	# TODO: HtmlListBox		A listbox showing HTML content
	def html_list_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		my_html_list_box = Wx::HtmlListBox.new(parent, id, pos, size, style) 
		add_to_sizer(my_html_list_box, params)
	end
	
	# TODO: HyperlinkCtrl		Displays a clickable URL that will launch a browser
	def hyperlink_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		url = params[:url]
		my_hyperlink_ctrl = Wx::HyperlinkCtrl.new(parent, id, label, url, pos, size, style) 
		add_to_sizer(my_hyperlink_ctrl, params)
	end
	
	# TODO: ListBox		A list of strings for single or multiple selection
	def list_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		choices = params[:choices] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_list_box = Wx::ListBox.new(parent, id, pos, size, choices, style, validator) 
		add_to_sizer(my_list_box, params)
	end
	
	# TODO: ListCtrl		A control for displaying lists of strings and/or icons, plus a multicolumn report view
	def list_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::LC_ICON)
		range = params[:range] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_list_ctrl = Wx::ListCtrl.new(parent, id, pos, size, style, validator) 
		add_to_sizer(my_list_ctrl, params)
	end
	
	# TODO: MediaCtrl		A control for playing sound and video
	def media_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		fileName = params[:fileName] || ''
		backend = params[:backend] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_media_ctrl = Wx::MediaCtrl.new(parent, id, fileName, pos, size, style, backend, validator) 
		add_to_sizer(my_media_ctrl, params)
	end
	
	# TODO: RadioBox		A group of radio buttons
	def radio_box(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::RA_SPECIFY_COLS)
		label = params[:label] 
		n = params[:n] || 0 
		choices = params[:choices]
		majorDimension = params[:majorDimension] || 0 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_radio_box = Wx::RadioBox.new(parent, id, label, pos, size, n, choices, majorDimension, style, validator) 
		add_to_sizer(my_radio_box, params)
	end
	
	# TODO: RadioButton		A round button to be used with others in a mutually exclusive way
	def radio_button(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_radio_button = Wx::RadioButton.new(parent, id, label, pos, size, style, validator) 
		add_to_sizer(my_radio_button, params)
	end
	
	# TODO: RichTextCtrl		Advanced text-editing control with styles and inline images
	def rich_text_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::RE_MULTILINE)
		value = params[:value] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_rich_text_ctrl = Wx::RichTextCtrl.new(parent, id, value, pos, size, style, validator) 
		add_to_sizer(my_rich_text_ctrl, params)
	end
	
	# TODO: ScrollBar		Scrollbar control
	def scroll_bar(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SB_HORIZONTAL)
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_scroll_bar = Wx::ScrollBar.new(parent, id, pos, size, style, validator) 
		add_to_sizer(my_scroll_bar, params)
	end 

	# TODO: Slider		A slider that can be dragged by the user
	def slider(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SL_HORIZONTAL)
		value = params[:value] 
		minValue = params[:minValue] 
		maxValue = params[:maxValue] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_slider = Wx::Slider.new(parent, id, value, minValue, maxValue, pos, size, style, validator) 
		add_to_sizer(my_slider, params)
	end

	# TODO: SpinButton		A spin or up-down control
	def spin_button(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SP_HORIZONTAL)
		my_spin_button = Wx::SpinButton.new(parent, id, pos, size, style) 
		add_to_sizer(my_spin_button, params)
	end

	# TODO: SpinCtrl		A spin control - i.e. spin button and text control
	def spin_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::SP_ARROW_KEYS)
		value = params[:value] || ''
		min = params[:min] || 0 
		max = params[:max] || 100
		initial = params[:initial] || 0
		my_spin_ctrl = Wx::SpinCtrl.new(parent, id, value, pos, size, style, min, max, initial) 
		add_to_sizer(my_spin_ctrl, params)
	end

	# TODO: StaticBitmap		A control to display a bitmap
	def static_bitmap(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		my_static_bitmap = Wx::StaticBitmap.new(parent, id, label, pos, size, style) 
		add_to_sizer(my_static_bitmap, params)
	end
	
	# TODO: StaticBox		A static, or group box for visually grouping related controls
	def static_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		my_static_box = Wx::StaticBox.new(parent, id, label, pos, size, style)
		add_to_sizer(my_static_box, params)
	end
	
	# StaticText		One or more lines of non-editable text
	def static_text(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] || ''
		my_label = Wx::StaticText.new(parent, id, label, pos, size, style)
		add_to_sizer(my_label, params)		
        my_label
	end
	
	# TODO:StyledTextCtrl	Sophisticated code text editor based on Scintilla
	# Do later - the wxRuby documentation doesn't include the contructor...WTF?
	
	# TextCtrl		Single or multiline text editing control
	def text_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		value = params[:value] || ''
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_text_ctrl = Wx::TextCtrl.new(parent, id, value, pos, size, style, validator)
		add_to_sizer(my_text_ctrl, params)
	end
	
	# TODO: ToggleButton		A button which stays pressed when clicked by user.
	def toggle_button(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		label = params[:label] 
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_toggle_button = Wx::ToggleButton.new(parent, id, label, pos, size, style, validator) 
		add_to_sizer(my_toggle_button, params)
	end

	# TODO: TreeCtrl		Tree (hierarchy) control
	def tree_ctrl(params = {})
		parent, id, pos, size, style = read_default_params(params, Wx::TR_HAS_BUTTONS)
		validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_tree_ctrl = Wx::TreeCtrl.new(parent, id, pos, size, style, validator) 
		add_to_sizer(my_tree_ctrl, params)
	end 

	# TODO: VListBox		A listbox supporting variable height rows
	def vlist_box(params = {})
		parent, id, pos, size, style = read_default_params(params, 0)
		countItems = params[:countItems] || 0
		my_vlist_box = Wx::VListBox.new(parent, id, pos, size, countItems, style) 
		add_to_sizer(my_vlist_box, params)
	end

	
#########################################################################################################
# Menus
#########################################################################################################
	# Menu			Displays a series of menu items for selection
	def menu(params = {})
		title = params[:title] || ''
		style = params[:style] || 0
		my_menu = Wx::Menu.new('', style)
		@containers.last.append(my_menu, title)
		push_container(my_menu) { yield } if block_given?
	end
	
	# MenuBar		Contains a series of menus for use with a frame
	def menu_bar(params = {})
		style = params[:style] || 0
		my_menu_bar = Wx::MenuBar.new(style)
		@containers.first.set_menu_bar(my_menu_bar)
		push_container(my_menu_bar) { yield } if block_given?
	end
	
	# MenuItem		Represents a single menu item
	def menu_item(params = {})
		id = params[:id] || -1
		text = params[:text] || ''
		helpString = params[:helpString] || ''
		kind = params[:kind] || Wx::ITEM_NORMAL
		my_menu_item = Wx::MenuItem.new(nil, id, text, helpString, kind)
		if params.has_key?(:parentMenu)
			params[:parentMenu].append_item(my_menu_item)
		elsif @containers.last.instance_of?(Wx::Menu)
			@containers.last.append_item(my_menu_item)
		end
		@containers.first.evt_menu(my_menu_item) { yield } if block_given?
	end
	
	def menu_separator(params = {})
		params[:id] = Wx::ID_SEPARATOR
		params[:kind] = Wx::ITEM_SEPARATOR
		menu_item(params)
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
