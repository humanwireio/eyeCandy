precision mediump float;
uniform vec2 resolution;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void){
  vec2 uv = (gl_FragCoord.xy / resolution.xy) * vec2(int(125.*sin(time/100.)), int(125.*fract(time)));
  // gl_FragColor = vec4(vec3(rand(uv)), 1);
  gl_FragColor = vec4(0);
}
