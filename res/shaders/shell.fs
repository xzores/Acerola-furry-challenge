#version 330 core

in vec2 frag_texcoord; 

out vec4 final_color;

uniform sampler2D texture_diffuse;
uniform vec4 col_diffuse = vec4(1,1,1,1); 

void main()
{
	final_color = vec4(1,1,1,0.1);
}