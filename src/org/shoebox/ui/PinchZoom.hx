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
package org.shoebox.ui;

import nme.display.Graphics;
import nme.display.InteractiveObject;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;

import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.utils.system.Signal1;

using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */

class PinchZoom extends AbstractCommand , implements ICommand{

	public var active( _getActive , never ) : Bool;
	public var onZoom : Signal1<Float>;

	private var _fPrevDist : Float;
	private var _gDebug    : Graphics;
	private var _oTarget   : InteractiveObject;
	private var _touch1    : TouchPoint;
	private var _touch2    : TouchPoint;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( tgt : InteractiveObject , gDebug : Graphics = null) {
			trace('constructor');
			super( );
			_gDebug = gDebug;
			_oTarget = tgt;
			onZoom = new Signal1<Float>( );
			_fPrevDist = -1;
		}
	
	// -------o public
			

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ?e : Event = null ) : Void {
			
			#if mobile
				
				if( !Multitouch.supportsTouchEvents ){
					trace('TouchEvents are not supported on this device');
					return;
				}

				if( Multitouch.inputMode != MultitouchInputMode.TOUCH_POINT )
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

				_run( );

			#else
				trace('Pinch is mobile mode only');
			#end

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ?e : Event = null ) : Void {
		}

	// -------o protected
		#if mobile
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _run( ) : Void{
			_oTarget.touchBegin( ).connect( _onTouchBegin , 100 );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchBegin( e : TouchEvent ) : Void{
			
			if( _touch1 == null ){
				_touch1 = { x : e.stageX , y : e.stageY , touchPointID : e.touchPointID };
			}else if( _touch2 == null ){
				_touch2 = { x : e.stageX , y : e.stageY , touchPointID : e.touchPointID };
			}

			_oTarget.touchMove( ).connect( _onTouchMove , 100 );
			_oTarget.touchEnd( ).connect( _onTouchEnd , 100 );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchMove( e : TouchEvent ) : Void{
			
			if( _touch1 != null ){
				if( _touch1.touchPointID == e.touchPointID ){
					_touch1.x = e.stageX;
					_touch1.y = e.stageY;
				}
			}

			if( _touch2 != null ){
				if( _touch2.touchPointID == e.touchPointID ){
					_touch2.x = e.stageX;
					_touch2.y = e.stageY;
				}
			}

			_dist( );
			_draw( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _dist( ) : Void{

			if( _touch1 == null || _touch2 == null )
				return;

			var dis : Float = BoxMath.distance( _touch1.x , _touch1.y , _touch2.x , _touch2.y );
			if( _fPrevDist != -1 )
				onZoom.emit( ( dis / _fPrevDist ) - 1 );
			_fPrevDist = dis;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchEnd( e : TouchEvent ) : Void{
			
			if( _touch1 != null )
				if( e.touchPointID == _touch1.touchPointID )
					_touch1 = null;

			if( _touch2 != null )
				if( e.touchPointID == _touch2.touchPointID )
					_touch2 = null;

			if( _touch1 == null && _touch2 == null ){
				_oTarget.touchMove( ).disconnect( _onTouchMove );
				_oTarget.touchEnd( ).disconnect( _onTouchEnd );
				_fPrevDist = -1;
				_clear( );
			}
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _draw(  ) : Void{

			if( _gDebug == null )
				return;

			_clear( );
			if( _touch1 != null )
				_gDebug.drawCircle( _touch1.x , _touch1.y , 40 );
			
			if( _touch2 != null )
				_gDebug.drawCircle( _touch2.x , _touch2.y , 40 );

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _clear( ) : Void{
			if( _gDebug == null )
				return;
			_gDebug.clear( );
			_gDebug.lineStyle( 1 , 0x999999 );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getActive( ) : Bool{
			return ( _touch1 != null && _touch2 != null );
		}

		#else

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getActive( ) : Bool{
			return false;
		}

		#end
		

	// -------o misc
	
}

typedef TouchPoint={
	> FPoint,
	var touchPointID : Int;
}