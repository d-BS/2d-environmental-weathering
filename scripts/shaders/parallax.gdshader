shader_type canvas_item;
global uniform vec3 light_pos;
global uniform vec3 camera_position;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D shadowtex : repeat_disable, filter_nearest;

uniform float focal_layer = 1.0;
uniform vec3 shadow_strength = vec3(0.1, 0.1, 0.1);

instance uniform float layer = 1.0;
instance uniform vec2 scale = vec2(1.0, 1.0);

//0 false, 1 true
varying float shadow_pass;
varying vec2 light_uv;

vec2 layer_transform(vec2 v, vec3 eye){
	
	
	//s(layer) = layer / (1 - layer * z)
	// ->
	//s_norm = s(layer) / s(focal)
	// ->
	//s_norm = = layer * (1 - focal * z) / (focal * (1 - layer * z))
	
	float d_layer = 1.0 - layer * eye.z;
	float d_focal = 1.0 - focal_layer * eye.z;

	// if eye at or past layer, sweep under the rug
	if (d_layer < 1e-4 || d_focal < 1e-4) return vec2(1e6);

	float s = (layer * d_focal) / (focal_layer * d_layer);
	vec2 c = eye.xy / scale;
	
	// v*s + c*(1 - s)
	return s * (v - c) + c;
	
}


void vertex() {
	// Called for every vertex the material is visible on.
	
	
	float target_subviewport_zoom = 1.000001;
	
	shadow_pass = abs(CANVAS_MATRIX[0][0] - target_subviewport_zoom) < 5e-7 ? 1.0 : 0.0;
	vec3 eye = shadow_pass > 0.5 ? light_pos : camera_position;
	
	
	vec2 lw = (MODEL_MATRIX * vec4(layer_transform(VERTEX, light_pos), 0.0, 1.0)).xy;
	light_uv = (lw - camera_position.xy) / vec2(640.0, 360.0) + 0.5;

	VERTEX = layer_transform(VERTEX, eye);

}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR.a = 0.0;
	
	float shadow_bias = .0;
	
	//this branch is for the shadow cam
	if (shadow_pass > 0.5) {
		if (COLOR.a < 0.1)
			discard;
		COLOR = vec4(layer, 0.0, 0.0, 1.0);
	}
	//this branch is for the main viewport
	else {
		
		//if light uv would grab outside shadowtex, we just say there'll be 
		//no shadows. Otherwise, we grab from shadowtex
		float occluded = (clamp(light_uv, vec2(0.0), vec2(1.0)) != light_uv)
						? 0.0 : texture(shadowtex, light_uv).r;
		
		if (occluded > layer + shadow_bias)
			COLOR.rgb *= shadow_strength;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
