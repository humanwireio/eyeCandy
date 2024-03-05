class vertShaderPatch extends patch {
  PShader vert_shader;
  vertShaderPatch(String filename){
    super();
    vert_shader = loadShader(filename);
  }
  
  void _render(){
    shader(vert_shader);
  }
}
