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
package org.shoebox.ui;

import flash.errors.Error;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;

/**
 * ...
 * @author shoe[box]
 */

class Keys extends AbstractCommand  implements ICommand{

	private var _hKeys : Map<String,Bool>;

	private static var __instance : Keys = null;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param  
		* @return  void
		*/
		public function new( e : SingletonEnforcer = null ) {
			
			if( e == null )
				throw new Error('');
				super( );
				_hKeys = new Map<String,Bool>( );
			
		}
	
	// -------o public
				
			/**
			* 
			* 
			* @public
			* @return  void
			*/
			static public function isDown( id : Float ) : Bool {
				return getInstance( )._hKeys.exists( Std.string( id ) );
			}

			/**
			* 
			* 
			* @public
			* @return  void
			*/
			override public function onExecute( ) : Void{
				Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN , _onKeyDown , false );
				Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP , _onKeyUp , false );
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			override public function onCancel( ) : Void {
				Lib.current.stage.removeEventListener( KeyboardEvent.KEY_DOWN , _onKeyDown , false );
				Lib.current.stage.removeEventListener( KeyboardEvent.KEY_UP , _onKeyUp , false );	
			}


	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return  void
		*/
		private function _onKeyDown( e : KeyboardEvent ) : Void{
			_hKeys.set( Std.string( e.keyCode ) , true );
		}
		
		/**
		* 
		* 
		* @private
		* @return  void
		*/
		private function _onKeyUp( e : KeyboardEvent ) : Void{
			_hKeys.remove( Std.string( e.keyCode ) );
		}  

	// -------o misc
		
		/**
		* 
		* 
		* @public
		* @return  void
		*/
		static public function getInstance( ) : Keys {
						
			if( __instance == null )
				 __instance = new Keys( new SingletonEnforcer( ) );
					
			return __instance;
					
		}

}

class SingletonEnforcer{
	public function new(  ) { }

}