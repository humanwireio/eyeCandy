class fragShaderPatch extends patch {
  PShader frag_shader;
  private PApplet app;
  
  fragShaderPatch(String filename){
    super();
    frag_shader = loadShader(filename);
  }
  
  fragShaderPatch(PShader fs){
    super();
    frag_shader = fs;
  }
  
  void render(){
    filter(frag_shader);
  }
}
