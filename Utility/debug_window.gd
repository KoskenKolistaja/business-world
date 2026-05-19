extends Window

@export var output: RichTextLabel

static var singleton: Window

var index = 0

func _ready():
	singleton = self
	
	# Tells the OS NOT to link this window's lifecycle/focus directly to the main window
	transient = false
	
	# Keep it windowed by default
	mode = Window.MODE_WINDOWED
	
	# Start hidden so it only pops up when you actually print/warn/error something
	hide()
	await get_tree().create_timer(0.1).timeout
	self.print("NORMAL PRINT")
	warn("WARNING")
	error("ERROR")


func add_text(text: String):
	output.append_text(text + "\n")
	
	# Auto scroll to bottom
	output.scroll_to_line(output.get_line_count())

static func print(text):
	if singleton:
		singleton.show()
		singleton.add_text(str(text))

static func warn(text):
	if singleton:
		singleton.show()
		
		# Get caller info
		var caller_info = _get_caller_info()
		var formatted_text = "[color=yellow][WARN] %s[/color] %s" % [caller_info, str(text)]
		
		singleton.add_text(formatted_text)

static func error(text):
	if singleton:
		singleton.show()
		
		# Get caller info
		var caller_info = _get_caller_info()
		var formatted_text = "[color=red][ERROR] %s[/color] %s" % [caller_info, str(text)]
		
		singleton.add_text(formatted_text)

# Helper function to parse the stack trace
static func _get_caller_info() -> String:
	var stack = get_stack()
	
	# stack[0] is this helper function (_get_caller_info)
	# stack[1] is the warn/error function itself
	# stack[2] is the actual script that called warn/error()
	if stack.size() > 2:
		var caller = stack[2]
		# Extracts just the file name from the full res:// path
		var file_name = caller["source"].get_file() 
		return "[%s:%d -> %s()]" % [file_name, caller["line"], caller["function"]]
	
	return "[Unknown Source]"
