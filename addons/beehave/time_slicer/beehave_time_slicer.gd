extends Node

var tick_queue : Array[Callable] = []
var max_ticks_per_frame : int = 100

func _physics_process(delta: float) -> void:
	var ticks_done : int = 0
	while ticks_done < max_ticks_per_frame and tick_queue.size() != 0:
		var tick : Callable = tick_queue.pop_front()
		if is_instance_valid(tick.get_object()):
			tick.call()
			ticks_done += 1
