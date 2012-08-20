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
package org.shoebox.display.particles;

import nme.errors.Error;
import nme.display.Sprite;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.Graphics;
import org.shoebox.display.tile.TileDesc;
import org.shoebox.libs.nevermind.behaviors.Wander;
import org.shoebox.libs.nevermind.entity.SteeringEntity;

/**
 * ...
 * @author shoe[box]
 */
class ParticleEmitter extends Sprite{

	private var _aParticle : Array<Particle>;
	private var _iFormat   : Int;
	private var _oSheet    : Tilesheet;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( sheet : Tilesheet ,format : Int = 0 ) {
			super( );
			_oSheet = sheet;
			_aParticle = [ ];
			_iFormat = format;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function emit( posX : Float , posY : Float , fx : Float , fy : Float , ttl : Float , tileId : Int = 0 ) : Particle {

			var w =  new Wander( Math.random( ) );
				
			var p = new Particle( _iFormat );
				p.position.x = posX;
				p.position.y = posY;
				p.fTtl       = ttl;
				p.tileId     = tileId;
				p.velocity.x = fx;
				p.velocity.y = fy;
				p.addBehavior( w );
			_aParticle.push( p );

			return p;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( delay : Int , updateFunc : Particle -> Void = null ) : Void {
			
			if( _aParticle.length == 0 )
				return;

			var res : Array<Float> = [ ];
			
			for( p in _aParticle ){
				p.fTtl -= delay;
				if( updateFunc != null )
					updateFunc( p );

				if( p.fTtl <= 0 ){
					_aParticle.remove( p );
					continue;
				}
				p.update( );
				res = res.concat( p.desc.getArray( ) );
			}
			
			
			//try{
				graphics.clear( );
				if( res.length > 0 )
					_oSheet.drawTiles( graphics , res , false , _iFormat );
			
		}

	// -------o protected
	
	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class Particle extends SteeringEntity{

	public var tileId( default , _setTileId ) : Int;

	//public var tileId : Int;
	public var fTtl   : Float;
	public var desc   : TileDesc;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( format : Int = 0 ) {
			super( );
			fTtl   = 1000;
			desc = new TileDesc( );
			desc.format = format;
			tileId = 0;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setPosition( ) : Void {
						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function update( ) : Void {
			super.update( );		
			desc.x = position.x;
			desc.y = position.y;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setTileId( id : Int ) : Int{
			desc.tileId = id;
			return this.tileId = id;
		}

	// -------o misc
	
}