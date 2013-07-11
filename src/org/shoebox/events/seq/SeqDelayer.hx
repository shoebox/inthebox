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

	import flash.utils.Timer;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	/**
	* fr.hyperfiction.events.seq.SeqDelayer
	* @author shoebox
	*/
	class SeqDelayer extends Timer ,  implements ISeq{
		
		private var _iDelay				: Int;
		
		// -------o constructor
		
			/**
			* Constructor of the Delayer class
			*
			* @public
			* @return	void
			*/
			public function new( delay : Int ) : Void {
				super( delay , 1 );
			}

		// -------o public
			
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			override public function start( ) : Void{
				reset( );
				super.start( );
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function cancel( ) : Void{
				super.stop( );
			}
			
		// -------o protected


			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onEvent( e : Event ) : Void{
				trace('onEvent');
				dispatchEvent( e );
			}

		// -------o misc

	}
