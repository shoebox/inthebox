package org.shoebox.medias;

import nme.errors.Error;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;
import org.shoebox.medias.BoxSound;

/**
 * ...
 * @author shoe[box]
 */

class SoundSpatializer{

	private var _hContent : Hash<SpatialSound>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			_hContent = new Hash<SpatialSound>( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add( sCode : String , sound : BoxSound , pos : FPoint , fRadius : Float ) : Void {

			if( _hContent.exists( sCode ) )
				throw new Error('Sound code '+sCode+' is already registered');

			var snd : SpatialSound = { 
										sCode : sCode,
										x : pos.x , 
										y : pos.y,
										sound : sound,
										radius : fRadius
									};
			_hContent.set( sCode , snd );
		}	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function remove( sCode : String ) : Bool {
			
			if( !_hContent.exists( sCode ) )
				return false;

			var snd : SpatialSound = _hContent.get( sCode );
				snd.sound.dispose( );

			return _hContent.remove( sCode );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( pos : FPoint ) : Void {
		
			var d : Float;
			for( s in _hContent ){

				d = BoxMath.distance2( s , pos );
				
				if( d > s.radius ){
					s.sound.pause( );
					continue;
				}
				s.sound.volume = 1 - d / s.radius;
				//s.sound.pan = ( s.x - pos.x ) / s.radius;
				
				if( !s.sound.isPlaying || s.sound.isPaused )
					s.sound.play( );

			}

		}

	// -------o protected
	
		

	// -------o misc
	
}

typedef SpatialSound={>FPoint,
	public var sound   : BoxSound;
	public var radius  : Float;
	public var sCode   : String;
}