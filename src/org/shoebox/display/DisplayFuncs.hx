package  org.shoebox.display;
import nme.display.DisplayObject;
import nme.display.StageAlign;
import nme.geom.Rectangle;

/**
 * ...
 * @author shoe[box]
 */

class DisplayFuncs{

	// -------o constructor
	
	// -------o public
		
		/**
		* 
		*
		* @param 
		* @return
		*/
		static public function align( o : DisplayObject , oREC : Rectangle , sAlign : StageAlign = null , dx : Int = 0 , dy : Int = 0 ) : Void {
			
			switch(sAlign){
				
				case StageAlign.RIGHT:
				case StageAlign.TOP_RIGHT:
				case StageAlign.BOTTOM_RIGHT:
					o.x = oREC.x + (oREC.width - o.width);
				
				case StageAlign.TOP:
				
				case StageAlign.LEFT:
				case StageAlign.TOP_LEFT:
				case StageAlign.BOTTOM_LEFT:
					o.x = oREC.x;
				
				case StageAlign.BOTTOM:
				default:
					o.x = oREC.x + (oREC.width - o.width)/2;
				
			}
			
			switch(sAlign){
				
				case StageAlign.BOTTOM:
				case StageAlign.BOTTOM_RIGHT:
				case StageAlign.BOTTOM_LEFT:
					o.y = oREC.y + (oREC.height - o.height);
				
				case StageAlign.TOP:
				case StageAlign.TOP_RIGHT:
				case StageAlign.TOP_LEFT:
					o.y = oREC.y;
				
				default:
					o.y = oREC.y + (oREC.height - o.height)/2;
				
			}
			
			o.x += dx;
			o.y += dy;
			
		}
	
	// -------o protected

	// -------o misc
	
	
}