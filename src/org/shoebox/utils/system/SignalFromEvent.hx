/**
  HomeMade by shoe[box]
 
  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of shoe[box] nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.shoebox.utils.system;

	import nme.errors.IllegalOperationError;
	import nme.events.Event;
	import nme.events.IEventDispatcher;
	
	/**
	* org.shoebox.utils.system.SignalFromEvent
	* @author shoebox
	*/
	class SignalFromEvent {
		
		public var aArgs			: Array<Dynamic>;
		public var bBubbling		: Bool;
		public var bBroadcastEvent	: Bool;
		public var bCanceled		: Bool;
		public var cClass			: Dynamic;
		public var oFrom			: IEventDispatcher;
		public var sType			: String;
		public var channel		: Dynamic;
		public var signal		: Signal;
		public var uPrio			: Int;
		
		private var _bRunning		: Bool;
		private var _uCount		: Int;
		
		// -------o constructor
		
			/**
			* Constructor of the Signal class
			*
			* @public
			* @return	void
			*/
			public function new( from : IEventDispatcher , bb : Bool , type : String , c : Dynamic , s : Signal , cc : Dynamic = null , a : Array<Dynamic> = null  ) : Void {
				aArgs = a == null ? [ ] : a;
				bBubbling = bb;
				bBroadcastEvent = false;
				bCanceled = false;
				_bRunning = false;
				sType = type;
				oFrom = from;
				signal = s;
				channel = c;
				cClass = cc;
				uPrio = 1;
			}

		// -------o public
			
			/**
			* set prio function
			* @public
			* @param 
			* @return
			*/
			public function sePprio( u : Int ) : Void {
				
				uPrio = u;
				
				if( _bRunning )
					_run( );
								
			}
			
			/**
			* cancel function
			* @public
			* @param 
			* @return
			*/
			public function cancel() : Void {
				
				if( oFrom.hasEventListener( sType ))
					oFrom.removeEventListener( sType , _onExecute , bBubbling  );
					
				signal.disconnectChannel( channel );
				
				bCanceled = true;
			}
			
			/**
			* connect function
			* @public
			* @param 
			* @return
			*/
			public function add( f : Dynamic , b : Bool = false , u : Int = 10 ) : Bool {
				
				var b : Bool = signal.connect( f , channel , u , b );
				
				if( b ){
					_uCount ++;
					if( !_bRunning )
						_run( );
				}
				
				
				return b;
			}
			
			/**
			* disconnect function
			* @public
			* @param 
			* @return
			*/
			public function remove( f : Dynamic ) : Void {
				
				var b : Bool = signal.disconnect( f , channel );
				if( b ){
					_uCount --;
					if( _uCount == 0 && _bRunning )
						_stop( );
				}
			}
			
		// -------o private
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			private function _run() : Void {
				
				if( _bRunning )
					_stop( );
					
				_bRunning = true;
				oFrom.addEventListener( sType , _onExecute , bBubbling , uPrio  );
				
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			private function _stop() : Void {
				_bRunning = false;
				if( oFrom.hasEventListener( sType ) )
					oFrom.removeEventListener( sType , _onExecute , bBubbling );
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			private function _onExecute( e : Event ) : Void {
				
				if( !signal.hasListener( channel ) )
					return;
				
				if( cClass ){
					if( !Std.is(e.target , cClass) )
						return;
				}
				
				var aTmp : Array<Dynamic> = aArgs.copy( );
				if( bBroadcastEvent )
					aTmp.unshift( e );
				
				trace('onExecute ::: '+aTmp+' --- '+signal.emit );
				trace('bub ::: '+bBubbling);
				trace(' this ::: '+this.signal.emit);
				if ( bBubbling ) 
					aTmp.unshift( e.target );
				
				Reflect.callMethod( oFrom , signal.emit , [ channel , aTmp ] );
				
				//public function emit( c : Dynamic = null , values : Array<Dynamic> = null ) : Bool {
				
				if( !bBubbling )	
					e.stopPropagation( );
			}
			
		// -------o misc
			
			
	}

