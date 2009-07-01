require 'rubygems'
require 'wx'

module WxShoesControls
#########################################################################################################
# Miscellaneous Windows
#########################################################################################################
	# Panel				A window whose colour changes according to current user settings
	def panel(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || Wx::TAB_TRAVERSAL
		my_panel = Wx::Panel.new(parent, id, pos, size, style)
		push_container(my_panel) { yield }
	end
	
	# StatusBar			A status bar on a frame
	def status_bar(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        style = params[:style] || Wx::ST_SIZEGRIP
		text = params[:text]
		my_status_bar = Wx::StatusBar.new(parent, id, style)
		parent.status_bar = my_status_bar
		my_status_bar.push_status_text text if text
		my_status_bar
	end
	
	# CollapsiblePane		A container with a button to collapse or expand contents
	def collapsible_pane(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        label = params[:label] || ''
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || Wx::CP_DEFAULT_STYLE
        validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_collapsible_pane = Wx::CollapsiblePane.new(parent, id, label, pos, size, style, validator)
		push_container(my_collapsible_pane) { yield }
	end
	
	# ScrolledWindow		Window with automatically managed scrollbars
	def scrolled_window(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || (Wx::VSCROLL | Wx::HSCROLL)
		my_scrolled_window = Wx::ScrolledWindow.new(parent, id, pos, size, style) 
		push_container(my_scrolled_window) { yield }
	end
	
	# Grid					A grid (table) window
	def grid(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || Wx::WANTS_CHARS
		my_grid = Wx::Grid.new(parent, id, pos, size, style)
		push_container(my_grid) { yield }
	end
	
	# SplitterWindow		Window which can be split vertically or horizontally
	def splitter_window(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || Wx::SP_3D
		my_splitter_window = Wx::SplitterWindow.new(parent, id, pos, size, style)
		push_container(my_grid) { yield }
	end
	
	##ToolBar				Toolbar with buttons - will not implement here.  Use Frame#create_tool_bar instead.
	
	# Notebook				Tabbed Notebook for layout out controls
	def notebook(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0
		my_notebook = Wx::Notebook.new(parent, id, pos, size, style)
		push_container(my_notebook) { yield }
	end
	
	# Listbook				Similar to notebook but using a list control
	def listbook(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0
		my_listbook = Wx::Listbook.new(parent, id, pos, size, style)
		push_container(my_listbook) { yield }
	end
	
	# Choicebook			Similar to notebook but using a choice (dropdown) control
	def choicebook(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0
		my_choicebook = Wx::Choicebook.new(parent, id, pos, size, style)
		push_container(my_choicebook) { yield }
	end
	
	# SashWindow			Window with four optional sashes that can be dragged
	def sash_window(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || (Wx::CLIP_CHILDREN | Wx::SW_3D)
		my_sash_window = Wx::SashWindow.new(parent, id, pos, size, style)
		push_container(my_sash_window) { yield }
	end
	
	##SashLayoutWindow		Window that can be involved in an IDE-like layout arrangement
	def sash_window_layout(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || (Wx::CLIP_CHILDREN | Wx::SW_3D)
		my_sash_layout_window = Wx::SashLayoutWindow.new(parent, id, pos, size, style)
		push_container(my_sash_layout_window) { yield }
	end
	
	def push_container(container)
		@containers.push(container)
		yield
		@containers.pop
		container
	end
	# TODO in this section:
	##VScrolledWindow		As ScrolledWindow but supports lines of variable height
	##WizardPage			A base class for a page in wizard dialog.
	##WizardPageSimple		A page in wizard dialog.
	
#########################################################################################################
# Window Layout
#########################################################################################################
	# GridSizer				A sizer for laying out windows in a grid with all fields having the same size
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
		push_sizer(my_sizer, params) { yield }
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
		push_sizer(my_sizer, params) { yield }
	end
	
	# GridBagSizer			Another grid sizer that lets you specify the cell an item is in, and items can span rows and/or columns.
	def grid_bag_sizer(params = {})
		vgap = params[:vgap] || 0 
        hgap = params[:hgap] || 0
		my_sizer = Wx::GridBagSizer.new(vgap, hgap)
		push_sizer(my_sizer, params) { yield }
	end
	
	# BoxSizer				A sizer for laying out windows in a row or column
	def box_sizer(orientation, params = {})
		my_sizer = Wx::BoxSizer.new(orientation)
		push_sizer(my_sizer, params) { yield }
	end
	
	def hbox_sizer(params = {})
		box_sizer(Wx::HORIZONTAL, params) { yield }
	end	
	
	def vbox_sizer(params = {})
		box_sizer(Wx::VERTICAL, params) { yield }
	end
	
	# StaticBoxSizer			Same as wxBoxSizer, but with a surrounding static box
	def static_box_sizer(params = {})
		orient = params[:orient] || Wx::VERTICAL
		my_sizer = if params[:box]
			Wx::StaticBoxSizer.new(params[:box], orient)
		else
			label = params[:label] || ''
			Wx::StaticBoxSizer.new(orient, parms[:parent], label)
		end
		push_sizer(my_sizer, params) { yield }
	end
	
	# StdDialogButtonSizer		Sizer for arranging buttons on a dialog, in platform-standard order
	def std_dialog_button_sizer(params = {})
		my_sizer = Wx::StdDialogButtonSizer.new
		push_sizer(my_sizer, params) { yield }
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
	# BitmapButton		Push button control, displaying a bitmap
	def bitmap_button(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
		bitmap = params[:bitmap]
		pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0 
        validator = params[:validator] || Wx::DEFAULT_VALIDATOR	
		my_bitmap_button = Wx::BitmapButton.new(parent, id, bitmap, pos, size, style, validator)
		add_to_sizer(my_bitmap_button, params)
		evt_button(my_bitmap_button.get_id()) { |event| yield(event) }
	end
	
	# Button			Push button control, displaying text
	def button(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
		label = params[:label] || ''
		pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0 
        validator = params[:validator] || Wx::DEFAULT_VALIDATOR		
		my_button = Wx::Button.new(parent, id, label, pos, size, style, validator)
		add_to_sizer(my_button, params)
		evt_button(my_button.get_id()) { |event| yield(event) }
		my_button
	end
	
	# StaticBox			A static, or group box for visually grouping related controls
	def static_box(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
		label = params[:label] || ''
		pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0 
		my_static_box = Wx::StaticBox.new(parent, id, label, pos, size, style)
		add_to_sizer(my_static_box, params)
		my_static_box
	end
	
	# StaticText		One or more lines of non-editable text
	def static_text(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
		label = params[:label] || ''
		pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0 
		my_label = Wx::StaticText.new(parent, id, label, pos, size, style)
		add_to_sizer(my_label, params)		
        my_label
	end
	
	# TreeCtrl			Tree (hierarchy) control
	def text_ctrl(params = {})
		parent = params[:parent] || @containers.last
		id = params[:id] || -1
		value = params[:value] || ''
		pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || 0 
        validator = params[:validator] || Wx::DEFAULT_VALIDATOR
		my_text_ctrl = Wx::TextCtrl.new(parent, id, value, pos, size, style, validator)
		add_to_sizer(my_text_ctrl, params)		
		my_text_ctrl
	end
	# TODO in this section:
	# ToggleButton		A button which stays pressed when clicked by user.
	# CalendarCtrl		Control showing an entire calendar month
	# CheckBox			Checkbox control
	# CheckListBox		A listbox with a checkbox to the left of each item
	# Choice			Drop-down list from which the user can select one option
	# ComboBox			A drop-down Choice with an editable text area
	# BitmapComboBox	A ComboBox where each item can have an image
	# DatePickerCtrl	Small date picker control
	# Gauge				A control to represent a varying quantity, such as time remaining
	# GenericDirCtrl	A control for displaying a directory tree
	# HtmlListBox		A listbox showing HTML content
	# HyperlinkCtrl		Displays a clickable URL that will launch a browser
	# ListBox			A list of strings for single or multiple selection
	# ListCtrl			A control for displaying lists of strings and/or icons, plus a multicolumn report view
	# TextCtrl			Single or multiline text editing control
	# StyledTextCtrl	Sophisticated code text editor based on Scintilla
	# RichTextCtrl		Advanced text-editing control with styles and inline images
	# ScrollBar			Scrollbar control
	# SpinButton		A spin or ‘up-down’ control
	# SpinCtrl			A spin control – i.e. spin button and text control
	# StaticBitmap		A control to display a bitmap
	# RadioBox			A group of radio buttons
	# RadioButton		A round button to be used with others in a mutually exclusive way
	# Slider			A slider that can be dragged by the user
	# VListBox			A listbox supporting variable height rows
	# MediaCtrl			A control for playing sound and video
	# AnimationCtrl		For displaying a looping animation
	
#########################################################################################################
# Menus
#########################################################################################################
	# Menu			Displays a series of menu items for selection
	# MenuBar		Contains a series of menus for use with a frame
	# MenuItem		Represents a single menu item

#########################################################################################################
# Rich text classes
#########################################################################################################
	# RichTextAttr							Definition of text style properties
	# RichTextBuffer						The internal representation of a RichTextCtrl’s contents
	# RichTextCharacterStyleDefinition		A named character-level style
	# RichTextCtrl							GUI widget for editing rich text
	# RichTextEvent							Events specific to RichText
	# RichTextFileHandler					Base class for reading and writing rich text
	# RichTextFormattingDialog				Dialog for editing rich text styles
	# RichTextHeaderFooterData				Helper class for printing headers and footers
	# RichTextHTMLHandler					Export rich text to HTML
	# RichTextStyleDefinition				Base class for named styles
	# RichTextParagraphStyleDefinition		A named style for paragraph properties
	# RichTextPrinting						Convenient printing of rich text content
	# RichTextPrinting						Helper class for printing rich text
	# RichTextStyleListBox					Control which previews and allows selection of styles from a stylesheet
	# RichTextStyleListCtrl					Combined control for choosing styles from a stylesheet
	# RichTextStyleSheet					A collection of named styles that can be applied to text
	# RichTextXMLHandler					Import and export rich text in XML

#########################################################################################################
# HTML classes
#########################################################################################################
	# HtmlHelpController	HTML help controller class
	# HtmlWindow			HTML window class, for displaying HTML
	# HtmlEasyPrinting		Simple but useful class for printing HTML
end

class WxShoesFrame < Wx::Frame
	include WxShoesControls
	def initialize(params = {})
		parent = params[:parent]
		id = params[:id] || -1
		title = params[:title]
        pos = params[:pos] || Wx::DEFAULT_POSITION
        size = params[:size] || Wx::DEFAULT_SIZE
        style = params[:style] || Wx::DEFAULT_FRAME_STYLE
		controller = params[:controller]
		
		@containers = []
		@containers.push(self)
		@sizers = []
		super(parent, id, title, pos, size, style)
		self.icon = params[:icon] if params[:icon]
		extend(controller) if controller
	end
end

class WxShoesApp < Wx::App	
	def initialize &block
		super()
		@block = block
	end
	
	def on_init
		cloaker(&@block).bind(self).call
	end
	
	def frame(params, &block)
		@frame = WxShoesFrame.new(params, &block)
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