package org.shoebox.patterns.mvc.abstracts; 
	
	import org.shoebox.patterns.mvc.commands.MVCCommand;
	
	import nme.display.DisplayObjectContainer;
	import nme.display.MovieClip;
	import nme.events.Event;	

	/**
	 *
	* org.shoebox.patterns.mvc.application.AApplication
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	class AApplication extends MovieClip {
		
		
		
		public var model(getModel, null) : AModel ;
		
		public var view(getView, null) : AView ;
		
		private var _oCommand		: MVCCommand ;
		
		// -------o constructor
			/**
			* 
			* @param
			* @return
			*/
			public function new() {
				super( );
				_oCommand		 = null;
			}	

		// -------o public
			
			/**
			* 
			* @param
			* @return
			*/
			public function init(?m:Class<AModel>=null, ?v:Class<AView>=null , ?c:Class<AController>=null , ?mcContainer:DisplayObjectContainer=null):AApplication{
				
				mouseEnabled = false;
				
				if(_oCommand!=null)
					_oCommand.cancel();
				
					_oCommand = new MVCCommand( m , v , c , mcContainer , null );
					_oCommand.prepare( );
					_oCommand.execute();	
					
				return this;			
			}
			
			/**
			* get model function
			* @public
			* @param 
			* @return
			*/
			public function getModel():AModel {
				return _oCommand.model;
			}
			
			/**
			* get view function
			* @public
			* @param 
			* @return
			*/
			public function getView():AView {
				return _oCommand.view;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function cancel():Void{
				
				dispatchEvent(new Event(Event.CANCEL , false , true));
				_oCommand.cancel();		
				//_oCommand = null;	
			}
			
		// -------o private
			
		// -------o misc
			
	}
