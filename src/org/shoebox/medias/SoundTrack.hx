package org.shoebox.medias;

import nme.media.Sound;
import nme.media.SoundTransform;
import org.shoebox.medias.BoxSound;

/**
 * ...
 * @author shoe[box]
 */

class SoundTrack{

	public var transform( default , default ) : SoundTransform;
	public var volume( default , _set_volume )     : Float;
	
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
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function create( media : Sound ) : BoxSound {
			trace('create ::: '+media );	

			var snd : BoxSound = new BoxSound( media );
				snd.track = this;

			return snd;
		}

	// -------o protected

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_volume( v : Float ) : Float{
			return transform.volume = volume = v;
		}

	// -------o misc
	
}