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

import org.shoebox.geom.FPoint;

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
	* 
	* 
	* @public
	* @return	void
	*/
	inline static public function intClamp( f : Int , fMin : Int , fMax : Int ) : Int {
		return ( f < fMin) ? fMin : ( f > fMax) ? fMax : f;			
	}

	/**
	* 
	* 
	* @public
	* @return	void
	*/
	static public function angleBetween( x1 : Float , y1 : Float , x2 : Float , y2 : Float ) : Float {
		return Math.atan ( ( y2 - y1 ) / ( x2 - x1 ) );
	}
	
	/**
	* distance function
	* @public
	* @param 
	* @return
	*/
	inline static public function distance( x1 : Float , y1 : Float , x2 : Float , y2 : Float ) : Float {
		
		var dx : Float = Math.abs( x1 - x2 );
		var dy : Float = Math.abs( y1 - y2 );
		return Math.sqrt( dx * dx + dy * dy );
	}

	/**
	* 
	* 
	* @public
	* @return	void
	*/
	inline static public function length( fx : Float , fy : Float ) : Float {
		return fx * fx + fy * fy;
	}

	/**
	* 
	* 
	* @public
	* @return	void
	*/
	inline static public function lengthSq( fx : Float , fy : Float ) : Float {
		return Math.sqrt( length( fx , fy ) );			
	}

	/**
	* 
	* 
	* @public
	* @return	void
	*/
	inline static public function distance2( p1 : FPoint , p2 : FPoint ) : Float {
		var dx = Math.abs( p1.x - p2.x );
		var dy = Math.abs( p1.y - p2.y );
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

   /**
   * 
   * 
   * @public
   * @return	void
   */
   static public function bresenham( x0 : Int , y0 : Int , x1 : Int , y1 : Int , res : Array<Int> = null ) : Array<Int> {
   		
   		if( res == null )
   			res = new Array<Int>( );

   		
		var iIncX : Int = ( x1 - x0 ) > 0 ? 1 : -1;
		var iIncY : Int = ( y1 - y0 ) > 0 ? 1 : -1;
		var dx    : Int = Std.int( Math.abs( x1 - x0 ) );
		var dy    : Int = Std.int( Math.abs( y1 - y0 ) );

   		var iCumul : Int;
   		if( dx > dy ){

   			//
   				iCumul = Std.int( dx >> 1 );

   			//
	   			for( i in 1...dx ){
	   				x0 += iIncX;
	   				iCumul += dy;
	   				if( iCumul >= dx ){
	   					y0 += iIncY;
	   					iCumul -= dx;
	   				}
	   				res.push( x0 );
	   				res.push( y0 );
	   			}

	   		//
	   			for( i in 1...dy ){
	   				y0 += iIncY;
	   				iCumul += dx;
	   				if( iCumul >= dy ){
	   					x0 += iIncX;
	   					iCumul -= dy;
	   				}

	   				res.push( x0 );
	   				res.push( y0 );
	   			}
   		}

   		return res;
   }

   
   /**
   * 
   * 
   * @public
   * @return	void
   */
   inline static public function posToAngle( dx : Float  , dy : Float ) : Float {
		return RAD_TO_DEG * Math.atan2( dx , dy );
	}

   static public function lineIntersection2D( A : Vector2D , B : Vector2D , C : Vector2D , D : Vector2D ) : Dynamic {
	   	

   		var ADx = ( D.x - C.x );
   		var ACx = ( A.x - C.x );
   		var ACy = ( A.y - C.y );
   		var DCy = ( D.y - C.y );
   		var BAx = ( B.x - A.x );
   		var BAy = ( B.y - A.y );

   		var rTop : Float = ACy * ADx - ACx * DCy;
        var rBot : Float = BAx * DCy - BAy * ADx;
		
		var sTop : Float = ACy * BAx - ACx * BAy;
        var sBot : Float = BAx * DCy - BAy * ADx;
		
		/*
		var rTop : Float = ( A.y - C.y ) * ( D.x - C.x ) - ( A.x - C.x ) * ( D.y - C.y );
        var rBot : Float = ( B.x - A.x ) * ( D.y - C.y ) - ( B.y - A.y ) * ( D.x - C.x );
		
		var sTop : Float = ( A.y - C.y ) * ( B.x - A.x ) - ( A.x - C.x ) * ( B.y - A.y );
        var sBot : Float = ( B.x - A.x ) * ( D.y - C.y ) - ( B.y - A.y ) * ( D.x - C.x );
        */
		
		if ( ( rBot == 0 ) || ( sBot == 0 )) {
			//Line are parralels
			return null;
		}
		
		var point : Vector2D;
		var r : Float = rTop / rBot;
		var s : Float = sTop / sBot;
		
		if ( ( r > 0 ) && ( r < 1 ) && ( s > 0 ) && ( s < 1 ) ) {
			//point = A.add( B.sub( A ).scaleB.y( r ) );
			return { 
						point : ( B.sub( A ) ).scaleBy( r ).add( A ) , 
						dist : distance( A.x , A.y , B.x , B.y ) * r 
					};
		}else {
			return null;
		}
		
		return null;
   }

}

typedef Intersection={
	public var point : Vector2D;
	public var dist : Float;
}