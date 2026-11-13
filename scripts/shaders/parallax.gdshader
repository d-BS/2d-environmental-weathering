shader_type canvas_item;
global uniform vec3 light_pos;
global uniform vec3 camera_position;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D shadowtex : repeat_disable, filter_nearest;

uniform float focal_layer = 1.0;

uniform bool shadow_default = false;
uniform vec3 shadow_strength = vec3(0.1, 0.1, 0.1);

uniform vec4 fog : source_color = vec4(.75, .75, .75, 1.0);
uniform float fog_strength;

instance uniform float layer = 1.0;
instance uniform vec2 scale = vec2(1.0, 1.0);

//0 false, 1 true
varying float shadow_pass;
varying vec2 light_uv;
varying mat4 model_matrix;
varying vec2 vertex_pos;

vec4 lerp(vec4 start, vec4 end, float t){
	return (1.0 - t) * start + t * end;
}

vec2 layer_transform(vec2 v, vec3 eye, float intralayer_depth){
	
	
	//s(layer) = layer / (1 - layer * z)
	// ->
	//s_norm = s(layer) / s(focal)
	// ->
	//s_norm = = layer * (1 - focal * z) / (focal * (1 - layer * z))
	
	
	
	//scales down to the scale of change we're looking for
	//ill replace this with real math later
	intralayer_depth *= .1;
	
	//scales the change once again w the layer scale, moves to layer loc
	intralayer_depth *= layer;
	intralayer_depth += layer;
	
	float d_layer = 1.0 - intralayer_depth * eye.z;
	float d_focal = 1.0 - focal_layer * eye.z;

	// if eye at or past layer, sweep under the rug
	if (d_layer < 1e-4 || d_focal < 1e-4) return vec2(1e6);

	float s = (intralayer_depth * d_focal) / (focal_layer * d_layer);
	vec2 c = eye.xy / scale;
	
	// v*s + c*(1 - s)
	return s * (v - c) + c;
	
}


void vertex() {
	// Called for every vertex the material is visible on.
	
	
	float target_subviewport_zoom = 1.000001;
	
	shadow_pass = abs(CANVAS_MATRIX[0][0] - target_subviewport_zoom) < 5e-7 ? 1.0 : 0.0;
	vec3 eye = shadow_pass > 0.5 ? light_pos : camera_position;
	
	
	//vec2 lw = (MODEL_MATRIX * vec4(layer_transform(VERTEX, light_pos), 0.0, 1.0)).xy;
	//light_uv = (lw - camera_position.xy) / vec2(640.0, 360.0) + 0.5;
	model_matrix = MODEL_MATRIX;
	vertex_pos = VERTEX;
	
	
	VERTEX = layer_transform(VERTEX, eye, 0.0);
	
	
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
		
		
		//in the future, the COLOR.a channel will store intralayer_depth
		//for now, well just say darker pixels are futher back
		//range should be -1 <= ilDepth <= 1
		float il_depth = 0.0;//(COLOR.r + COLOR.g + COLOR.b) / 1.5 - 1.0;
		
		vec2 lw = (model_matrix * vec4(layer_transform(vertex_pos, light_pos, il_depth), 0.0, 1.0)).xy;
		light_uv = (lw - camera_position.xy) / vec2(640.0, 360.0) + 0.5;
		
		
		//if light uv would grab outside shadowtex, we just say there'll be 
		//no shadows. Otherwise, we grab from shadowtex.
		//maybe this will be more sophisticated in the future, but this is
		//good enough for now
		float occluded = (clamp(light_uv, vec2(0.0), vec2(1.0)) != light_uv)
						? shadow_default ? 999.9 : 0.0 : texture(shadowtex, light_uv).r;
		
		if (occluded > layer + shadow_bias)
			COLOR.rgb *= shadow_strength;
		//COLOR.a = COLOR.a > .5 ? 1.0 : 0.0;
		
		
		
		COLOR = lerp(COLOR, fog, clamp(fog_strength/layer - fog_strength, .0, 1.0));
		
		
		//COLOR = (fog * fog_strength + COLOR * layer) / (fog_strength + layer);
		
		
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
