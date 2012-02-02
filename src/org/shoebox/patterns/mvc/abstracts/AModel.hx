package org.shoebox.patterns.mvc.abstracts; 

	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IView;
	import nme.events.Event;
	import nme.events.EventDispatcher;

	/**
	 * ABSTRACT MODEL (MVC PACKAGE)
	* Responsabilities:
	* 
	*	===> The model store the datas
	* 	
	* 	===> The model store the view instance
	* 	
	* 	===> The model update the view
	* 	
	* org.shoebox.patterns.mvc2.controller.AModel
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	class AModel extends EventDispatcher {
		
		public var app				: AApplication;
		public var frontController	: FrontController;
		public var controller		: AController;
		public var view				: AView;
		
		var _oAPPLICATION: AApplication;
		
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
			
			/*
			* Do nothing method, call to intialize the controller
			* (After than the view have been added to the stage)
			* 
			* @return void/
			*/
			public function initialize( ):Void{
				
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
				cancel( );
			}
			
			/**
			* runApp function
			* @public
			* @param 
			* @return
			*/
			public function startUp( ) : Void {
			
			}
			
		// -------o private
			
		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AModel,arguments);
			}
			
			
	}
