package org.shoebox.core;

import nme.Lib;
import nme.display.Sprite;

/**
 * ...
 * @author shoe[box]
 */

class Vector2D {

	public var length	( _getLength 	, _setLength ) 	: Float;
	public var lengthSQ	( _getLengthSquare 	, null ) 	: Float;
	public var angle	( _getAngle 	, _setAngle ) 	: Float;
	public var x		( _getPosX 		, _setPosX ) 	: Float;
	public var y		( _getPosY 		, _setPosY ) 	: Float;
	
	public var dx			: Float;
	public var dy 			: Float;
	
	// -------o constructor
		
		/**
		* FrontController constructor method
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new( dx : Float = 0 , dy : Float = 0 ) {
			this.dx = dx;
			this.dy = dy;
		}
	
	// -------o public
		
		public static function getNormalValue( v : Vector2D ) : Vector2D {
			
			var x : Float = v.x;
			var y : Float = v.y;
			
            var normal : Vector2D = new Vector2D();

            if (x != 0)
            {
                normal.x = -y / x;
                normal.y = 1 / Math.sqrt(normal.x * normal.x + 1);
                normal.normalize( );
            }else if (y != 0){
                normal.y = 0;
                normal.x = ( v.y < 0) ? 1 : -1;
            }else{
                normal.x = 1;
                normal.y = 0;
            }

            if (x < 0){
                normal.scaleBy( -1 );
            }

            return normal;

		}
	
		public function clone( ) : Vector2D {
			return new Vector2D( dx , dy );
		}
		
		public function reset( ) : Vector2D {
			dx = 0;
			dy = 0;
			return this;
		}
		
		public function isZero( ) : Bool {
			return ( dx == 0 && dy == 0 );
		}
		
		public function normalize( ) : Vector2D {
			
			var len : Float = _getLength( );
			if ( len == 0 ) {
				dx = 1;
				return this;
			}
			
			dx /= len;
			dy /= len;
			return this;
		}
		
		public function truncate( max : Float ) : Vector2D {
			length = Math.min( max , length );
			return this;
		}
		
		public function reverse( ) : Vector2D {
			dx = -dx;
			dy = -dy;
			return this;
		}
		
		public function decrementBy( v2 : Vector2D ) : Vector2D {
			dx -= v2.x;
			dy -= v2.y;
			return this;
		}
		
		public function isNormalized( ) : Bool {
			return _getLength( ) == 1;
		}
		
		public function dotProd( v2 : Vector2D ) : Float {
			return dx * v2.x + dy * v2.y;
		}
		
		static public function angleBetween( v1 : Vector2D , v2 : Vector2D ) : Float {
			if ( !v1.isNormalized( ) ) 
				v1 = v1.clone( ).normalize( );
				
			if ( !v2.isNormalized( ) )
				v2 = v2.clone( ).normalize( );
				
			return Math.acos( v1.dotProd( v2 ) );
		}
		
		public function sign( v2 : Vector2D ) : Int {
			return getPerp( ).dotProd( v2 ) < 0 ? -1 : 1;
		}
		
		public function getNormal( ) : Vector2D {
			var l: Float = _getLength( );
			if ( l != 0 )
				return new Vector2D ( -y / l , x / l );
			else
				return new Vector2D( );
		}
		
		public function getPerp( ) : Vector2D {
			return new Vector2D( -y , x );
		}
		
		public function dist( v2 : Vector2D ) : Float {
			return Math.sqrt( distSQ( v2 ) );
		}
		
		public function distSQ( v2 : Vector2D ) : Float {
			var dx : Float = v2.x - dx;
			var dy : Float = v2.y - dy;
			return dx * dx + dy * dy;
		}
		
		public function incrementBy( v2 : Vector2D ) : Vector2D {
			dx += v2.x;
			dy += v2.y;
			return this;
		}
		
		public function add( v2 : Vector2D ) : Vector2D {
			return new Vector2D( dx + v2.x , dy + v2.y );
		}
		
		public function sub( v2 : Vector2D ) : Vector2D {
			return new Vector2D( dx - v2.x , dy - v2.y );
		}
		
		public function mul( value : Float ) : Vector2D {
			return new Vector2D( dx * value , dy * value );
		}
		
		public function multiply( v2 : Vector2D ) : Vector2D {
			return new Vector2D( dx * v2.x , dy * v2.y );
		}
		
		public function divide( v2 : Vector2D ) : Vector2D {
			return new Vector2D( dx / v2.x , dy / v2.y );
		}
		
		public function divideBy( n : Float ) : Vector2D {
			dx /= n;
			dy /= n;
			return this;
		}
		
		public function scaleBy( n : Float ) : Vector2D {
			dx *= n;
			dy *= n;
			return this;
		}
		
		public function isEquatTo( v2 : Vector2D ) : Bool {
			return ( dx == v2.x && dy == v2.y );
		}
		
		public function toString( ) : String {
			return 'Vector2D - x : ' + dx + ' | y : ' + dy;
		}
		
	// -------o protected
		
		private function _setLength( len : Float ) : Float {
			
			var a : Float = _getAngle( );
			dx = Math.cos( a ) * len;
			dy = Math.sin( a ) * len;
			
			return len;
		}
	
		private function _getLength( ) : Float {
			return Math.sqrt( _getLengthSquare( ) );
		}
		
		private function _getLengthSquare( ) : Float {
			return dx * dx + dy * dy;
		}
		
		private function _setAngle( angle : Float ) : Float {
			var len : Float = _getLength( );
			dx = Math.cos( angle ) * len;
			dy = Math.sin( angle ) * len;
			return len;
		}
		
		private function _getAngle( ) : Float {
			return Math.atan2( dy , dx );
		}
		
		private function _setPosX( pos : Float ) : Float {
			dx = pos;
			return dx;
		}
		
		private function _getPosX( ) : Float {
			return dx;
		}
		
		private function _setPosY( pos : Float ) : Float {
			dy = pos;
			return dy;
		}
		
		private function _getPosY( ) : Float {
			return dy;
		}

	// -------o misc
	
}