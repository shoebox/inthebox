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

	import org.shoebox.events.seq.ISeq;
	import org.shoebox.events.seq.SeqEvent;
	import org.shoebox.events.seq.SeqDelayer;
	import org.shoebox.events.CustomEvent;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.commands.ICommand;
	import org.shoebox.utils.system.Signal;
	
	/**
	* org.shoebox.events.seq.EventSequence
	* @author shoebox
	*/
	class EventSequence extends AbstractCommand , implements ICommand{
		
		public var monoTouchId : Bool;

		private var _aContent : Array<ISeq>;
		private var _oCurrent : ISeq;
		private var _oDelayer : ISeq;
		private var _iPos     : Int;
		private var _iLen     : Int;
		private var _iTouchId : Int;

		// -------o constructor
		
			/**
			* Constructor of the EventSequence class
			*
			* @public
			* @return	void
			*/
			public function new( ) : Void {
				super( );
				_iTouchId = -1;
			}

		// -------o public
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function add<T>( c : SequenceItem ) : Void {
				
				if( _aContent == null )
					_aContent = new Array<ISeq>( );

				var item : ISeq;
				switch( c ){
					
					case SeqEv( target , s , b , iPrio ):
						item = new SeqEvent( target , s  , b  , iPrio );
					
					case SeqDel( delay ):
						item = new SeqDelayer( delay );

				}

				_aContent.push( item );
				_iLen = _aContent.length;
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			override public function onExecute( ?e : Event = null ) : Void {
				_iPos = 0;
				_next( );
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			override public function onCancel( ?e : Event = null ) : Void {

				if( _aContent != null ){

					for( o in _aContent ){
						o.cancel( );
					}

				}

				_aContent = [ ];

				trace('cancel ::: '+_aContent );

				_cancelCurrent( );
				_cancelDelayer( );
			}
			

		// -------o protected
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _next( e : Event = null ) : Void{
				
				if( _iPos >= _iLen ){
					dispatchEvent( new EventSequenceEvent( EventSequenceEvent.DONE , e ) );
					_reset( );
				}

				_cancelCurrent( );

				var next : ISeq = _aContent[ _iPos ++ ];
				
				if( Std.is( next , SeqDelayer ) ){
					
					next.addEventListener( TimerEvent.TIMER , _onDelayerTick , false  );
					next.start( );
					_next( );

				}else if( Std.is( next , SeqEvent ) ){

					next.addEventListener( SeqEvent.DONE , _onEvent , false );
					next.start( );

					_oCurrent = next;
				}

			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onEvent( e : CustomEvent = null ) : Void{
				var e : Event = cast( e.oDatas , Event ); 
				
				_cancelDelayer( );
				_cancelCurrent( );

				if( monoTouchId && Std.is( e , TouchEvent ) ){
					var id : Int = cast( e , TouchEvent ).touchPointID;
					
					if( _iTouchId == -1 ){

						_iTouchId = id;
						_next( );

					}else if( id != _iTouchId ){
						_reset( );
					}else
						_next( e );
						
				}else
					_next( e );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onDelayerTick( _ ) : Void{
				_cancelCurrent( );
				_reset( );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _reset( ) : Void{
				_iTouchId = -1;
				_iPos     = 0;
				_next( );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _cancelCurrent( ) : Void{
				if( _oCurrent == null )
					return;
				
				_oCurrent.cancel( );
				if( _oCurrent.hasEventListener( SeqEvent.DONE ) )
					_oCurrent.removeEventListener( SeqEvent.DONE , _onEvent , false );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _cancelDelayer( ) : Void{
				if( _oDelayer != null ){
					_oDelayer.cancel( );
					_oDelayer.removeEventListener( TimerEvent.TIMER , _onDelayerTick , false );
				}
					
			}

		// -------o misc

	}
	
	enum SequenceItem{
		SeqEv( target : EventDispatcher , s : String , b : Bool , iPrio : Int );
		SeqDel( delay : Int );
	}
	

