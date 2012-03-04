package org.shoebox.patterns.mvc.abstracts; 

	import org.shoebox.patterns.mvc.commands.MVCCommand;
	import org.shoebox.core.interfaces.IDispose;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IView;
	import nme.display.Bitmap;
	import nme.display.DisplayObject;
	import nme.display.DisplayObjectContainer;
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
		
		//public var model 			( _getModel , null ) 		: AModel;
		//public var view 			( _getView , null ) 		: AView;
		//public var controller 		( _getController , null ) 	: AController;

		//public var container ( _getContainer , never ) : DisplayObjectContainer;

		//public var frontController 	( _getFc , null ) 			: FrontController;
		
		//public var ref             : MVCCommand;
				
		private var _vDisplayObjects	: Array<DisplayObject>;
		
		
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
					
				for( d in _vDisplayObjects ){
					
					if( d == null )
						continue;
					
					if( Std.is( d , IDispose ) ){
						cast( d , IDispose ).dispose( );
					}

					if( Std.is( d, Bitmap) ){
						
						if( ( cast( d, Bitmap) ).bitmapData != null ){
							( cast( d, Bitmap) ).bitmapData.dispose( );
							( cast( d, Bitmap) ).bitmapData = null;
						}
						
					}else if( Std.is( d, Loader) ){
						#if (flash || mobile )
						( cast( d, Loader) ).unload( );
						#end
					}
					
					if( Std.is( d, MovieClip) ){
						( cast( d, MovieClip) ).stop( );
					}
					
					if( d.parent != null )
						d.parent.removeChild( d );
				}
				
				_vDisplayObjects = null;
				cancel( );
				
				if ( parent != null )
					parent.removeChild( this );
			}
			
		// -------o private
			
			/**
			* 
			* 
			* @private
			* @return	void
			
			private function _getFc( ) : FrontController{
				return ref.frontController;
			}*/

			/**
			* 
			* 
			* @private
			* @return	void
			
			private function _getContainer( ) : DisplayObjectContainer{
				return ref.container;
			}*/

		// -------o misc
		
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AView,arguments);
			}
	}
