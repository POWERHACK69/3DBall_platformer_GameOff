extends Node3D


var ring_count
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ring_count =get_node("Rings").get_children().size()
	print(ring_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_death_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
