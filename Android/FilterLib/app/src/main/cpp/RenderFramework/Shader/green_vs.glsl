attribute vec2 a_position;
//attribute vec3 a_color;
//attribute vec2 a_texcoord;

//varying vec2 v_texcoord;
//uniform float u_rotationDegree;

void main()
{
//    float degree = radians(rotationDegree);
////    const float degree = radians(270.0);//-90.0
////    const float degree = radians(0.0);
//    mat2 rotate = mat2(
//                             cos(degree), sin(degree),
//                             -sin(degree), cos(degree)
//                             );
//
//    gl_Position = vec4(rotate*position, 0.0, 1.0);
    gl_Position = vec4(a_position.x, a_position.y, 0.0, 1.0);
    //v_texcoord = a_texcoord;
}