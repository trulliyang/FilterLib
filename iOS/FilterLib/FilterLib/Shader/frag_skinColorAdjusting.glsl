precision highp float;

varying highp vec2 v_texcoord;
uniform sampler2D image0;

uniform float curveR0[200];
uniform float curveR1[56];
uniform float curveG0[200];
uniform float curveG1[56];
uniform float curveB0[200];
uniform float curveB1[56];

void main(void)
{
    vec4 init_color = texture2D(image0, v_texcoord);

    int index = 0;
    index = int(init_color.r*255.0);
    if (index < 200) {
        init_color.r = curveR0[index];
    } else {
        init_color.r = curveR1[index-200];
    }
    index = int(init_color.g*255.0);
    if (index < 200) {
        init_color.g = curveG0[index];
    } else {
        init_color.g = curveG1[index-200];
    }
    index = int(init_color.b*255.0);
    if (index < 200) {
        init_color.b = curveB0[index];
    } else {
        init_color.b = curveB1[index-200];
    }
    
    gl_FragColor = init_color.rgba;
}
