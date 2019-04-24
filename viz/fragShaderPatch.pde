class fragShaderPatch extends patch {
  PShader frag_shader;
  private PApplet app;
  
  fragShaderPatch(PApplet a, String filename){
    super();
    app = a;
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
