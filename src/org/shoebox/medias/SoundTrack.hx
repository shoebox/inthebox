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

	public var transform	( _get_transform , _set_transform ) : SoundTransform;
	public var volume		( _get_volume , _set_volume )     : Float;
	public var mute			( default , _set_mute ) : Bool;
	
	public var sName	: String;
	public var update	: Signal;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( sName : String ) {
			transform	= new SoundTransform( );
			update		= new Signal( );
			this.mute	= false;
			this.sName	= sName;
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
		private function _get_transform( ) : SoundTransform{
			if( mute )
				this.transform.volume = 0.0;

			return this.transform;

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_transform( t : SoundTransform ) : SoundTransform{
			return this.transform = t;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_mute( b : Bool ) : Bool{
			this.mute = b;
			update.emit( );
			return b;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_volume( v : Float ) : Float{
			trace('_set_volume ::: '+v);
			transform.volume = this.volume = v;
			update.emit( );
			return v;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get_volume( ) : Float{
			if( mute )
				return 0.0;

			return this.volume;
		}

	// -------o misc
	
}