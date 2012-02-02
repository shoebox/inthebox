package org.shoebox.core;

import fr.hyperfiction.caos.core.Variables;
import nme.Lib;
import nme.display.Sprite;
import org.shoebox.core.Vector2D;

/**
 * ...
 * @author shoe[box]
 */

class BoxLine {

	public var a			: Vector2D;
	public var b			: Vector2D;
	
	// -------o constructor
		
		/**
		* FrontController constructor method
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new( dx1 : Float , dy1 : Float , dx2 : Float , dy2 : Float ) {
			a = new Vector2D( dx1 , dy1 );
			b = new Vector2D( dx2 , dy2 );
		}
	
	// -------o public
		
		public function getOrth( p : Vector2D , lengthLeft : Float = 100 , lengthRight : Float = 100 ) : BoxLine {
			
			var v : Vector2D = b.sub( a ).getNormal( );
			var v1 : Vector2D =  p.add( v.mul( lengthLeft ) );
			var v2 : Vector2D =  p.add( v.mul( -lengthRight ) );
			
			return new BoxLine( v1.x , v1.y , v2.y , v2.y );
			
		}
		
		public function isLeft( p : Vector2D ) : Float {
			return ( b.x - a.x ) * ( p.y - a.y ) - ( p.x - a.x ) * ( b.y - a.y );
		}
	
		public function intersect( line : BoxLine ) : Bool {
			
			var x1:Float = a.x, y1:Float = a.y,
				x2:Float = b.x, y2:Float = b.y,
				x3:Float = line.a.x, y3:Float = line.a.y,
				x4:Float = line.b.x, y4:Float = line.b.y;
			
			var lA:Float = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
			var lB:Float = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);
			var lD:Float = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
			
			return (lD != 0) && (0 < lA/lD) && (lA/lD < 1) && (0 < lB/lD) && (lB/lD < 1);
		}
	
		public function intersection( vs : BoxLine ) : Vector2D {
			
			var x1:Float = a.x;
			var x2:Float = b.x;
			var x3:Float = vs.a.x;
			var x4:Float = vs.b.x;
				
			var y1:Float = a.y;
			var y2:Float = b.y;
			var y3:Float = vs.a.y;
			var y4:Float = vs.b.y;
				
			var d:Float =  ( y4 - y3 ) * (x2 - x1 ) - ( x4 - x3 ) * ( y2 - y1 );
				
			var ua:Float = (( x4 - x3 ) * ( y1 - y3 ) - ( y4 - y3 ) * ( x1 - x3 ) ) / d;
			var ub:Float = (( x2 - x1 ) * ( y1 - y3 ) - ( y2 - y1 ) * ( x1 - x3 ) ) / d;
				
			return new Vector2D( x1 + ua * ( x2 - x1 ), y1 + ua * ( y2 - y1 ) );
			
		}
	
		public function getPerpNormal( ) : Vector2D {
			
			var t : Vector2D = b.sub( a ).normalize( );
			var dx : Float = -t.y;
			var dy : Float = t.x;
			t.x = dx;
			t.y = dy;
			return t;
		}
		
		public function toString( ) : String {
			return 'BoxLine : '+a+' - '+b ;
		}
	
	// -------o protected
		
	// -------o misc
	
	
}