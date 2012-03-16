package org.shoebox.medias;

import nme.errors.Error;
import org.shoebox.medias.SoundTrack;

/**
 * ...
 * @author shoe[box]
 */

class SoundTracks{

	private var _hGroup : Hash<SoundTrack>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new() {
			_hGroup = new Hash<SoundTrack>( );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function add( s : String , vol : Float = 1.0 ) : SoundTrack {
			
			return getInstance( )._add( s , vol );

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function get( s : String ) : SoundTrack {
			return getInstance( )._get( s );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function remove( s : String ) : Bool {
			return getInstance( )._remove( s );
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _add( s : String , vol : Float ) : SoundTrack{

			if( _hGroup.exists( s ) )
				throw new Error( 'The group '+s+' already exist');

			var t : SoundTrack = new SoundTrack( s );
				t.volume = vol;

			_hGroup.set( s , t );
			return t;

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get( s : String ) : SoundTrack{
			return _hGroup.get( s );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _remove( s : String ) : Bool{
			return _hGroup.remove( s );
		}

	// -------o misc
		
		static public function getInstance( ) : SoundTracks {
			if ( __instance == null )
				__instance = new SoundTracks( );
				
			return __instance;
		}
		
		private static var __instance : SoundTracks = null;
}