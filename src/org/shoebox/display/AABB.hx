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

import nme.display.Graphics;

/**
 * ...
 * @author shoe[box]
 */

class AABB{

	public var min : Pos;
	public var max : Pos;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( l : Float = 0.0 , t : Float = 0.0 , r : Float = 0.0 , b : Float = 0.0 ) {
			min = { x : l , y : t };
			max = { x : r , y : b };
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function intersect( aabb : AABB ) : Bool {
		
			if( min.x >= aabb.max.x || max.x <= aabb.min.x ) return false;
			if( min.y >= aabb.max.y || max.y <= aabb.min.y ) return false;
           
			return true;
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function containPoint( dx : Float , dy : Float ) : Bool {
			return ( dx >= min.x && dx <= max.x && dy >= min.y && dy <= max.y );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function fromRec( x : Float , y : Float , w : Float , h : Float ) : Void {
			min = { x : x , y : y };
			max = { x : x + w , y : y + h };
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return '[ AABB > [ min : '+min.x+' '+min.y+' | max '+max.x+' '+max.y+' ]]';
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function debug( g : Graphics ) : Void {
			g.drawRect( min.x , min.y , max.x - min.x , max.y - min.y );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function containAABB( aabb : AABB ) : Bool {
			return ( aabb.max.x <= max.x && aabb.max.y <= max.y && aabb.min.x >= min.x && aabb.min.y >= min.y );
		}

	// -------o protected
	
	// -------o misc
	
}

private typedef Pos={
	public var x : Float;
	public var y : Float;
}