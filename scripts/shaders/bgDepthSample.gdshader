shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depthmap;
uniform vec2 light_direction;
//uniform vec2 camera_position;
uniform float shadow_depth;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	
	
	//cuts out a hole so that we can see sprites and stuff
	//we use screenUV here because this should account for camera angle
	if(texture(screen_texture, SCREEN_UV) != vec4(0, 0, 0, 1)){
		COLOR = vec4(0, 0, 0, 0);
	}
	
	else{
		
		//in the future, depth will be stored in the a channel, so
		//this will just be float depth = COLOR.a
		vec4 depth = texture(depthmap, UV);
		
		
		//this should use UV, because we don't want this to care about
		//where the camera is
		vec2 sample_loc = SCREEN_UV; //* vec2(textureSize(TEXTURE, 0));
		
		//sample_loc /= vec2(textureSize(screen_texture, 0));
		sample_loc += light_direction * (1.0 - depth.r);
		
		if(clamp(sample_loc, 0.0, 1.0) != sample_loc){}
			
		
		else if(texture(screen_texture, sample_loc) != vec4(0, 0, 0, 1))
			COLOR.rgb *= shadow_depth;
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
