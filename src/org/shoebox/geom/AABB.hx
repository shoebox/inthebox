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
package org.shoebox.geom;

import nme.display.Graphics;
import nme.geom.Rectangle;
import org.shoebox.geom.FPoint;

/**
 * ...
 * @author shoe[box]
 */

class AABB{

	public var width( _getWidth , null ) : Float;
	public var height( _getHeight , null ) : Float;
	public var min   : FPoint;
	public var max   : FPoint;
	public var center: FPoint;

	// -------o constructor
		
		/**
		* AABB contructor
		*
		* @param 	l : Top Left X Position 		( Float )
		* @param 	t : Top Left Y Position 		( Float )
		* @param 	r : Bottom Right X Position 	( Float )
		* @param 	b : Bottom Right Y Position 	( Float )
		* @return	void
		*/
		public function new( l : Float = 0.0 , t : Float = 0.0 , r : Float = 0.0 , b : Float = 0.0 ) {
			min    = { x : l , y : t };
			max    = { x : r , y : b };
			center = { 
						x : min.x + ( max.x - min.x ) / 2 ,
						y : min.y + ( max.y - min.y ) / 2
					};
		}
	
	// -------o public
		
		/**
		* Create an AABB from a Rectangle
		* 
		* @public
		* @param 	r : Rectangle to convert to AABB 	( Rectangle )
		* @return	converted rectangle 				( AABB )
		*/
		public function clone( ) : AABB {
			return new AABB( min.x , min.y , max.x , max.y );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function fromRect( r : Rectangle ) : AABB {			
			return new AABB( r.x , r.y , r.x + r.width , r.y + r.height );
		}

		/**
		* Test if the AABB intersect with another AABB
		* 
		* @public
		* @param 	aabb : AABB to be tested 	( AABB )
		* @return	true if the AABB intersects ( Bool )
		*/
		inline public function intersect( aabb : AABB ) : Bool {
		
			if( min.x >= aabb.max.x || max.x <= aabb.min.x ) 
				return false;
			else if( min.y >= aabb.max.y || max.y <= aabb.min.y ) 
				return false;
           else
				return true;
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function intersectCoords( dx1 : Float , dy1 : Float , dx2 : Float , dy2 : Float ) : Bool {
		   return !( ( min.x >= dx2 || max.x <= dx1 ) || ( min.y >= dy2 || max.y <= dy1 ) );	
		}

		/**
		* Test if the AABB contains the point
		* 
		* @public
		* @param 	dx : Point X position 	( Float )
		* @param 	dy : Point Y position 	( Float )
		* @return	true if contained		( Bool )
		*/
		inline public function containPoint( dx : Float , dy : Float ) : Bool {
			return ( dx >= min.x && dx <= max.x && dy >= min.y && dy <= max.y );
		}

		/**
		* Trace the AABB
		* 
		* @public
		* @return	AABB to string 			( String )
		*/
		public function toString( ) : String {
			return '[ AABB > [ min : '+min.x+' '+min.y+' | max '+max.x+' '+max.y+' ] ]';
		}

		/**
		* Draw a debug graphics
		* 
		* @public
		* @return	void
		*/
		public function debug( g : Graphics ) : Void {
			g.drawRect( min.x , min.y , max.x - min.x , max.y - min.y );
		}

		/**
		* Test if the AABB contains another AABB
		* 
		* @public
		* @param 	aabb : AABB to be tested	( AABB )
		* @return	true if contained			( Bool )
		*/
		inline public function containAABB( aabb : AABB ) : Bool {
			return ( aabb.max.x <= max.x && aabb.max.y <= max.y && aabb.min.x >= min.x && aabb.min.y >= min.y );
		}

		/**
		* Translate the AABB with
		* 
		* @public
		* @param 	fx : Translate by X 	( Float )
		* @param 	fx : Translate by Y 	( Float )
		* @return	void
		*/
		inline public function translate( fx : Float , fy : Float ) : Void {
			min.x += fx;
			max.x += fx;
			min.y += fy;
			max.y += fy;
		}

	// -------o protected
		
		/**
		* Getter of the AABB width
		* 
		* @private
		* @return	AABB width ( Float )
		*/
		private function _getWidth( ) : Float{
			return max.x - min.x;
		}

		/**
		* Getter of the AABB height
		* 
		* @private
		* @return	AABB height ( Float )
		*/
		private function _getHeight( ) : Float{
			return max.y - min.y;
		}

	// -------o misc
	
}

private typedef Pos={
	public var x : Float;
	public var y : Float;
}