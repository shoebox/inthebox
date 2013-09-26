package org.shoebox.medias;

import flash.events.Event;
import flash.errors.Error;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
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

	public var isPaused		( get_isPaused 	, null )   			: Bool;
	public var isPlaying	( default 		, set_isPlaying ) 	: Bool;
	public var volume		( default 		, set_volume )    	: Float;
	public var pan			( default 		, set_pan )      	: Float;
	public var media		( default 		, set_media )    	: Sound;
	public var track		( default 		, set_track )    	: SoundTrack;

	private var _bPaused    : Bool;
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
			media			= m;
			_oTransform		= new SoundTransform( );
			onSoundComplete	= new Signal( );
			volume = 1.0;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getPosition( ) : Float {
			return _oChannel.position;
		}

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
			trace("play ::: "+startTime);
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
		private function set_isPlaying( b : Bool ) : Bool{

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
		private function set_media( m : Sound ) : Sound{

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
		private function set_track( t : SoundTrack ) : SoundTrack{

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
			//set_volume( volume );
			//trace('_on_track_update ::: track.volume'+track.volume+' - volume : '+volume);
			//volume = track.volume * volume;
			_invalidate( );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_volume( f : Float ) : Float{
			if( this.volume != f ){
				this.volume = f;
				_on_track_update( );
				_invalidate( );
			}
			return f;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_pan( f : Float ) : Float{

			if( this.pan != f ){
				this.pan = f;
				_invalidate( );
			}

			return f;

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function get_isPaused( ) : Bool{
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
			if( track == null )
				_oTransform.volume = volume;
			else
				_oTransform.volume = volume * track.volume;
				_oTransform.pan    = pan;

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
			onSoundComplete.emit( );
		}

	// -------o misc

}