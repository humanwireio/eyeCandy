class patch {
 Boolean isActive;
 String name;
  
 patch(){
   this.isActive = false;
 } 
 
 void render(){
   if (isActive) {
     _render();
   }
 }
 
 void _render(){
 }
 
 void setIsActive(){
   setIsActive(false);
 }
 
 void setIsActive(Boolean val){
   this.isActive = val;
 }
 
 void mouseDragged(){
 }
  
}
