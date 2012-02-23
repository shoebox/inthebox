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
package org.shoebox.patterns.mvc.commands; 

import nme.display.DisplayObjectContainer;
import nme.events.Event;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.patterns.mvc.abstracts.AModel;
import org.shoebox.patterns.mvc.abstracts.AView;
import org.shoebox.patterns.mvc.abstracts.AController;


/**
 * ...
 * @author shoe[box]
 */

class MVCCommand extends AbstractCommand ,  implements ICommand{

	public var model     	( _getModel , null ) : AModel;
	public var view       	( _getView , null ) : AView;
	public var controller 	( _getController , null ) : AController;
	public var container  : DisplayObjectContainer;

	private var _oModel        : AModel;
	private var _oView         : AView;
	private var _oController   : AController;
	private var _cModel        : Class<AModel>;
	private var _cView         : Class<AView>;
	private var _cController   : Class<AController>;
	private var _oFrontControl : FrontController;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			super( );
		}
	
	// -------o public
			
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function init(
								? m : Class<AModel>,
								? v : Class<AView>,
								? c : Class<AController> , 
								? d : DisplayObjectContainer = null ,
								? fc : FrontController = null 
							 ) : Void {
			container      = d;	
			_cModel        = m;
			_cView         = v;
			_cController   = c;
			_oFrontControl = fc;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function prepare( ) : Void {
			
			// Model
				if( _cModel != null ){
					_oModel = Type.createInstance( _cModel , [ ] );
					_oModel.ref = this;
				}

			// View
				if( _cView != null ){
					_oView = Type.createInstance( _cView , [ ]);
					_oView.ref = this;
				}

			// Controller
				if( _cController != null ){
					_oController = Type.createInstance( _cController , [ ] );		
					_oController.ref = this;
				}
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ?e : Event = null ) : Void {

			//
				if(container != null && !container.contains(_oView))
					container.addChild(_oView);					

			// Init
				if( _oModel != null )
					_oModel.initialize( );
				
				if( _oView != null )
					_oView.initialize( );

				if( _oController != null )
					_oController.initialize( );
			
			// StartUp
				if( _oModel != null )
					_oModel.startUp( );
				
				if( _oView != null )
					_oView.startUp( );

				if( _oController != null )
					_oController.startUp( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ? e : Event = null ) : Void {
			
			//
				if( _oModel != null )
					_oModel.cancel( );
			
			//
				if( container != null )
					if( container.contains(_oView) )
						container.addChild(_oView);					
						container = null;

			//
				if( _oView != null )
					_oView.cancel( );

			//
				if( _oController != null )
					_oController.cancel( );
		

			super.onCancel( );
			_oFrontControl = null;
			_oModel        = null;
			_oView         = null;
			_oController   = null;
		}

	// -------o protected

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getModel( ) : AModel{
			return _oModel;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getView( ) : AView{
			return _oView;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getController( ) : AController{
			return _oController;
		}

	// -------o misc
	
}
