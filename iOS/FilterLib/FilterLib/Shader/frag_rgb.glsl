precision mediump float;

varying vec2 v_texcoord;

uniform sampler2D image0;

uniform int isRGBA;

void main()
{
    // bgra
    // rgba
    vec4 color = texture2D(image0, v_texcoord);
    if (1 == isRGBA) {
        gl_FragColor = vec4(color.rgb, 1.0);
    } else {
        gl_FragColor = vec4(color.bgr, 1.0);
    }
//    gl_FragColor = vec4(color.rgb, 1.0);
//    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);

}
