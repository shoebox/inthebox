/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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