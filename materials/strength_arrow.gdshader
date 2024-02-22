shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform int max_hit_strength = 0;
uniform float hit_strength = 0.0;
uniform float max_length = 15.0;

// Threshold to activate wobbling effect
uniform float wobble_activation_threshold = 0.5;
uniform float wobble_amplitude = 0.8;
uniform float wobble_speed = 16.0;


void vertex() {
	float len = hit_strength / float(max_hit_strength) * max_length; 
	// Extend to new length
	VERTEX.z *= len * max_length;
	// Offset position so the end is always at the same position
	VERTEX.z += len / (200.0/max_length);
	

	//Wobble
	if (hit_strength > float(max_hit_strength) * wobble_activation_threshold){
		float wobble_amount = pow(VERTEX.z,2);
		wobble_amount *= hit_strength;
		VERTEX.x += sin(TIME * wobble_speed) * (wobble_amount / 1000.0);
	}
}

void fragment() {
	vec3 out_color = vec3(0,0,0);
	out_color.r += hit_strength / float(max_hit_strength);
	ALBEDO = out_color;
}