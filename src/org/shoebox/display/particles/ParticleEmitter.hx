package org.shoebox.display.particles;

import nme.display.DisplayObjectContainer;
import org.shoebox.collections.ObjectPool;
import org.shoebox.core.BoxMath;
import org.shoebox.display.particles.Particle;
import org.shoebox.libs.nevermind.behaviors.Wander;

/**
 * ...
 * @author shoe[box]
 */

class ParticleEmitter<T:Particle>{

	private var _aParticles   : Array<T>;
	private var _cClass       : Class<T>;
	private var _bAlign       : Bool;
	private var _oContainer   : DisplayObjectContainer ;
	private var _fDelay       : Float;
	private var _fPosX        : Float;
	private var _fPosY        : Float;
	private var _fVelX        : Float;
	private var _fVelY        : Float;
	private var _fElapsed     : Float;
	private var _fTTL         : Float;
	private var _fWander      : Float;
	private var _bAlpha       : Bool;
	private var _iMaxParticle : Int;
	private var _iCount       : Int;
	private var _oPool        : ObjectPool<T>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( cClass : Class<T> , maxParticles : Int , container : DisplayObjectContainer , fDelay : Float , bAlpha : Bool = false ) {
			_aParticles   = new Array<T>( );
			_oPool        = new ObjectPool<T>( cClass , 100 );
			_iMaxParticle = maxParticles;
			_iCount       = 0;
			_oContainer   = container;
			_fDelay       = fDelay;
			_fElapsed     = 0;
			_bAlpha       = bAlpha;
			_fTTL         = 1000;
			_cClass       = cClass;
		}
	
	// -------o public


		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setPosition( dx : Float , dy : Float ) : Void {
			_fPosX = dx;
			_fPosY = dy;		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setVelocity( vx : Float , vy : Float ) : Void {
			_fVelX = vx;
			_fVelY = vy;	
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setWander( f : Float ) : Void {
			_fWander = f;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setTTL( f : Float ) : Void {
			_fTTL = f;				
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( fDelay : Float ) : Void {
			
			_fElapsed += fDelay;

			if( _fElapsed > _fDelay ){
				_fElapsed -= _fDelay;
				_emit( );
			}


			for( p in _aParticles ){
				p.update( fDelay );
				
				//
					if( _bAlign )
						p.rotation = BoxMath.RAD_TO_DEG * p.oEntity.getRotation( );
			
				//
					if( _bAlpha )
						p.alpha =  p.fTimeToLive / _fTTL;
				
				//
					if( p.fTimeToLive < 0 )
						_fKill( p );
			}
		}	

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _emit( ) : Void{
			
			if( _iCount >= _iMaxParticle )
				return;

			var p : T = _oPool.get( );
				p.init( _fPosX , _fPosY , _fTTL );
				p.oEntity.velocity.x = _fVelX ;
				p.oEntity.velocity.y = _fVelY ;
			
			if( _fWander > 0.0 )
				p.oEntity.addBehavior( new Wander( _fWander ) );

			_aParticles.push( p );
			_oContainer.addChild( p );

			_iCount++;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _fKill( p : T ) : Void {
			_oContainer.removeChild( p );
			_aParticles.remove( p );
			_iCount--;
			_oPool.put( p );
		}

	// -------o misc
	
}