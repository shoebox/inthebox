package org.shoebox.patterns.mvc.abstracts; 

	import nme.errors.IllegalOperationError;
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
	class AController extends Signal, implements IController {
		
		public var app				: AApplication;
		public var model			: AModel;
		public var view				: AView;
		public var frontController	: FrontController;
		
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
			public function onCancel( ) : Void {
				cancelAllEvents( );
				cancel( );
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
				
				throw new IllegalOperationError('Deprecate');
				
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
			* Do nothing method, call to intialize the controller
			* (After than the view have been added to the stage)
			* 
			* @return void
			public function initialize():void{
				throw new Error(Errors.DONOTHING);
			}
			*/
			
			/**
			* runApp function
			* @public
			* @param 
			* @return
			*/
			public function startUp() : Void {
			
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
