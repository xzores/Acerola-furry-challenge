package shell;

import "core:fmt"
import "core:math/linalg"
import "core:math/linalg/glsl"

import render "furbs/interface"


main :: proc() {
	using render;

	init_render(nil, "res/shaders");
	window := init_window(800, 600, "Shell texturing");

	sphere := generate_sphere();
	upload_mesh_single(&sphere);

	shell_shader : Shader;
	load_shader(&shell_shader, "shell", "shell");

	zoom : f32 = 0.1;
	spaceing : f32 = 0.1;
	spacing_selected : bool;
	number_of_layers : f32 = 16;

	dir : [3]f32 = {0,0,-1};
	my_camera : Camera3D = {
		position 	= {0,0,-10},
		target 		= {0,0,0},
		up       	= {0,1,0},
		fovy     	= 75,
		projection 	= .perspective,
		far 		= 1000,
		near 		= 0.1,
	};

	/*
	my_font := load_font_from_file("my_font", "res/fonts/my_font.ttf");
	font_style : gui.Font_style = {
		font = my_font,			
		font_size = 0.04, 			//this is in screen space, so big text.
		font_spacing = 0,			//
		font_color = {0,0,0,1},
	}

	p1 : gui.Destination = {self_anchor = .center_right, anchor = .center_right, rect = {-0.05, 0, 0.3, 0.9}};
	panel1 := gui.init_panel(p1);

	my_theme := gui.load_theme_from_filename("res/themes/simple.theme", font_style);	
	gui.push_theme(my_theme);
	*/

	for !should_close(window) {
		begin_frame(window, clear_color = {0.564, 0.44, 0.34, 1});
		
		zoom += zoom * render.get_scroll_delta().y * 0.05;

		dir = auto_cast glsl.normalize_vec3(auto_cast my_camera.position);
		my_camera.position 	= (dir * 1 / zoom);

		//fmt.printf("my_camera.position : %v", my_camera.position);
		
		//////// Draw 3D ////////
		begin_mode_3D(my_camera);

		bind_shader(shell_shader);
		for i := 0; i < cast(int)number_of_layers; i+=1 {
			s : f32 = 1 + auto_cast i * spaceing;
			transform : matrix[4, 4]f32 = linalg.matrix4_scale_f32({s,s,s});
			
			//place_uniform(shell_shader, Uniform_location.shell_heigth_value, f32(0.5));

			//TODO instanced meshing
			draw_mesh_single(shell_shader, sphere, transform);
		}
		unbind_shader(shell_shader);
		
		end_mode_3D(my_camera);
		//////////////////////////

		/* 
		my_camera := get_pixel_space_camera();
		begin_mode_2D(my_camera, use_transparency = true);
		gui.begin();

		gui.draw_rect(p1);
		gui.push_panel(&panel1);
			gui.draw_label("Options", {.top_center, .top_center,  {0, 0, 0.25, 0.05}});
			spaceing = gui.draw_slider(spaceing, {.top_center, .top_center,  {0, -0.05, 0.25, 0.05}});
			//number_of_layers, _ = gui.draw_slide_input(auto_cast number_of_layers, false, 0, 1024, {.top_center, .top_center,  {0, -0.15, 0.25, 0.05}});
		gui.pop_panel(&panel1);

		gui.draw_label("Press space", {.bottom_center, .bottom_center,  {0, 0, 0.25, 0.08}});

		gui.end();
		end_mode_2D(my_camera);
		*/

		end_frame(window);
	}

	//gui.pop_theme(my_theme);
	destroy_window(&window);

	destroy_render();
}




