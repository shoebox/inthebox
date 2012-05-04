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
package org.shoebox.patterns.mvc;

import flash.display.DisplayObjectContainer;
import nme.display.DisplayObject;
import nme.events.Event;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.patterns.mvc.abstracts.AModel;
import org.shoebox.patterns.mvc.abstracts.ABase;
import org.shoebox.patterns.mvc.abstracts.AView;
import org.shoebox.patterns.mvc.abstracts.AController;
import org.shoebox.patterns.mvc.interfaces.IModel;
import org.shoebox.patterns.mvc.interfaces.IView;
import org.shoebox.patterns.mvc.interfaces.IController;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;

/**
 * ...
 * @author shoe[box]
 */

class MVCTriad<M:(AModel,ABase),V:(AView,DisplayObject),C:(AController,ABase)> extends AbstractCommand , implements ICommand{

	public var container      : DisplayObjectContainer;
	public var codeName       : String;
	public var mod            : M;
	public var view           : V;
	public var controller     : C;
	public var cModel         : Class<M>;
	public var cView          : Class<V>;
	public var cController    : Class<C>;

	private var _aVariables : Array<Dynamic>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( 
								?cModel     : Class<M> = null , 
								?cView      : Class<V> = null , 
								?cController: Class<C> = null ,
								?container  : DisplayObjectContainer = null
							) {
			super( );

			cancelable = false;
			
			this.cModel      = cModel;
			this.cView       = cView;
			this.cController = cController;
			this.container   = container;
			
			_aVariables = [ ];
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setVariables( a : Array<Dynamic> ) : Void {
			_aVariables = a;		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ? e : Event = null ) : Void {
			if( container == null )
				throw new nme.errors.Error('Tri container is not defined');

			//

				if( cModel != null )
					mod = Type.createInstance( cModel , _aVariables == null ? [ ] : _aVariables );

				if ( cView != null )
					view = Type.createInstance( cView , [ ] );
				
				if ( cController != null )
					controller = Type.createInstance( cController , [ ] );

				_aVariables = null;

			//
				if( mod != null ){
					mod.codeName = codeName;
					mod.frontController = frontController;
				}

				if( view != null ){
					//view.container = container;
					view.initialize( );
				}

				if( controller != null ){
					controller.codeName = codeName;
					controller.frontController = frontController;
					controller.initialize( );
				}

			//
				if( mod != null )
					mod.initialize( );

			//
				if( mod != null )
					mod.startUp( );

				if( view != null )
					view.startUp( );
			
				if( controller != null )
					controller.startUp( );

			container.addChild( cast( view , DisplayObject ) );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ?e : Event = null ) : Void {
			
			//
				if( mod != null )
					mod.onCancel( );
				
			//
				if( controller != null )
					controller.onCancel( );
				
			// 
				if( view != null ){
					view.onCancel( );
					if( container != null )
						container.removeChild( view );
				}

			//
				mod        = null;
				view       = null;
				controller = null;
			trace('onCancel');
		}

	// -------o protected
	
		

	// -------o misc
	
}