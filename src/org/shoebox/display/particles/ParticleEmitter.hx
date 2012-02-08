package org.shoebox.display.particles;

import nme.display.Sprite;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.Graphics;
import org.shoebox.libs.nevermind.behaviors.Wander;
import org.shoebox.libs.nevermind.entity.SteeringEntity;

/**
 * ...
 * @author shoe[box]
 */

class ParticleEmitter{

	private var _aParticles : Array<Particle>;
	private var _gDefault : Graphics;
	private var _oEntity    : SteeringEntity;
	private var _oSheet     : Tilesheet;
	private var _oWander    : Wander;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( s : Tilesheet , gDefault : Graphics = null ) {
			
			_oSheet     = s;
			_aParticles = new Array<Particle>( );
			_oWander    = new Wander( 0 );
			_oEntity    = new SteeringEntity( );
			_gDefault   = gDefault;

			_oEntity.addBehavior( _oWander );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function emitAt( g : Graphics , id : Int , fScl : Float , posX : Float , posY : Float , fRot : Float = 0.0 , fTtl : Float = 10.0 , velX : Float = 0.0 , velY : Float = 0.0 , fWander:  Float = 0.0 , fEndAlpha : Float = 1.0  ) : Void {
			
			_aParticles.unshift( { g : g , fRot : fRot , fScl : fScl , fTime : 0.0 , fTtl : fTtl , tileId : id , posX : posX , posY : posY , velX : velX , velY : velY , fWander : fWander , fEndAlpha : fEndAlpha  } );
				
		}

		/**
		* x, y , velX , velY , duration , rotation , scale , alpha
		* 
		* @public
		* @return	void
		*/
		public function emit( 
								tileId   : Int , 
								posX     : Float, 
								posY     : Float , 
								velX     : Float, 
								velY     : Float , 
								duration : Float , 
								fWander  : Float = 0.0,
								fRot     : Float = 0.0, 
								fScale   : Float = 1.0, 
								fAlpha   : Float = 1.0								
							 ) : Void {
			
			var p : Particle = { 
									g         : _gDefault,
									posX      : posX,
									posY      : posY,
									velX      : velX,
									velY      : velY,
									fTtl      : duration,	
									fRot      : fRot,
									fScl      : fScale,
									fEndAlpha : fAlpha,
									fTime     : 0.0,								
									fWander   : fWander,
									tileId    : tileId
								}
			_aParticles.unshift( p );
		}
			
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( iDelay : Int ) : Void {
			
			var aF : Array<Float> = new Array<Float>( );
			var oG : Graphics = null;			
			for( p in _aParticles ){
						
				if( oG != null && oG != p.g ){
					_drawTiles( oG , aF );
					aF = new Array<Float>( );
				}

				if( oG == null ){
					oG = p.g;
					aF = new Array<Float>( );
				}

				_oWander.setValue( p.fWander );

				_oEntity.position.x = p.posX;
				_oEntity.position.y = p.posY;
				_oEntity.velocity.x = p.velX;
				_oEntity.velocity.y = p.velY;
				_oEntity.update( );


				p.velX = _oEntity.velocity.x;
				p.velY = _oEntity.velocity.y;
				p.posX = _oEntity.position.x;
				p.posY = _oEntity.position.y;

				aF.push( _oEntity.position.x );
				aF.push( _oEntity.position.y );
				aF.push( p.tileId );
				aF.push( p.fScl );
				aF.push( p.fRot );

				if( p.fEndAlpha == 1 )
					aF.push( 1.0 );
				else if( p.fEndAlpha == 0.0 ){
					aF.push( 1 - p.fTime / p.fTtl );
				}
				
				p.fTime += iDelay;
				if( p.fTime > p.fTtl )
					_aParticles.remove( p );
			}

			_drawTiles( oG , aF );
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _drawTiles( g : Graphics , aF : Array<Float> ) : Void{
			_gDefault.clear( );
			_oSheet.drawTiles( _gDefault , aF , false , Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA );
		}

	// -------o misc
	
}
private typedef Particle = {
	public var g : Graphics;
	public var posX    : Float;
	public var posY    : Float;
	public var velX    : Float;
	public var velY    : Float;
	public var fTtl    : Float;
	public var fRot : Float;
	public var fScl : Float;
	public var fEndAlpha : Float;
	public var fTime   : Float;
	public var fWander : Float;
	public var tileId  : Int;
}