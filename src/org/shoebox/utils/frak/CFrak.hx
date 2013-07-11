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
package org.shoebox.utils.frak;

	import flash.events.KeyboardEvent;
	import flash.Lib;
	import flash.ui.Keyboard;
	import org.shoebox.patterns.mvc.abstracts.AController;
	import org.shoebox.patterns.mvc.interfaces.IController;
	import org.shoebox.utils.frak.MFrak;
	import org.shoebox.utils.frak.VFrak;

	/**
	* 
	* @author shoebox
	*/
	class CFrak extends AController  implements IController {
		
		@model
		public var model : MFrak;

		@view
		public var view : VFrak;

		private var _bOpened 		: Bool;

		// -------o constructor
		
			/**
			* Constructor of the class
			*
			* @public
			* @return	void
			*/
			public function new() : Void {
				super( );			
			}

		// -------o public
			
			/**
			* Controller initialization
			* 
			* @public
			* @return void
			*/
			override public function initialize() : Void {
				Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN , _onKeyUp , false );
			}
		
			/**
			* When the controller is canceled
			* 
			* @public
			* @param	e : optional cance event (Event) 
			* @return	void
			*/
			override public function cancel( ) : Void {
				Lib.current.stage.removeEventListener( KeyboardEvent.KEY_DOWN , _onKeyUp , false );
				if( view != null )
					if( cast( view , VFrak ).tfInput != null )
						cast( view , VFrak ).tfInput.removeEventListener( KeyboardEvent.KEY_DOWN , _onValidate , false );
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			override public function startUp( ) : Void {
				cast( view , VFrak ).tfInput.addEventListener( KeyboardEvent.KEY_DOWN , _onValidate , false );
			}
		
		// -------o protected
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onKeyUp( e : KeyboardEvent ) : Void{
				
				#if flash
				if( e.keyCode == Keyboard.F9 ){
					
					_bOpened = !_bOpened;
					if( _bOpened )
						cast( view , VFrak ).open( );
					else
						cast( view , VFrak ).close( );
				}
				#end

			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onValidate( e : KeyboardEvent ) : Void{

				if( e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER ){
					cast( model , MFrak ).send( );
					cast( view , VFrak ).tfInput.text = '';
				}

				
			}

		// -------o misc

	}