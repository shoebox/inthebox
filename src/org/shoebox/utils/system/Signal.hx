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

	import nme.events.EventDispatcher;
	import nme.events.IEventDispatcher;
	
	/**
	* org.shoebox.utils.system.Signal
	* @author shoebox
	*/
	class Signal extends EventDispatcher {
		
		private var _vEvents			: Array<SignalFromEvent>;
		private var _dChannels			: Hash<Array<SignalListener>>;
		
		private var v2 : Array<SignalListener> ;
		private var ve : Array<SignalFromEvent>;
		private var se : SignalFromEvent;
		
		// -------o constructor
		
			/**
			* Constructor of the Signal class
			*
			* @public
			* @param 	listeners	: Optional vector of listeners functions		( Array<Function> )
			* @return	void
			*/
			public function new( listeners : Array<Dynamic> = null ) : Void {
				super( );
				_dChannels	= new Hash<Array<SignalListener>>( );
				_vEvents 	= new Array<SignalFromEvent>( );
				
				if( listeners != null ){
					
					for( f in listeners ){
						connect( f );
					}
				}
			}

		// -------o public
			
			/**
			* Register a listener function to the Signal
			* 
			* @public
			* @param	f 	: Dynamic to be registered	( Function ) 
			* @param	prio 	: Listener priority			( Int )
			* @param	bOS 	: One shot usage				( Bool )
			* @return	void
			*/
			public function connect( f : Dynamic , c : Dynamic = null , prio : Int = 0 , bOS : Bool = false , from : Dynamic = null ) : Bool {
				
				if( isRegistered( f , c ) )
					return false;
					
				var vTmp : Array<SignalListener> = _dChannels.get( c );
				if( vTmp == null )
					vTmp = new Array<SignalListener>( );
					vTmp.push( new SignalListener( f , c , prio , bOS , from ) );
					//vTmp.sort( _sortFunc );
				
				_dChannels.set( c , vTmp );
				
				return true;
			}
			
			/**
			* connectEvent function
			* @public
			* @param 
			* @return
			*/
			public function connectEvent( 
										target : IEventDispatcher , 
										sType : String , 
										channel : Dynamic = null , 
										bubble : Bool = false , 
										cType : Dynamic = null , 
										args : Array<Dynamic> = null 
									) : SignalFromEvent {
				
				//if( target == null )
				//	throw new Error( new ArgumentError( 'The IEventDispatcher target is null' ) , this );						
										
				var s : SignalFromEvent = new SignalFromEvent( target , bubble, sType , (channel == null) ? sType : channel , this , cType , args );
				_vEvents.push( s );	
				return s;
				
			}
			
			/**
			* cancelAllEvents function
			* @public
			* @param 
			* @return
			*/
			public function cancelAllEvents() : Void {
				
				for( e in _vEvents ){
					e.cancel( );
					e = null;
				}
				_vEvents = null;
				
			}
			
			/**
			* hasListener function
			* @public
			* @param 
			* @return
			*/
			public function hasListener( c : Dynamic = null ) : Bool {
				
				var vTmp : Array<SignalListener> = _dChannels.get( c );
				if( vTmp == null )
					return false;
					
				return ( vTmp.length > 0 );
			
			}
			
			/**
			* disconnectEvent function
			* @public
			* @param 
			* @return
			*/
			public function disconnectEvent( target : IEventDispatcher , sType : String , channel : Dynamic = null , b : Bool = false ) : Void {

				if( channel == null )
					channel = sType;
				
				ve = _vEvents.splice( 0 , _vEvents.length );
				
				for( se in ve ){
					
					if( se.oFrom == target && se.sType == sType && se.channel == channel && se.bBubbling == b ){
						se.cancel( );
						continue;
					}
					
					_vEvents.push( se );
				}
				ve = null;
			}
			
			/**
			* unRegister function
			* @public
			* @param 
			* @return
			*/
			public function disconnect( f : Dynamic , c : Dynamic ) : Bool {
				
				if( !hasChannel( c ) )
					return false;
					
				var vTmp : Array<SignalListener> = _dChannels.get( c );
				var i : Int = 0;
				var l : Int = vTmp.length;
				
				if( l == 0 )
					return false;
				
				var s : SignalListener = null;
				for( i in 0...l ){
					
					s = vTmp[ i ];
					if( s.fRef == f && s.channel == c ){
						break;						
					}
					
					s = null;
				}
				
				trace('s ::: '+s);
				
				
				if( s == null )
					return false;
					
				vTmp.remove( s );
				_dChannels.set( c , vTmp );
				
				return true;
			}
			
			/**
			* disconnectChannel function
			* @public
			* @param 
			* @return
			*/
			public function disconnectChannel( c : Dynamic ) : Void {
				_dChannels.remove( c );
			}
			
			/**
			* hasChannel function
			* @public
			* @param 
			* @return
			*/
			public function hasChannel( c : Dynamic ) : Bool {
				return _dChannels.exists( c );
			}
			
			/**
			* isRegistered function
			* @public
			* @param 
			* @return
			*/
			public function isRegistered( f : Dynamic , c : Dynamic ) : Bool {
				
				if( !hasChannel( c ) )
					return false;
				
				var vTmp : Array<SignalListener> = _dChannels.get( c );
				
				for( sl in vTmp ){
					if( sl.fRef == f )
						return true;
					
				}
				
				return false;
				
			}
			
			/**
			* emit function
			* @public
			* @param 
			* @return
			*/
			public function emit( c : Dynamic = null , values : Array<Dynamic> = null ) : Bool {
				
				//
					if( !hasChannel( c ) )
						return false;
				
				//
					var vTmp : Array<SignalListener> = _dChannels.get( c );
					var l : Int = vTmp.length;
					if( l == 0 )
						return false;
				
				//
					var vRem : Array<SignalListener> = new Array<SignalListener>( );
					
					for( sl in vTmp ){
							
						sl.fRef.apply( sl.from , values ) ;
						if( sl.bOs )
							vRem.push( sl );
						
					}
			
				//
					for( sl in vRem ){
						vTmp.remove( sl );
					}
				
				//
					_dChannels.set( c , vTmp );
					return true;
			}
			
		// -------o private
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			private function _sortFunc( s1 : SignalListener , s2 : SignalListener ) : Int {
				if( s1.uPrio < s2.uPrio )
					return -1;
				else if( s1.uPrio == s2.uPrio )
					return 0;
				else if( s1.uPrio > s2.uPrio )
					return 1;
					
				return 0;
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			private function _filterFunc( s : SignalListener , i : Int , v : Array<SignalListener> ) : Bool {
				
				if( s.channel == s )
					return false;
						
				return true;
				
			}
			
		// -------o misc

	}


	/**
	* org.shoebox.utils.system.SignalListener
	* @author shoebox
	*/
	class SignalListener {
		
		public var from			: Dynamic;
		public var channel		: Dynamic;
		public var bOs			: Bool;
		public var fRef			: Dynamic;
		public var uPrio		: Int;
		
		// -------o constructor
		
			/**
			* Constructor of the Signal class
			* 
			* @internal
			* @param	f 	: Dynamic to be registered	( Function ) 
			* @param	prio 	: Listener priority			( Int )
			* @param	bOs 	: One shot usage				( Bool )
			* @return	void
			*/
			public function new( f : Dynamic , c : Dynamic , prio : Int , b : Bool , from : Dynamic = null ) : Void {
				this.bOs = b;
				this.fRef = f;
				this.uPrio = prio;
				this.channel = c;
				this.from = from;
			}
			
		// -------o public
		
		// -------o private

		// -------o misc

	}
