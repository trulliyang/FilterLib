precision mediump float;

varying vec2 v_texcoord;

uniform sampler2D u_image0;

//uniform int u_isRGBA;

void main()
{
//    vec4 color = texture2D(u_image0, v_texcoord).rgba;
//    gl_FragColor = color;
    float r = texture2D(u_image0, v_texcoord).r;
    gl_FragColor = vec4(r, r, r, 1.0);
}