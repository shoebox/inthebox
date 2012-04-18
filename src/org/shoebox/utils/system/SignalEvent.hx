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

import nme.display.DisplayObject;
import nme.events.Event;
import nme.events.EventDispatcher;
import org.shoebox.utils.system.Signal1;

/**
 * ...
 * @author shoe[box]
 */

class SignalEvent<T:Event> extends Signal1<T>{

	public var target( default , _setTarget ) : EventDispatcher;
	public var eventType( default , _setEvent ) : String;

	private var _bBubbling: Bool;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( target : EventDispatcher , sType : String , bBubbling : Bool = false ) {
			_bBubbling = bBubbling;
			_setTarget( target );
			_setEvent( sType );
			super( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function connect( f : T->Void , prio : Int = 0 , count : Int = -1 ) : Void {
			super.connect( f , prio , count );		
			if( !enabled )
				_setEnabled( true );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function disconnect( f : T->Void , prio : Int = 0 ) : Void {
			super.disconnect( f , prio );
			if( _oQueue.length == 0 )
				_setEnabled( false );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function dispose( ) : Void {
			enabled = false;
			super.dispose( );		
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setTarget( target : EventDispatcher ) : EventDispatcher{
		
			_removeListener( );

			this.target = target;

			if( enabled )
				_addListener( );

			return target;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		override private function _setEnabled( b : Bool ) : Bool{
			
			if( b )
				_addListener( );
			else
				_removeListener( );

			return super._setEnabled( b );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setEvent( s : String ) : String{
			
			if( enabled )
				_removeListener( );
				
			this.eventType = s;

			if( enabled )
				_addListener( );

			return s;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _addListener( ) : Void{
			if( eventType != null && target != null )
				target.addEventListener( eventType , _onEvent , _bBubbling );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _removeListener( ) : Void{
			if( eventType != null && target != null )
				target.removeEventListener( eventType , _onEvent , _bBubbling );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onEvent( e : T ) : Void{
			emit( e );
		}

	// -------o misc
	
}