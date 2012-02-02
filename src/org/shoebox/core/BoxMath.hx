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
	static public function clamp( a : Float , min : Float , max : Float ) : Float{
		return a < min ? min : a > max ? max : a;
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