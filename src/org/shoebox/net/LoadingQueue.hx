package org.shoebox.net;

import nme.display.DisplayObject;
import nme.events.Event;
import nme.display.Loader;
import nme.net.URLRequest;
import org.shoebox.utils.system.Signal2;

/**
 * ...
 * @author shoe[box]
 */

class LoadingQueue{

	public var onLoaded : Signal2<Int,DisplayObject>;

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
			trace('constructor');
			onLoaded = new Signal2<Int,DisplayObject>( );
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
			_oQueue.push( new LoaderQueueItem( id , sUrl ) );
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
		private function _onLoaded( id : Int , sPath : String , content : DisplayObject ) : Void{
			onLoaded.emit( id , content );
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class LoaderQueueItem extends Loader{

	public var id   : Int;
	public var sUrl : String;
	
	private var _oLoader : Loader;
	private var _fCallback : Int->String->DisplayObject->Void;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( id : Int , sUrl : String ) {
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
		public function starLoading( f : Int->String->DisplayObject->Void ) : Void {
			_fCallback = f;
			contentLoaderInfo.addEventListener( Event.COMPLETE , _onLoaded , false );
			load( new URLRequest( sUrl ) );
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
			_fCallback( id , sUrl , contentLoaderInfo.content );
		}

	// -------o misc
	
}
