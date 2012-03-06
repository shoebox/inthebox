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

import nme.events.TimerEvent;
import nme.Lib;
import nme.utils.Timer;

/**
 * ...
 * @author shoe[box]
 */

class FrameTimer {

	static private var _aFuncs : Array<Void->Void> = new Array<Void->Void>( );

	private var _fFrameDuration : Float;
	private var _fPrev : Float;
	private var _fPrevTimer : Float;
		private var _iDiffTime : Int;
	
	private static var _bRunning : Bool;
	private static var _oTimer   : Timer;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new( ) {
			_fFrameDuration = 1000 / Lib.current.stage.frameRate;
			_oTimer = new Timer( _fFrameDuration );
			_oTimer.addEventListener( TimerEvent.TIMER , _onTick , false );
			_bRunning = false;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function add( f : Void -> Void ) : Void {

			_aFuncs.remove( f );
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
		
		}	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function start( ) : Void {

			if( _bRunning )
				return;

			_oTimer.start( );
			_fPrev = Lib.getTimer( );
			_bRunning = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function stop( ) : Void {
			_oTimer.stop( );
			_bRunning = false;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTick( _ ) : Void{
			//var now = Lib.getTimer( );//haxe.Timer.stamp( );
			var now:Float = haxe.Timer.stamp();
			_iDiffTime = Math.round((now - _fPrevTimer) * Lib.current.stage.frameRate);
			
			for( i in 0..._iDiffTime ){
				for( f in _aFuncs ){
					f( );
				}
			}

			_fPrevTimer = now;
		}

		
		

	// -------o misc
		
		public static function getInstance( ) : FrameTimer{
			if( null == instance )
				instance = new FrameTimer( );

			return instance;
		}

		public static var instance( default , null ) : FrameTimer;
}