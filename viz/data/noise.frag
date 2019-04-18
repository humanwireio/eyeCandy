#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453 * sin(time));
}

void main(){
  vec2 uv = gl_FragCoord.xy;
  gl_FragColor = vec4(vec3(rand(uv)), 1.);
  // gl_FragColor = vec4(0);
}
