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

import flash.display.Graphics;
import org.shoebox.geom.AABB;

/**
 * ...
 * @author shoe[box]
 */

class Parallax{

	public var fov( default , default ) : Float;

	private var _aLayer : Array<ParallaxLayer>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			reset( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function reset( ) : Void {
			this.fov = 60;
			_aLayer = [ ];
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function addLayer( index : Int , bounds : AABB , fDistance : Float = 1.0 ) : Void {
			_aLayer[ index ] = { bounds : bounds , fDistance : fDistance };
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function move( fx : Float , fy : Float ) : Void {
			
			var fTan = Math.tan( fov );
			for( l in _aLayer ){

				if( l == null )
					continue;

				l.bounds.translate( Math.round( l.fDistance * fTan * fx ) , 0 );
			}

		}

		#if debug
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function debug( g : Graphics ) : Void {
			for( l in _aLayer ){
				if( l == null )
					continue;
				g.lineStyle( 1 , 0 );
				g.moveTo( l.bounds.min.x , l.bounds.min.y );
				g.lineTo( l.bounds.max.x , l.bounds.max.y );
				g.drawRect( l.bounds.min.x , l.bounds.min.y , l.bounds.width , l.bounds.height );
				g.endFill( );
			}
		}
		#end

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get_aabb_intersection_with( aabb : AABB , layerIndex : Int ) : AABB {
			
			var l = _aLayer[ layerIndex ];
			if( !aabb.intersect( l.bounds ) )
				return null;

			var res = aabb.intersection( l.bounds );
				res.translate( -l.bounds.min.x , -l.bounds.min.y );
			
			return res;
		}

	// -------o protected
	
		

	// -------o misc
	
}

typedef ParallaxLayer={
	public var bounds : AABB;
	public var fDistance : Float;
}