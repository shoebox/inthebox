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

package org.shoebox.core;

/**
 * ...
 * @author shoe[box]
 */

class BoxMath 
{
	
	public static var DEG_TO_RAD	: Float = Math.PI / 180;
	public static var RAD_TO_DEG	: Float = 180 / Math.PI;
	
	/**
	* clamp function
	* @public
	* @param 
	* @return
	*/
	inline static public function clamp( f : Float , fMin : Float , fMax : Float ) : Float{
		return ( f < fMin) ? fMin : ( f > fMax) ? fMax : f;
	}
	
	/**
	* distance function
	* @public
	* @param 
	* @return
	*/
	static public function distance( x1 : Float , y1 : Float , x2 : Float , y2 : Float ) : Float {
		
		var dx : Float = Math.abs( x1 - x2 );
		var dy : Float = Math.abs( y1 - y2 );
		return Math.sqrt( dx * dx + dy * dy );
	}
	
	/**
   * toIndice function
   * @public
   * @param 
   * @return
   */
   static public function toIndice( u : Int , n : Int ) : String {
           
           var s : String='';
           var i : Int = 0;
			for( i in 0...n )
                   s+='0';
           
           return ( s + u ).substr(-n, n);
   
   }
   
   static public function lineIntersection2D( A : Vector2D , B : Vector2D , C : Vector2D , D : Vector2D ) : Dynamic {
	   
		var rTop : Float = (A.y-C.y)*(D.x-C.x)-(A.x-C.x)*(D.y-C.y);
        var rBot : Float = (B.x - A.x) * (D.y - C.y) - (B.y - A.y) * (D.x - C.x);
		
		var sTop : Float = (A.y - C.y) * (B.x - A.x) - (A.x - C.x) * (B.y - A.y);
        var sBot : Float = (B.x - A.x) * (D.y - C.y) - (B.y - A.y) * (D.x - C.x);
		
		var oObj : Dynamic = { } ;
		
		if ( ( rBot == 0 ) || ( sBot == 0 )) {
			//Line are parralels
			return null;
		}
		
		var point : Vector2D;
		var r : Float = rTop / rBot;
		var s : Float = sTop / sBot;
		
		if ( ( r > 0 ) && ( r < 1 ) && ( s > 0 ) && ( s < 1 ) ) {
			//point = A.add( B.sub( A ).scaleBy( r ) );
			oObj.point = ( B.sub( A ) ).scaleBy( r ).add( A );
			oObj.dist = distance( A.x , A.y , B.x , B.y ) * r;
			return oObj;
		}else {
			return null;
		}
		
		return null;
   }

}