extends Panel

var canvas = get_parent()
var player_ref

func _ready():
	if canvas:
		player_ref = canvas.get_player_path()
		_build_ui()
	else: 
		print("canvas is null")

func _build_ui():
	var container = $VBoxContainer

	# Clear old UI if reloaded
	for child in container.get_children():
		child.queue_free()

	# Create sliders for each tunable stat
	for stat_name in player_ref.tunables.keys():
		var stat = player_ref.tunables[stat_name]

		# Create label
		var label = Label.new()
		label.text = stat.name
		container.add_child(label)

		# Create slider
		var slider = HSlider.new()
		slider.min_value = stat.min_value
		slider.max_value = stat.max_value
		slider.value = stat.value
		slider.step = 0.01
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		slider.connect("value_changed", Callable(self, "_on_slider_changed").bind(stat))
		container.add_child(slider)

func _on_slider_changed(value: float, stat: TunableStat):
	stat.value = value
	stat.on_changed.call(value)

func _input(event):
	if event.is_action_pressed("toggle_player_stats"):
		visible = !visible
