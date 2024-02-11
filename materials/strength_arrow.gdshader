shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform int max_hit_strength = -13;
uniform float hit_strength;
const float MAX_LENGTH = 400.0;

const float WOBBLE_THRESHOLD = 300.0;
const float WOBBLE_AMPLITUDE = 0.035;
const float WOBBLE_SPEED = 3.5 * PI;

void vertex() {
	if (VERTEX.z <= 0.0){
		float len = -hit_strength / float(max_hit_strength) * MAX_LENGTH;
		
		VERTEX.z *= len;
		
		if (-len > WOBBLE_THRESHOLD){
			VERTEX.x += sin(TIME * WOBBLE_SPEED) * WOBBLE_AMPLITUDE;
		}
	}
}

void fragment() {
	vec3 out_color = vec3(0,0,0);
	out_color.r += hit_strength / float(max_hit_strength);
	ALBEDO = out_color;
}