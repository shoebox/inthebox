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
package org.shoebox.patterns.mvc.abstracts; 

	import nme.errors.Error;
	import org.shoebox.core.BoxObject;
	import org.shoebox.utils.system.Signal;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IController;
	import nme.display.DisplayObject;
	import nme.events.Event;
	import nme.events.EventDispatcher;

	/**
	* ABSTRACT CONTROLLER (MVC PACKAGE)
	* Responsabilities:
	* 
	*	===> The controller store the model instance and the view instance
	* 
	* 	===> The controller update the view / model
	* 	
	* org.shoebox.patterns.mvc.controller.AController
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	class AController extends ABase, implements IController {
		
		public var model( _getModel , null ) : Dynamic;
		public var view( _getView , null ) : Dynamic;
		//public var controller( _getController , null ) : AController;
		
		private var _oDico			: Hash<Dynamic> ;
		
		// -------o constructor
			
			/**
			* 
			* @param
			* @return
			*/
			public function new(){
				super( );
				_oDico			 = new Hash<Dynamic>( );
			}
			
		// -------o public
			
			/**
			* 
			* @param
			* @return
			*/
			public function initialize():Void{
			
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function cancel( ):Void{
				
			}
			
			/**
			* onCancel function
			* @public
			* @param 
			* @return
			*/
			override public function onCancel( ) : Void {
				
				trace('onCancel');
				cancel( );
				super.onCancel( );

			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function registerCommand(	command:Class<Dynamic>,
									?props:Dynamic = null,
									?tgt:EventDispatcher = null,
									?sEVENTNAME:String = null, 
									?bCAPTURE : Bool = false, 
									?bPRIO : Int = 0, 
									?bWEAK : Bool = false):Void{
				
				throw new Error('Deprecate');
				
				/*
				if(tgt == null || sEVENTNAME == null)
					throw new ArgumentError(Errors.ARGUMENTSERROR);
				
				var oFUNC:Function = Relegate.create( this , _onCallCommand , false , command , tgt , props );
				if(_oDico[tgt]==undefined)
					_oDico[tgt] = {};
					
				_oDico[tgt][sEVENTNAME] = oFUNC;
				tgt.addEventListener(sEVENTNAME,oFUNC, bCAPTURE,bPRIO,bWEAK);		
				 *
				 */	
			}

			/**
			* @param
			* @return
			*/
			public function unRegisterCommand(command : Class<Dynamic>,
									tgt :EventDispatcher,
									sEVENTNAME : String) : Void {
				/*
				if(_oDico[tgt][sEVENTNAME]!=undefined)
					tgt.removeEventListener(sEVENTNAME, _oDico[tgt][sEVENTNAME]);	
				*/
				trace('TBD');
			}
			
			/**
			* runApp function
			* @public
			* @param 
			* @return
			*/
			public function startUp() : Void {
			
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function getView( ) {
				return _getView( );
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function getModel( ) {
				return _getModel( );
			}

		// -------o private
			
			/**
			* Calling the command and executing it after the event
			* @param e : Event from which the call is from
			* @param cCOMMAND	: Command class (CLASS)
			* @param tgt:Target on which the command will be applied
			* @return void
			*/
			function _onCallCommand(e:Event , ?cCommand:Class<Dynamic> = null , ?tgt:EventDispatcher = null , ?props:Dynamic = null):Void{
				
				var oCom : AbstractCommand = Type.createInstance( cCommand , [] ) ;// Factory.build(cCOMMAND , props);
				BoxObject.accessorInit( oCom , props );
					oCom.execute(e);
				
			}
		
		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AController,arguments);
			}
	}
