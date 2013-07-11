package org.shoebox.medias;

import motion.Actuate;
import motion.easing.Linear;

import flash.media.Sound;
import flash.media.SoundTransform;

import org.shoebox.medias.BoxSound;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class SoundTrack{

	@:isVar
	public var transform	( get_transform , set_transform ) : SoundTransform;

	@:isVar
	public var volume		( get_volume , set_volume )     : Float;

	@:isVar
	public var mute			( default , set_mute ) : Bool;

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
		private function get_transform( ) : SoundTransform{
			if( mute )
				get_transform( ).volume = 0.0;

			return this.transform;

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_transform( t : SoundTransform ) : SoundTransform{
			return this.transform = t;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_mute( b : Bool ) : Bool{
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
		private function set_volume( v : Float ) : Float{
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
		private function get_volume( ) : Float{
			if( mute )
				return 0.0;

			return this.volume;
		}

	// -------o misc

}