package org.shoebox.medias;

import nme.events.Event;
import nme.errors.Error;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import org.shoebox.core.interfaces.IDispose;
import org.shoebox.geom.FPoint;
import org.shoebox.medias.SoundTrack;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class BoxSound implements IDispose{

	public var onSoundComplete : Signal;

	public var isPaused( _get_is_paused , null )   			: Bool;
	public var isPlaying( default 		, _set_isPlaying ) 	: Bool;
	public var volume( _get_volume 		, _set_volume )    	: Float;
	public var pan( _get_pan 			, _set_pan )      	: Float;
	public var media( default 			, _set_media )    	: Sound;	
	public var track( default 			, _set_track )    	: SoundTrack;

	private var _bPaused    : Bool;
	private var _fVol       : Float;
	private var _fPan       : Float;
	private var _fPos       : Float;
	private var _oChannel   : SoundChannel;
	private var _oTransform : SoundTransform;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( m : Sound ) {
			media	= m;
			_fVol	= 1;
			_fPan	= 0;
			_oTransform = new SoundTransform( );
			onSoundComplete = new Signal( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function play( ?startTime : Float = 0 , ?iLoops : Int = -1 ) : Bool {

			if( media == null )
				throw new Error( 'Media is not defined' );
			
			if( isPlaying && !_bPaused )
				return false;

			if( _bPaused ){
				//startTime = _fPos;
				_bPaused = false;
			}
			
			_oChannel = media.play( startTime , iLoops , _oTransform );
			if( _oChannel != null )
				_oChannel.addEventListener( Event.SOUND_COMPLETE , _onSound_Complete , false );
			return isPlaying = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function stop( ) : Bool {
			
			if( !isPlaying )
				return false;
			
			_oChannel.removeEventListener( Event.SOUND_COMPLETE , _onSound_Complete , false );
			_oChannel.stop( );
			isPlaying = false;

			return true;

		}	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function pause( ) : Bool {		

			if( _bPaused )
				return false;

			if( isPlaying ){
				_fPos     = _oChannel.position;
				_bPaused  = true;
				_oChannel.stop( );
				return true;
			}
			
			return false;		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			trace('dispose');
			if( isPlaying )
				stop( );

			track.update.disconnect( _on_track_update );

			if( _oChannel != null )
				_oChannel.addEventListener( Event.SOUND_COMPLETE , _onSound_Complete , false );

			media       = null;			
			_oChannel   = null;
			_oTransform = null;
			

		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_isPlaying( b : Bool ) : Bool{

			if( isPlaying == b )
				return isPlaying;

			return isPlaying = b;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_media( m : Sound ) : Sound{
			
			if( isPlaying ) 
				stop( );

			return media = m;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_track( t : SoundTrack ) : SoundTrack{

			if( track != null )
				track.update.disconnect( _on_track_update );

			if( t != null )
				_oTransform.volume = t.volume;
				t.update.connect( _on_track_update );
			
			return track = t;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _on_track_update( ) : Void{
			volume = track.volume;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_volume( f : Float ) : Float{
			if( _fVol != f ){
				_fVol = f;
				_invalidate( );
			}
			return _fVol = f;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get_volume( ) : Float{
			return _fVol;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_pan( f : Float ) : Float{

			if( _fPan != f ){
				_fPan = f;
				_invalidate( );
				return f;
			}
			
			return f;

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get_pan( ) : Float{
			return _fPan;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get_is_paused( ) : Bool{
			return _bPaused;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _invalidate( ) : Void{
			#if !flash
			_oTransform = _oTransform.clone( );
			#end
			_oTransform.volume = _fVol;
			//_oTransform.pan    = _fPan;
			
			if( _oChannel != null )
				_oChannel.soundTransform = _oTransform;

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSound_Complete( _ ) : Void{
			trace('_onSound_Complete');
			onSoundComplete.emit( );
		}

	// -------o misc
	
}