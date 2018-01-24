precision highp float;

varying highp vec2 v_texcoord;
uniform sampler2D image0;

uniform int width;
uniform int height;

uniform float curveR0[200];
uniform float curveR1[56];
uniform float curveG0[200];
uniform float curveG1[56];
uniform float curveB0[200];
uniform float curveB1[56];

uniform float mvSmoothSize;

float mv_green_mix(float g1, float g2)
{
    float g = g2 + 1.0 - 2.0 * g1;
    g = clamp(g, 0.0, 1.0);
    return mix(g, g2, 0.5);
}

float mv_high_mix(float hg, float flag)
{
    float g = clamp(hg, 0.0001, 0.9999);
    return mix(g/(2.0*(1.0-g)), 1.0 - (1.0-g)/(2.0*g), flag);
}

void main(void)
{
    vec2 uv  = v_texcoord.xy;
    vec4 init_color = texture2D(image0, v_texcoord);
    
    float addnum = 8.0;
    vec4 blur_color = init_color * addnum;
    float threth = 30.0/255.0;
    float location_x = 1.0 / float(width);
    float location_y = 1.0 / float(height);
    vec4 compare_color = texture2D(image0, v_texcoord + mvSmoothSize*vec2( -4.0 * location_x, 0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += compare_color;
        addnum += 1.0;
    }
    compare_color = texture2D(image0, v_texcoord + mvSmoothSize*vec2( -3.0 * location_x, 0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + mvSmoothSize*vec2( -2.0 * location_x,  0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + mvSmoothSize*vec2( -1.0 * location_x, 0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 3.0 *compare_color;
        addnum += 3.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 4.0 * location_x, 0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += compare_color;
        addnum += 1.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 3.0 * location_x,  0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 2.0 * location_x, 0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0 *compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( location_x, 0.0));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 3.0*compare_color;
        addnum += 3.0;
    }
    
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0,  -4.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += compare_color;
        addnum += 1.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0, -3.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0, -2.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0, -1.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 3.0*compare_color;
        addnum += 3.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0,  4.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += compare_color;
        addnum += 1.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0, 3.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0, 2.0 * location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 2.0*compare_color;
        addnum += 2.0;
    }
    compare_color = texture2D(image0, v_texcoord + 1.0 * mvSmoothSize*vec2( 0.0, location_y));
    if(abs(compare_color.r - init_color.r) < threth)
    {
        blur_color += 3.0*compare_color;
        addnum += 3.0;
    }
    blur_color /= addnum;
    
    //highpass
    float hg = mv_green_mix(blur_color.r, init_color.r);
    float flag = step(hg, 0.5);
    hg = mv_high_mix(hg, flag);
    hg = mv_high_mix(hg, flag);
    hg = mv_high_mix(hg, flag);
    
    hg = clamp(hg, 0.0, 1.0);
    if(hg > 0.2){
        hg = pow((hg - 0.2) * 1.25, 0.5)*0.8 + 0.2;
    }
    hg = 1.0 - hg;
    hg = hg + 0.6;
    hg = clamp(hg, 0.0, 1.0);
    hg = hg - 0.6;
    hg = clamp(hg, 0.0, 1.0);
    hg = (hg-0.2)*4.0;
    hg = (hg-0.7)*2.0;
    hg = clamp(hg, 0.0, 1.0);
    vec4 diff = init_color - blur_color;
    blur_color += vec4(diff.r*hg, diff.r*hg, diff.r*hg, 0.0);
    blur_color = clamp(blur_color, vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0));
    
    int index = 0;
    index = int(blur_color.r*255.0);
    if (index < 200) {
        blur_color.r = curveR0[index];
    } else {
        blur_color.r = curveR1[index-200];
    }
    index = int(blur_color.g*255.0);
    if (index < 200) {
        blur_color.g = curveG0[index];
    } else {
        blur_color.g = curveG1[index-200];
    }
    index = int(blur_color.b*255.0);
    if (index < 200) {
        blur_color.b = curveB0[index];
    } else {
        blur_color.b = curveB1[index-200];
    }
    
    gl_FragColor = blur_color.rgba;
}
