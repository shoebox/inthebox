package org.shoebox.patterns.mvc.abstracts; 

	import org.shoebox.patterns.mvc.commands.MVCCommand;
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
		
		//public var model 			( _getModel , null ) 		: AModel;
		public var view 			( _getView , null ) 		: AView;
		public var controller 		( _getController , null ) 	: AController;
		public var frontController 	( _getFc , null ) 			: FrontController;

		public var ref             : MVCCommand;
		
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
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _getModel( ) : AModel{
				return ref.model;
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _getView( ) : AView{
				return ref.view;
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _getController( ) : AController{
				return ref.controller;
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _getFc( ) : FrontController{
				return ref.frontController;
			}

		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AModel,arguments);
			}
			
			
	}
