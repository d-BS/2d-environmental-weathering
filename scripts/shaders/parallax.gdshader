shader_type canvas_item;
global uniform vec3 light_pos;
global uniform vec3 camera_position;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D shadowtex;

instance uniform float layer = 1.0;
instance uniform vec2 tex_pos;
instance uniform vec2 scale = vec2(1.0, 1.0);

//0 false, 1 true
varying float is_viewport;

void vertex() {
	// Called for every vertex the material is visible on.
	
	
	
	float target_subviewport_zoom = 1.001;
	is_viewport = abs(CANVAS_MATRIX[0][0] - target_subviewport_zoom);
	
	
	vec3 correction = is_viewport == 0.0 ? light_pos : camera_position;
	
	
	vec2 v = VERTEX;
	
	//apply foreshortening
	v *= layer / correction.z;// == 1.0 ? layer : 1.0;
	
	//account for camera motion
	vec2 motion_amt = correction.xy / scale;
	
	//apply parallax
	v += motion_amt * (1.0 - layer);
	
	VERTEX = v;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR.a = 0.0;
	
	if(is_viewport != 0.0){
		vec4 screen_color = texture(screen_texture, SCREEN_UV);
		if(screen_color != vec4(0, 0, 0, 1))
			COLOR = vec4(0, 0, 0, 0);
	}
	else{
		
		COLOR.rgb = vec3(layer, 0.0, 0.0);
		
		vec4 screen_color = texture(shadowtex, SCREEN_UV);
		if(screen_color != vec4(0.0, 0.0, 0.0, 1.0))
			COLOR.a = 0.0;//vec4(0, 0, 0, 0);
		
	}
	
	//COLOR.r = 1.0;
	
	
	//COLOR.rgb *= is_viewport == 0.0 ? 0.0 : 1.0;
	
	//we start by getting where it is on screen
	//ivec2 screen_coords = ivec2(SCREEN_UV * vec2(640,360));
	//int tex_pos = screen_coords.y * 640 + screen_coords.x;
	
	//if(shadow_cast[tex_pos] == 0.0)
	//	shadow_cast[tex_pos] = layer;
	//else
	//	COLOR.rgb *= .5;
	
	//then we undo the parallax transformation
	//vec2 motion_amt = camera_position / scale;
	
	//vec2 tex_coords = screen_coords - motion_amt * (1.0 - layer);
	//tex_coords /= layer;
	
	
	
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
