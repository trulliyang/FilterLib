precision mediump float;

varying vec2 v_texcoord;

uniform sampler2D image0;
uniform sampler2D image1;

void main()
{
    highp float y = texture2D(image0, v_texcoord).r;
    highp float u = texture2D(image1, v_texcoord).r - 0.5;
    highp float v = texture2D(image1, v_texcoord).a - 0.5;
    
    v = clamp(v, 0.0, 1.0);
    
    
    highp float r = y             + 1.402 * v;
    highp float g = y - 0.344 * u - 0.714 * v;
    highp float b = y + 1.772 * u;

    
    gl_FragColor = vec4(r, g, b, 1.0);
    
//        vec4 c =vec4(texture2D(image0, v_texcoord).r-16.0/255.0)*1.164;
//        //We had put the U and V values of each pixel to the A and R,G,B
//        //components of the texture respectively using GL_LUMINANCE_ALPHA.
//        //Since U,V bytes are interspread in the texture, this is probably
//        //the fastest way to use them in the shader
//        vec4 u= vec4(texture2D(image1, v_texcoord).r - 0.5);
//        vec4 v = vec4(texture2D(image1, v_texcoord).a - 0.5);
//        c += v * vec4(1.596, -0.813, 0, 0);
//        c += u * vec4(0, -0.392, 2.017, 0);
//        c.a = 1.0;
//        gl_FragColor = c;
}
