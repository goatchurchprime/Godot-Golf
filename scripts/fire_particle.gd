class_name FireParticle extends GPUParticles3D

var original_albedo : Color
var mat : StandardMaterial3D

func _ready():
	var parent = get_parent_node_3d()
	
	for child in parent.get_children():
		if child is MeshInstance3D:
			mat = child.get_active_material(0)
			if mat is StandardMaterial3D:
				mat.albedo_color
				original_albedo = mat.albedo_color
				mat.albedo_color = Color(1,0,0,1)
	

func _on_timer_timeout():
	if mat and original_albedo:
		mat.albedo_color = original_albedo
	queue_free()
