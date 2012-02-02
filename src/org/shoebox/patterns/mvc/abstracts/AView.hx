package org.shoebox.patterns.mvc.abstracts; 

	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IView;
	import nme.display.Bitmap;
	import nme.display.DisplayObject;
	import nme.display.Loader;
	import nme.display.MovieClip;
	import nme.events.Event;

	/**
	 * ABSTRACT VIEW (MVC PACKAGE)
	* Responsabilities:
	* 
	*	===> The view receive update notification from the model
	* 	
	* 	===> The view can be modified by the controller
	* 	
	* 	===> The view send input events to the controller
	* 	
	* 	===> The view store the model instance and the controller instance
	* 	
	* org.shoebox.patterns.mvc2.controller.AView
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	class AView extends MovieClip, implements IView {
		
		
		
		public var app(getApp, setApp) : AApplication;
		
		public var controller(getController, setController) : AController;
		
		public var model: AModel;
		public var appContainer: MovieClip;
		public var frontController: FrontController;
				
		private var _oController: AController;
		private var _oAPPLICATION: AApplication;
		private var _vDisplayObjects	: Array<DisplayObject>;
		
		public var i: Int ;
		public var l: Int ;
		public var d: DisplayObject;
		
		// -------o constructor
			
			/**
			* 
			* @param
			* @return
			*/
			public function new(){
				super( );
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
			* 
			* @param
			* @return
			*/
			public function getController():AController{
				return _oController;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function setController(o:AController):AController{
				_oController = o;
				return o;
			}
				
			/**
			* Get the application instance
			* @return Application instance (AAplication)
			*/
			public function getApp():AApplication{
				return _oAPPLICATION;
			}
			
			/**
			* Set the application instance
			* @param o:Application instance (AAplication)
			* @return void
			*/
			public function setApp(o : AApplication):AApplication{
				_oAPPLICATION = o;
				return o;
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
			* register function
			* @public
			* @param 
			* @return
			*/
			public function registerAsset( d : DisplayObject ) : DisplayObject {
				
				if( _vDisplayObjects == null )
					_vDisplayObjects = new Array<DisplayObject>( );
				
				_vDisplayObjects.push( d );
				return d;
			}
			
			
			/**
			* onCancel function
			* @public
			* @param 
			* @return
			*/
			public function onCancel( ?e : Event = null ) : Void {
				
				
				if( _vDisplayObjects == null ){
					cancel( );
					return;
				}
				
				i = 0;
				l = _vDisplayObjects.length;
				
				i ;
					
				while ( i < l ){
					
					d = _vDisplayObjects[ i ];
					
					if( d == null )
						continue;
					
					if( Std.is( d, Bitmap) ){
						
						if( ( cast( d, Bitmap) ).bitmapData != null ){
							( cast( d, Bitmap) ).bitmapData.dispose( );
							( cast( d, Bitmap) ).bitmapData = null;
						}
						
					}else if( Std.is( d, Loader) ){
						
						( cast( d, Loader) ).unload( );
						
					}
					
					if( Std.is( d, MovieClip) ){
						( cast( d, MovieClip) ).stop( );
					}
					
					if( d.parent != null )
						d.parent.removeChild( d );
					
					_vDisplayObjects[ i ] = d = null;
					
					i++ ;
					
				}
				_vDisplayObjects = null;
				cancel( );
				
				if ( parent != null )
					parent.removeChild( this );
			}
			
		// -------o private
			
		// -------o misc
		
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AView,arguments);
			}
	}
