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
package org.shoebox.utils.system;

import nme.events.EventDispatcher;

/**
 * ...
 * @author shoe[box]
 */

class Signal extends EventDispatcher{

	private var _hChannels : Hash<Array<SignalListener>>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			super( );
			_hChannels = new Hash<Array<SignalListener>>( );
		}
	
	// -------o public
				
		/**
		* Connect a Function to the specified channel
		* 
		* @public	
		* @param  f      : Listener 					( Dynamic -> Dynamic )
		* @param channel : Signal channel to listen for ( Dynamic )
		* @param iPrio   : Priority on the channel 		( Int )
		* @param bOs     : One shoot listener 			( Bool )
		* @return true if success ( Bool )
		*/
		public function connect( f : Dynamic -> Dynamic , channel : Dynamic , iPrio : Int = 0 , bOs : Bool = false ) : Bool {
			
			//
				if( isRegistered( f , channel ) )
					return false;	
			
			//
				var a : Array<SignalListener> = null;
				if( _hChannels.exists( channel ) )
					a = _hChannels.get( channel );

			//
				if( a == null )
					a = new Array<SignalListener>( );
					a.push( {
								fListener : f,
								channel   : channel ,
								bOs       : bOs,	
								iPrio     : iPrio
							});
			//
				if( iPrio != 0 && a.length > 1 ){
					a.sort( _sort );
				}	

			//
				_hChannels.set( channel , a );
					
			return true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function disconnect( f : Dynamic -> Dynamic , channel : Dynamic ) : Void {
			_disconnect( f , channel );
		}

		/**
		* Emit something on the specified channel
		* 
		* @public	
		* @param channel : Signal channel ( Dynamic )
		* @param args    : Additional args to broadcast ( Array<Dynamic> )
		* @return true if success ( Bool )
		*/
		public function emit( channel : Dynamic , args : Array<Dynamic> = null ) : Bool {
			//
				if( !hasChannel( channel ) )
					return false;
			
			//
				var aListeners = _hChannels.get( channel );
				var tbR : Array<SignalListener> = new Array<SignalListener>( );
				for( l in aListeners ){
					Reflect.callMethod( this , l.fListener , args );
					if( l.bOs )
						tbR.push( l );
				}

				for( l in tbR )
					disconnect( l.fListener , l.channel );
			
			return true;
		}

		/**
		* Testing if somothing if the Function is already registered on the channel
		* 
		* @public 
		* @param  fListener : Function to test ( Dynamic -> Void )
		* @param  channel : Broadcast channel ( Dynamic )
		* @return void
		*/
		public function isRegistered( fListener : Dynamic -> Void , channel : Dynamic ) : Bool {
			
			if( !hasChannel( channel ) )
				return false;

			var vTmp : Array<SignalListener> = _hChannels.get( channel );
			for( sl in vTmp )
				if( sl.fListener == fListener ) 
					return true;

			return false;
		}

		/**
		* Testing if the channel already has something registered
		* 
		* @public
		* @param channel : Tested channel ( Dynamic )
		* @return true if channel is registered ( Bool )
		*/
		public function hasChannel( channel : Dynamic ) : Bool {
			return _hChannels.exists( channel );
		}

		/**
		* Destroy all the listeners on all the channels
		* 
		* @public
		* @return	void
		*/
		public function destroy( ) : Void {
			_hChannels = null;
		}

	// -------o protected
	
		/**
		* Priority sorting function
		* 
		* @private	s1 : Listener 1 ( SignalListener )
		* @private	s2 : Listener 2 ( SignalListener )
		* @return	void
		*/
		private function _sort( s1 : SignalListener , s2 : SignalListener ) : Int{

			if( s1.iPrio == s2.iPrio )
				return 0;
			
			if( s1.iPrio > s2.iPrio )
				return 1;

			return 2;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _disconnect( f : Dynamic -> Dynamic , channel : Dynamic ) : Void{
			//
				var aListeners = _hChannels.get( channel );
				for( l in aListeners ){
					
					if( l.fListener == f && l.channel == channel )
						aListeners.remove( l );

				}

		}
		

	// -------o misc
	
}

private typedef SignalListener = {
	
	public var fListener : Dynamic -> Dynamic;
	public var channel   : Dynamic;
	public var bOs       : Bool;
	public var iPrio      : Int;

}