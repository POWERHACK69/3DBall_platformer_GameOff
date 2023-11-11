extends Node3D

@export_enum("small","big") var ring_size :int

var collected = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		$Pick.play()
		collected = true
		collect()
		

func collect():
		if not collected:
			$CSGMesh3D.material.albedo_color = "ffdf22"
			$CSGMesh3D.material.emission_enabled = true
		if collected:
			$CSGMesh3D.material.albedo_color = "000000"
			$CSGMesh3D.material.emission_enabled = false
		
