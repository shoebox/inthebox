package org.shoebox.medias;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

import nme.media.Sound;
import nme.media.SoundTransform;

import org.shoebox.medias.BoxSound;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class SoundTrack{

	public var transform( default , default ) : SoundTransform;
	public var volume( default , _set_volume )     : Float;
	public var update : Signal;

	
	public var sName : String;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( sName : String ) {
			this.sName = sName;
			transform = new SoundTransform( );
			update = new Signal( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function create( media : Sound ) : BoxSound {
			var snd : BoxSound = new BoxSound( media );
				snd.track = this;

			return snd;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function tween_volume_to( f : Float , duration : Float = 0.5 , fComplete : Void->Void = null ) : Void {
			Actuate.tween( this , duration , { volume : f } ).onComplete( fComplete ).ease( Linear.easeNone );
		}

	// -------o protected

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_volume( v : Float ) : Float{
			transform.volume = volume = v;
			update.emit( );
			return v;
		}

	// -------o misc
	
}