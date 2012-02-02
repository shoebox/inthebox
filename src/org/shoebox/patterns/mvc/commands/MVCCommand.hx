package org.shoebox.patterns.mvc.commands; 

	import org.shoebox.core.BoxObject;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.commands.ICommand;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.abstracts.AApplication;
	import org.shoebox.patterns.mvc.abstracts.AController;
	import org.shoebox.patterns.mvc.abstracts.AModel;
	import org.shoebox.patterns.mvc.abstracts.AView;
	import org.shoebox.patterns.mvc.interfaces.IController;
	import org.shoebox.patterns.mvc.interfaces.IModel;
	import org.shoebox.patterns.mvc.interfaces.IView;
	import nme.display.DisplayObjectContainer;
	import nme.events.Event;

	/**
	 *
	* org.shoebox.patterns.mvc.commands.CommandInitTriad
	* @date:4 sept. 09
	* @author shoe[box]
	*/
	class MVCCommand extends AbstractCommand, implements ICommand {
		
		
		public var app(null, setApp) : AApplication;
		
		public var controller(getController, null) : AController ;
		
		public var controllerClass(null, setControllerClass) : Class<Dynamic>;
		
		public var model(getModel, null) : AModel ;
		
		public var modelClass(null, setModelClass) : Class<Dynamic>;
		
		public var view(getView, null) : AView ;
		
		public var viewClass(null, setViewClass) : Class<Dynamic>;
		
		public var container       : DisplayObjectContainer ;
		public var containerBackup : DisplayObjectContainer ;
		
		var _oAPP                  : AApplication;
		var _oController           : AController;
		var _oModel                : AModel;
		var _oView                 : AView;
		var _cController           : Class<Dynamic>;
		var _cModel                : Class<Dynamic>;
		var _cView                 : Class<Dynamic>;
		var _oVars                 : Dynamic;
		var _oFrontController      : FrontController;
		
		// -------o constructor
			/**
			* contructor
			* @return void
			*/
			public function new( ?m : Class<Dynamic> = null , ?v : Class<Dynamic> = null , ?c : Class<Dynamic> = null , oContainer : DisplayObjectContainer = null , ?fC : FrontController = null ){

				super( );
				container         = null ;
				containerBackup   = null ;
				_cModel           = m;
				_cView            = v;
				_cController      = c;
				this.container    = oContainer;
				_oFrontController = fC;
				cancelable        = false;
				//trace('constructor ::: '+oContainer+' - '+this.container);
			}
			
		// -------o public
			
			/**
			* setVars function
			* @public
			* @param 
			* @return
			*/
			public function setVars( o : Dynamic ) : Void {
				_oVars = o;
			}
			
			/**
			* get model function
			* @public
			* @param 
			* @return
			*/
			public function getModel():AModel {
				return _oModel;
			}
			
			/**
			* get view function
			* @public
			* @param 
			* @return
			*/
			public function getView():AView {
				return _oView;
			}
			
			/**
			* get controller function
			* @public
			* @param 
			* @return
			*/
			public function getController():AController {
				return _oController;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function setApp(a:AApplication):AApplication{
				_oAPP = a;
				return a;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function setModelClass(c:Class<Dynamic>):Class<Dynamic>{
				_cModel = c;				
				return c;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function setViewClass(c:Class<Dynamic>):Class<Dynamic>{
				_cView = c;
				return c;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function setControllerClass(c:Class<Dynamic>):Class<Dynamic>{
				_cController = c;
				return c;
			}
			
			public function prepare( ) : Void {
				
				// Model
					if( _cModel != null )
						_oModel = Type.createInstance( _cModel , [ ] );
					
					if( _oVars )
						BoxObject.accessorInit( _oModel , [ ] );					
					
				// View
					if( _cView != null )
						_oView = Type.createInstance( _cView , [ ]);
						
				// Controller
					if( _cController != null )
						_oController = Type.createInstance( _cController , [ ] );
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public override function onExecute(?e:Event = null):Void{
				
				//
					
					if ( _cModel != null ) {
						_oModel.view            = _oView;
						_oModel.controller      = _oController;
						_oModel.app             = _oAPP;
						_oModel.frontController = _oFrontController;
					}
					
					if ( _cView != null ) {
						_oView.model           = _oModel;
						_oView.controller      = _oController;
						_oView.app             = _oAPP;
						_oView.frontController = _oFrontController;
					}
					
					if ( _cController != null ) {
						_oController.model           = _oModel;
						_oController.view            = _oView;
						_oController.app             = _oAPP;
						_oController.frontController = _oFrontController;
					}
					
				//
					if(container != null && !container.contains(_oView))
						container.addChild(_oView);			
					
				//
					if(_cModel != null)
						(cast( _oModel, IModel)).initialize( );
						
					if(_cController != null)
						(cast( _oController, IController)).initialize();
					
					if(_cView != null)
						(cast( _oView, IView)).initialize();
						
				//
					if( _oController != null)
						(cast( _oController, AController)).startUp();
					
					if( _oModel != null )
						(cast( _oModel, AModel)).startUp( );
						
					if( _oView != null)
						(cast( _oView, AView)).startUp();
					
				
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public override function onCancel(?e:Event = null):Void{
					
				if(_oModel!=null){
					_oModel.onCancel( );
					_oModel.view            = null;
					_oModel.controller      = null;
					_oModel.frontController = null;
					_oModel.app             = null;
				}
				
				if(_oView!=null){
					
					
					if( container != null ){
						if( container.contains( _oView )){
							container.removeChild( _oView );		
						}
					}
					
					_oView.onCancel( );
					/*
					if( ClassUtils.hasFunction( _oView , 'removeChildren' ) ){
						_oView['removeChildren']( );
					}
						*/
					_oView.model           = null;
					_oView.controller      = null;
					_oView.frontController = null;
					_oView.app             = null;
				}
				
				if(_oController!=null){
					_oController.onCancel( );
					_oController.model           = null;
					_oController.view            = null;
					_oController.frontController = null;
					_oController.app             = null;
				}
				
				_oModel      = null;
				_oView       = null;
				_oController = null;
				
			}
			
		// -------o private
				
		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(MVCCommand,arguments);
			}
	}
