package org.shoebox.net;

import nme.display.DisplayObject;
import nme.events.Event;
import nme.display.Loader;
import nme.net.URLRequest;
import org.shoebox.utils.system.Signal2;

#if flash
import flash.system.LoaderContext;
#end

/**
 * ...
 * @author shoe[box]
 */

class LoadingQueue{

	#if flash
	public var checkPolicyFile ( default , _setPolicyFile ) : Bool;
	private var _oContext : LoaderContext;
	#end

	public var onLoaded : Signal2<Int,Loader>;

	private var _iPos   : Int;
	private var _oQueue : Array<LoaderQueueItem>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			#if flash
			_oContext = new LoaderContext( true , flash.system.ApplicationDomain.currentDomain );
			#end
			onLoaded = new Signal2<Int,Loader>( );
			reset( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add( id : Int , sUrl : String ) : Void {
			#if flash
			var item = new LoaderQueueItem( id , sUrl , _oContext );
			#else
			var item = new LoaderQueueItem( id , sUrl );
			#end
			_oQueue.push( item );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function reset( ) : Void {
			
			if( _oQueue != null ){
				for( item in _oQueue ){
					item.dispose( );
				}
			}

			_oQueue = [ ];

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function run( ) : Void {
			for( item in _oQueue ){
				item.starLoading( _onLoaded );
			}
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onLoaded( id : Int , sPath : String , content : Loader ) : Void{
			onLoaded.emit( id , content );
		}

		#if flash

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setPolicyFile( b : Bool ) : Bool{
			return _oContext.checkPolicyFile = b;
		}

		#end

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class LoaderQueueItem extends Loader{

	public var id   : Int;
	public var sUrl : String;
	
	private var _oLoader   : Loader;
	private var _fCallback : Int->String->Loader->Void;

	#if flash
	private var _oContext : LoaderContext;
	#end

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		#if flash
		public function new( id : Int , sUrl : String , context : LoaderContext ) {
			_oContext = context;
			//trace('constructor ::: '+_oContext+' - '+_oContext.checkPolicyFile+' - '+_oContext.applicationDomain );
		#else
		public function new( id : Int , sUrl : String ) {
		#end
			super( );
			this.id   = id;
			this.sUrl = sUrl;
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			#if flash
			if( _oLoader != null )
				_oLoader.close( );	
			#end
			_fCallback = null;
			contentLoaderInfo.removeEventListener( Event.COMPLETE , _onLoaded , false );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function starLoading( f : Int->String->Loader->Void ) : Void {
			_fCallback = f;
			contentLoaderInfo.addEventListener( Event.COMPLETE , _onLoaded , false );
			#if flash
				contentLoaderInfo.addEventListener( flash.events.IOErrorEvent.IO_ERROR 		, _onIoError	, false );
				contentLoaderInfo.addEventListener( flash.events.IOErrorEvent.DISK_ERROR 	, _onIoError	, false );
				contentLoaderInfo.addEventListener( flash.events.IOErrorEvent.NETWORK_ERROR 	, _onIoError	, false );
				contentLoaderInfo.addEventListener( flash.events.IOErrorEvent.VERIFY_ERROR 	, _onIoError	, false );
				contentLoaderInfo.addEventListener( flash.events.HTTPStatusEvent.HTTP_STATUS , _onStatus  	, false );
				load( new URLRequest( sUrl ) , _oContext );
			#else
				load( new URLRequest( sUrl ) );
			#end
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onLoaded( e : Event ) : Void{
			contentLoaderInfo.removeEventListener( Event.COMPLETE , _onLoaded , false );
			_fCallback( id , sUrl , this );
		}

		#if flash
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onIoError( e : flash.events.IOErrorEvent ) : Void{
			
			#if debug
			trace( e );
			#end
			throw e;
		}

		

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onStatus( e : flash.events.HTTPStatusEvent ) : Void{
			
			if( e.status > 400 ){
				#if debug
				trace( e );
				#end
				throw e;
			}

		}


		#end

	// -------o misc
	
}
