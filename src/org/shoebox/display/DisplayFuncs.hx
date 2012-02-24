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
package org.shoebox.display;
import nme.display.DisplayObject;
import nme.display.StageAlign;
import nme.geom.Rectangle;
import org.shoebox.geom.AABB;

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
		static public function align( o : DisplayObject , aabb : AABB , sAlign : StageAlign = null , dx : Int = 0 , dy : Int = 0 ) : Void {
			
			var centerX : Float = aabb.min.x + ( aabb.max.x - aabb.min.x - o.width ) / 2;
			var centerY : Float = aabb.min.y + ( aabb.max.y - aabb.min.y - o.height ) / 2;

			if( sAlign == null ){
				o.x = centerX + dx;
				o.y = centerY + dy;
				return;
			}

			switch( sAlign ){

				case StageAlign.TOP:
					o.x = centerX;
					o.y = aabb.min.y;

				case StageAlign.LEFT:
					o.x = aabb.min.x;
					o.y = centerY;

				case StageAlign.RIGHT:
					o.x = aabb.max.x - o.width;
					o.y = centerY;

				case StageAlign.BOTTOM:
					o.x = centerX;
					o.y = aabb.max.y - o.height;

				case StageAlign.TOP_LEFT:
					o.x = aabb.min.x;
					o.y = aabb.min.y;

				case StageAlign.BOTTOM_LEFT:
					o.x = aabb.min.x;
					o.y = aabb.max.y - o.height;

				case StageAlign.TOP_RIGHT:
					o.x = aabb.max.x - o.width;
					o.y = aabb.min.y;

				case StageAlign.BOTTOM_RIGHT:
					o.x = aabb.max.x - o.width;
					o.y = aabb.max.y - o.height;
			}
			
			
			o.x += dx;
			o.y += dy;
			
		}
	
	// -------o protected

	// -------o misc
	
	
}