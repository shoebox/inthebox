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
import org.shoebox.collections.PriorityQueue;

/**
 * ...
 * @author shoe[box]
 */

class ASignal<T>{

	private var _oQueue : PriorityQueue<SignalListener<T>>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			_oQueue = new PriorityQueue<SignalListener<T>>( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function connect( f : T , prio : Int = 0 , count : Int = -1 ) : Void {

			//TODO : Multi add check
			var s = { listener : f , count : count  };
			_oQueue.add( s , prio );

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function disconnect( f : T ) : Void {
			
			var content = _oQueue.getContent( );
			for( o in content ){

				if( o.content.listener != f )
					continue;

				content.remove( o );
			}

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			_oQueue = null;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _check( l : SignalListener<T> ) : Void{

			if( l.count != -1 )
				l.count--;

			if( l.count == 0 )
				_oQueue.remove( l );
		}	

	// -------o misc
	
}

typedef SignalListener<T> = {
	public var listener : T;
	public var count    : Int;
}