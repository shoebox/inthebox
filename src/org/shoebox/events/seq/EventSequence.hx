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
package org.shoebox.events.seq;

	import nme.events.EventDispatcher;
	import nme.events.Event;
	import nme.events.TimerEvent;
	import nme.events.TouchEvent;
	
	/**
	* org.shoebox.events.seq.EventSequence
	* @author shoebox
	*/
	class EventSequence extends EventDispatcher{
		
		private var _aSequence			: Array<ISeq>;
		private var _oEvent				: SeqEvent;
		private var _oDelayer			: SeqDelayer;
		private var _iTouchId			: Int;
		private var _iInc				: Int;
		private var _iLen				: Int;
		
		// -------o constructor
		
			/**
			* Constructor of the EventSequence class
			*
			* @public
			* @return	void
			*/
			public function new( a : Array<ISeq> ) : Void {
				super( );
				_aSequence 	= a;
				_iLen		= a.length;
				reset( );
			}

		// -------o public
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function reset( ) : Void{
				_iTouchId = -1;
				_iInc = -1;
				
				for( item in _aSequence ){
					
					if( Std.is( item , SeqEvent )){
						cast( item , SeqEvent).removeEventListener( SeqEvent.DONE , _onEvent , false );
					}
					
				}
				
				if( _oDelayer != null )
					_oDelayer.removeEventListener( TimerEvent.TIMER , _onDelayerTick , false );
					
				_next( );
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function cancel( ) : Void{
				
				if( _oEvent != null )
					_oEvent.removeEventListener( cast( _oEvent , SeqEvent).sType , _onEvent , false );
				
				if( _oDelayer != null )
					_oDelayer.removeEventListener( TimerEvent.TIMER , _onDelayerTick , false );
					
				_oEvent = null;
				
				for( o in _aSequence ){
					o.cancel( );
				}
			}
			
		// -------o protected
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _next( eFrom : Event = null ) : Void{
				
				_iInc++;
				//
					if( _iInc >= _iLen ){
						
						var e : EventSequenceEvent = new EventSequenceEvent( EventSequenceEvent.DONE , eFrom );
						dispatchEvent( e );
						reset( );
						return;
					}
					
				//
					var next : ISeq = _aSequence[ _iInc ];
					
				//
					if( Std.is( next , SeqEvent )){
						next.addEventListener( SeqEvent.DONE , _onEvent , false );
						next = _oEvent = cast( next , SeqEvent );
						next.start( );
					}
					
				//
					if( Std.is( next , SeqDelayer ) ){
						
						_oDelayer = cast( next , SeqDelayer );
						_oDelayer.addEventListener( TimerEvent.TIMER , _onDelayerTick , false );
						_oDelayer.reset( );
						_oDelayer.start( );
						_next( );
					}
			
					
			}
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onEvent( customEvent : CustomEvent = null ) : Void{
				var e : Event = cast( customEvent.oDatas , Event ); 
				
				if( e != null ){
					if( Std.is( e , TouchEvent )){
						
						var eTouch : TouchEvent = cast( e , TouchEvent );
						trace( _iTouchId+' vs '+eTouch.touchPointID);
						
						if( _iTouchId != -1 && eTouch.touchPointID != _iTouchId ) 
							return;
						
						if( eTouch.type == TouchEvent.TOUCH_END )	
							_iTouchId = -1;
						
						if( eTouch.type == TouchEvent.TOUCH_BEGIN )	
							_iTouchId = eTouch.touchPointID;
						
					}
				}
				
				if( _oEvent != null )
					_oEvent.removeEventListener( cast( _oEvent , SeqEvent).sType , _onEvent , false );
				
				_next( e );
			}
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onDelayerTick( e : TimerEvent ) : Void{
				reset( );
			}
			
		// -------o misc

	}
	
	

