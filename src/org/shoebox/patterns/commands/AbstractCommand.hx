package org.shoebox.patterns.commands; 

	//import org.shoebox.patterns.commands.events.CommandEvents;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.utils.system.Signal;
	import nme.errors.Error;
	import nme.events.Event;
	
	/**
	 *
	* org.shoebox.patterns.commands.AbstractCommand
	* @date:2 sept. 09
	* @author shoe[box]
	*/
	class AbstractCommand extends Signal, implements ICommand {
		
		public var cancelable(null, setCancelable) : Bool ;
		
		public var isRunning(getIsRunning, null) : Bool ;
		
		/*[Event(name="Event_COMMAND_COMPLETE", 	type="org.shoebox.patterns.commands.events.CommandEvents")]*/
		/*[Event(name="Event_COMMAND_CANCEL",	 	type="org.shoebox.patterns.commands.events.CommandEvents")]*/
		/*[Event(name="Event_COMMAND_START", 		type="org.shoebox.patterns.commands.events.CommandEvents")]*/
		
		public var frontController: FrontController;
	
		var ERROR_ISRUNNING: String ;
		var ERROR_ISCANCELED: String ;
		
		var _bIsCancelable: Bool ;
		var _bIsRunning: Bool ;
		var _bIsCanceled: Bool ;
		
		// -------o constructor
		
			/**
			* contructor
			* @return void
		 	*/
			public function new( ) {
				super( );
				frontController		= null;
				_bIsCancelable		= true;
				ERROR_ISRUNNING		= 'Execute() failed. Command is already running';
				ERROR_ISCANCELED	= 'Execute() failed. Command is canceled';
			}
			
		// -------o public
			
			/**
			* reset function
			* @public
			* @param 
			* @return
			*/
			public function resetCommand() : Void {
				_bIsRunning = _bIsCanceled = false;
			}
			
			/**
			* set cancelable function
			* @public
			* @param 
			* @return
			*/
			public function setCancelable( b : Bool ):Bool {
				_bIsCancelable = b;
				return b;
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			public function execute(?e:Event = null ) : Void {
				
				if( _bIsRunning )
					throw new Error(ERROR_ISRUNNING+' /// '+this) ;
				else if( _bIsCanceled )
					throw new Error(ERROR_ISCANCELED+' /// '+this) ;
				else{
					
					start();
					_bIsCanceled = false;
					_bIsRunning = true;
					onExecute(e);
				}
			}
			
			/**
			* start function
			* @public
			* @param 
			* @return
			*/
			public function start() : Void {
				_bIsRunning = true;
			}

			/**
			* 
			*
			* @param 
			* @return
			*/
			public function cancel(?e:Event = null) : Void {
				
				if(_bIsCanceled)
					throw(  new Error('The command is already canceled'));
					
				if(!_bIsRunning)
					throw( new Error('Cannot cancel a command who was not started'));
				
				if(_bIsCancelable)
					_bIsCanceled = true;
					_bIsRunning = false;
					
				onCancel(e);	
			}
			
			/**
			* get isRunning function
			* @public
			* @param 
			* @return
			*/
			public function getIsRunning():Bool {
				return _bIsRunning;
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function onExecute(?e:Event = null):Void{
				
			}
			
			/**
			* 
			* @param
			* @return
			*/
			public function onCancel(?e:Event = null):Void{
			
			}
			
			/**
			* onComplete function
			* @public
			* 
			* @param	o : Optional argument (Object) 
			* @return void
			*/
			public function onComplete( ):Void{
				
				_bIsRunning = false;
				_onCompleted( );
			}
			
		// -------o private
			
			/**
			* 
			*
			* @param 
			* @return
		 	*/
			private function _onCompleted() : Void {
				//emit( 'COMPLETE' , this );
				trace('onComplete');
			}
			
		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AbstractCommand,arguments);
			}
	}
