precision mediump float;

varying vec2 v_texcoord;
uniform sampler2D u_image0;

void main()
{

    vec4 color = texture2D(u_image0, v_texcoord);
    gl_FragColor = vec4(color.rgb, 1.0);
}