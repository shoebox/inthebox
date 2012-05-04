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
	public var x		( default 		, _setPosX ) 	: Float;
	public var y		( default 		, _setPosY ) 	: Float;
	
	//public var this.x			: Float;
	//public var this.y 			: Float;
	
	// -------o constructor
		
		/**
		* FrontController constructor method
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new( fx : Float = 0 , fy : Float = 0 ) {
			//this.dx = dx;
			//this.this.y = this.y;
			this.x = fx;
			this.y = fy;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public static function getNormalValue( v : Vector2D ) : Vector2D {
			
			var x : Float = v.x;
			var y : Float = v.y;
			
            var normal : Vector2D = new Vector2D();

            if (x != 0){
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
	
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function clone( ) : Vector2D {
			return new Vector2D( this.x , this.y );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function reset( ) : Vector2D {
			this.x = 0;
			this.y = 0;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function isZero( ) : Bool {
			return ( this.x == 0 && this.y == 0 );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function normalize( ) : Vector2D {
			
			var len : Float = _getLength( );
			if ( len == 0 ) {
				this.x = 1;
				return this;
			}
			
			this.x /= len;
			this.y /= len;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function truncate( max : Float ) : Vector2D {
			length = Math.min( max , length );
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function reverse( ) : Vector2D {
			this.x = -this.x;
			this.y = -this.y;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function decrementBy( v2 : Vector2D ) : Vector2D {
			this.x -= v2.x;
			this.y -= v2.y;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function isNormalized( ) : Bool {
			return _getLength( ) == 1;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dotProd( v2 : Vector2D ) : Float {
			return this.x * v2.x + this.y * v2.y;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function angleBetween( v1 : Vector2D , v2 : Vector2D ) : Float {
			if ( !v1.isNormalized( ) ) 
				v1 = v1.clone( ).normalize( );
				
			if ( !v2.isNormalized( ) )
				v2 = v2.clone( ).normalize( );
				
			return Math.acos( v1.dotProd( v2 ) );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function sign( v2 : Vector2D ) : Int {
			return getPerp( ).dotProd( v2 ) < 0 ? -1 : 1;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getNormal( ) : Vector2D {
			var l: Float = _getLength( );
			if ( l != 0 )
				return new Vector2D ( -y / l , x / l );
			else
				return new Vector2D( );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getPerp( ) : Vector2D {
			return new Vector2D( -y , x );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dist( v2 : Vector2D ) : Float {
			return Math.sqrt( distSQ( v2 ) );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function distSQ( v2 : Vector2D ) : Float {
			var fx : Float = v2.x - this.x;
			var fy : Float = v2.y - this.y;
			return fx * fx + fy * fy;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function incrementBy( v2 : Vector2D ) : Vector2D {
			this.x += v2.x;
			this.y += v2.y;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add( v2 : Vector2D ) : Vector2D {
			return new Vector2D( this.x + v2.x , this.y + v2.y );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function sub( v2 : Vector2D ) : Vector2D {
			return new Vector2D( this.x - v2.x , this.y - v2.y );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function mul( value : Float ) : Vector2D {
			return new Vector2D( this.x * value , this.y * value );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function multiply( v2 : Vector2D ) : Vector2D {
			return new Vector2D( this.x * v2.x , this.y * v2.y );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function divide( v2 : Vector2D ) : Vector2D {
			return new Vector2D( this.x / v2.x , this.y / v2.y );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function divideBy( n : Float ) : Vector2D {
			this.x /= n;
			this.y /= n;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function scaleBy( n : Float ) : Vector2D {
			this.x *= n;
			this.y *= n;
			return this;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function isEquatTo( v2 : Vector2D ) : Bool {
			return ( this.x == v2.x && this.y == v2.y );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return 'Vector2D - x : ' + this.x + ' | y : ' + this.y;
		}
		
	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setLength( len : Float ) : Float {
			
			var a : Float = _getAngle( );
			this.x = Math.cos( a ) * len;
			this.y = Math.sin( a ) * len;
			
			return len;
		}
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getLength( ) : Float {
			return Math.sqrt( _getLengthSquare( ) );
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getLengthSquare( ) : Float {
			return this.x * this.x + this.y * this.y;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setAngle( angle : Float ) : Float {
			var len : Float = _getLength( );
			this.x = Math.cos( angle ) * len;
			this.y = Math.sin( angle ) * len;
			return len;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getAngle( ) : Float {
			return Math.atan2( this.y , this.x );
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setPosX( pos : Float ) : Float {
			this.x = pos;
			return this.x;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setPosY( pos : Float ) : Float {
			this.y = pos;
			return this.y;
		}
		

	// -------o misc
	
}