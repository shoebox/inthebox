/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.shoebox.utils;

import flash.events.TimerEvent;
import flash.Lib;
import flash.utils.Timer;

/**
 * ...
 * @author shoe[box]
 */

class FrameTimer{
	
	private var _fAfter  : Float;
	private var _fBefore : Float;
	private var _fPeriod : Float;
	private var _fSleep  : Float;
	private var _oTimer  : Timer;

	static private var _aFuncs : Array<Void->Void> = new Array<Void->Void>( );

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new() {
			_fBefore = 0;
			_fAfter  = 0;
			_fSleep  = 0;
			_fPeriod = 1000 / Lib.current.stage.frameRate;
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function add( f : Void -> Void ) : Void {
			_aFuncs.push( f );
			getInstance( ).start( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function remove( f : Void -> Void ) : Void {
			_aFuncs.remove( f );
			
			if( _aFuncs.length == 0 )
				getInstance( ).stop( );
		}	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function start( ) : Void {
			trace('start');
			if( _oTimer == null )
				_oTimer = new Timer( 1 );
				_oTimer.delay = Std.int( _fPeriod );
				_oTimer.addEventListener( TimerEvent.TIMER , _onTick , false );
				_oTimer.start( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function stop( ) : Void {
			if( _oTimer != null ){
				_oTimer.removeEventListener( TimerEvent.TIMER , _onTick , false );
				_oTimer.stop( );
			}
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTick( _ ) : Void{
			_fBefore = Lib.getTimer( );
			var fOver = _fBefore - _fAfter - _fSleep;

			for( f in _aFuncs )
				f( );

			_fAfter = Lib.getTimer( );

			var fDiff = _fAfter - _fBefore;
			_fSleep = _fPeriod - fDiff - fOver;

			var fExcess = 0.0;

			if( _fSleep <= 0.0 ){
				fExcess -= _fSleep;
				_fSleep = 2;
			}
			
			_oTimer.reset( );
			_oTimer.delay = _fSleep;
			_oTimer.start( );

			while( fExcess > _fPeriod ){
				for( f in _aFuncs )
					f( );
				fExcess -= _fPeriod;
			}
		}

	// -------o misc

		public static function getInstance( ) : FrameTimer{
			if( null == instance )
				instance = new FrameTimer( );

			return instance;
		}

		public static var instance( default , null ) : FrameTimer;
}