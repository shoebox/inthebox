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

package org.shoebox.utils.frak;

	import nme.display.Sprite;
	import nme.events.Event;
	import nme.Lib;
	import nme.text.TextField;
	import nme.text.TextFieldAutoSize;
	import nme.text.TextFieldType;
	import org.shoebox.core.BoxTextField;
	import org.shoebox.patterns.mvc.abstracts.AView;
	import org.shoebox.patterns.mvc.interfaces.IView;
	
	/**
	*
	* @author shoebox
	*/
	class VFrak extends AView , implements IView {
		
		public var fHeight       : Float;
		public var tfInput       : TextField;
		public var tfOutput      : TextField;
		
		private var _spContainer : Sprite;
		private var _spBack      : Sprite;

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
			* View initialization
			*
			* @public
			* @return	void
			*/
			override public function initialize() : Void {
				
				//
					_spContainer = new Sprite( );
					addChild( _spContainer );

				//
					fHeight       = Lib.current.stage.stageHeight / 4;
					close( );
					_onStaged( );				
			}
			
			/**
			* When the view is canceled
			* 
			* @public
			* @param	e : optional cancel event (Event) 
			* @return	void
			*/
			override public function cancel( ) : Void {
									
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function open( ) : Void {
				_spContainer.y = 0;

				trace('open');
				Lib.current.stage.focus = tfInput;
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function close( ) : Void {
				_spContainer.y = -fHeight;	

			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function updateBuffer( s : String ) : Void {
				tfOutput.htmlText = s;
			}
			
		// -------o protected
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onStaged( e : Event = null ) : Void{
				
				//
					removeEventListener( Event.ADDED_TO_STAGE , _onStaged , false );
					addEventListener( Event.REMOVED_FROM_STAGE , _onRemoved , false );

				//
					_gfx( );
					_input( );
					_output( );
					_onResize( );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onRemoved( e : Event ) : Void{
				trace('onRemoved');
				
				//
					removeEventListener( Event.REMOVED , _onRemoved , false );
					addEventListener( Event.ADDED_TO_STAGE , _onStaged , false );

				
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _gfx( ) : Void{
			
				_spContainer.graphics.clear( );
				_spContainer.graphics.beginFill( 0x282828 );
				_spContainer.graphics.drawRect( 0 , 0 , Lib.current.stage.stageWidth , fHeight );
				_spContainer.graphics.endFill( );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _input( ) : Void{
				
				tfInput                 = new TextField( );
				tfInput.x               = 10;
				tfInput.type            = TextFieldType.INPUT;
				tfInput.background      = true;
				tfInput.backgroundColor = 0x08A6F3;
				tfInput.height          = 20;

				BoxTextField.format( tfInput , TextFieldAutoSize.NONE , true , false , false );
				BoxTextField.setFormat( tfInput , false , 'Verdana' , 11 , 0xFFFFFF );
				_spContainer.addChild( tfInput );

			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _output( ) : Void{
				tfOutput              = new TextField( );
				tfOutput.x            = 10;
				tfOutput.selectable   = false;
				tfOutput.mouseEnabled = false;
				tfOutput.height       = fHeight - 40;
				tfOutput.y            = 5;
				tfOutput.type         = TextFieldType.DYNAMIC;
				BoxTextField.format( tfOutput , TextFieldAutoSize.NONE , true , true , true );
				BoxTextField.setFormat( tfOutput , false , 'Verdana' , 11 , 0xFFFFFF );
				
				_spContainer.addChild( tfOutput );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onResize( e : Event = null ) : Void{
				tfInput.y      = fHeight - 30;
				tfOutput.x     = 10;
				tfOutput.width = tfInput.width = Lib.current.stage.stageWidth - 20;
			}

		// -------o misc

	}