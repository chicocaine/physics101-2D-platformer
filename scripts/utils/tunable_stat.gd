class_name TunableStat

var name: String
var value: float
var min_value: float
var max_value: float
var on_changed : Callable


func _init(_name: String, _value: float, _min: float, _max: float, _on_changed: Callable):
	name = _name
	value = _value
	min_value = _min
	max_value = _max
	on_changed = _on_changed
