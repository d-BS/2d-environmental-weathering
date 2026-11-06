shader_type canvas_item;
global uniform vec2 camera_position;

instance uniform float layer;
instance uniform vec2 scale;
uniform sampler2D depth_map;

void vertex() {
	// Called for every vertex the material is visible on.
	
	vec2 v = VERTEX;
	
	vec2 motion_amt = camera_position / scale;
	
	//motion_amt = layer * motion_amt;
	//v = v + motion_amt * layer;
	
	v += motion_amt * (1.0 - layer);
	
	//v *= layer;
	
	VERTEX = v;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR.a = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
