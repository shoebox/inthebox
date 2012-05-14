package org.shoebox.utils.system.flashevents;

import nme.events.EventDispatcher;
import nme.events.Event;
import org.shoebox.utils.system.SignalEvent;

/**
 * ...
 * @author shoe[box]
 */

class FlashEventsCache{

	private var _cache : IntHash<Hash<Array<CacheDesc>>>;

	// -------o constructor
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		private function new( ) : Void {
			_cache = new IntHash<Hash<Array<CacheDesc>>>( );
		}

	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function purgeTarget( chan : Int , target : EventDispatcher ) : Void {
			if( _cache == null )
				return;

			if( !_cache.exists( chan ) )
				return;

			var hChan = _cache.get( chan );
			var keys  = hChan.keys( );
			var aSubs : Array<CacheDesc>;
			for( sType in keys ){
				aSubs = hChan.get( sType );
				for( sub in aSubs ){
					if( sub.target == target ){
						aSubs.remove( sub );
						sub.signal.dispose( );
					}
				}

				if( aSubs.length == 0 )
					hChan.remove( sType );
			}

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get( chan : Int , target : EventDispatcher , sType : String , bBub : Bool = false ) : SignalEvent<Event>{
			
			// Type
				var hTypes : Hash<Array<CacheDesc>>;
				if( _cache.exists( chan ) )
					hTypes = _cache.get( chan );
				else
					_cache.set( chan , hTypes = new Hash<Array<CacheDesc>>( ) );

			// Array
				var aSubs  : Array<CacheDesc>;
				if( hTypes.exists( sType ) )
					aSubs = hTypes.get( sType );
				else
					hTypes.set( sType , aSubs = new Array<CacheDesc>( ) );
			
			//
				var b = false;
				var res = null;
				for( sub in aSubs ){
					if( sub.target == target && sub.bBub == bBub ){
						b = true;
						res = sub.signal;
					}
				}

			//
				if( !b ){
					res = new SignalEvent<Event>( target , sType , bBub );
					aSubs.push( { target : target , bBub : bBub , signal : res } );
				}

			return res;
		}

	// -------o protected
		
	// -------o misc
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function getInstance( ) : FlashEventsCache {
			if( __instance == null )
				__instance = new FlashEventsCache( );

			return __instance;	
		}

		private static var __instance : FlashEventsCache = null;

}

typedef CacheDesc = {
	public var target : EventDispatcher;
	public var bBub   : Bool;
	public var signal : SignalEvent<nme.events.Event>;
}