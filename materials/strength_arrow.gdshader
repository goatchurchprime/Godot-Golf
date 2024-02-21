shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform int max_hit_strength = 0;
uniform float hit_strength;
uniform float MAX_LENGTH = 400.0;

uniform float WOBBLE_THRESHOLD = 250.0;
uniform float WOBBLE_AMPLITUDE = 2.0;
uniform float WOBBLE_SPEED = 3.5;
uniform float MAX_WOBBLE = 400;

void vertex() {
	// Do not apply backwards
	if (VERTEX.z <= 0.0){
		// Calculate length
		float len = -hit_strength / float(max_hit_strength) * MAX_LENGTH;
		VERTEX.z *= len;
		
		// Calculate wobble
		float wobble_amt = -len - WOBBLE_THRESHOLD;
		wobble_amt = clamp(wobble_amt,0,400);
		
		// Apply wobble
		VERTEX.x += sin(TIME * (WOBBLE_SPEED * PI)) * wobble_amt * WOBBLE_AMPLITUDE / 4000.0;
	}
}

void fragment() {
	vec3 out_color = vec3(0,0,0);
	out_color.r += hit_strength / float(max_hit_strength);
	ALBEDO = out_color;
}