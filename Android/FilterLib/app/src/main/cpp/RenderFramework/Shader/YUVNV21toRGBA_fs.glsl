precision mediump float;

varying vec2 v_texcoord;

uniform sampler2D u_image0;
uniform sampler2D u_image1;

void main()
{
    highp float y = texture2D(u_image0, v_texcoord).r;
    highp float u = texture2D(u_image1, v_texcoord).a - 0.5;
    highp float v = texture2D(u_image1, v_texcoord).r - 0.5;

    highp float r = y             + 1.402 * v;
    highp float g = y - 0.344 * u - 0.714 * v;
    highp float b = y + 1.772 * u;

    gl_FragColor = vec4(r, g, b, 1.0);
}