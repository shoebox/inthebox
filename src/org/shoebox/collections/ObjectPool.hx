package org.shoebox.collections;

import nme.errors.Error;

/**
 * ...
 * @author shoe[box]
 */

class ObjectPool<T>{

	private var _aPool : Array<Dynamic>;
	private var _aArgs : Array<Dynamic>;
	private var _cClass : Class<Dynamic>;
	private var _iLen : Int;
	private var _iUsed : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( cClass : Class<Dynamic> , iLen : Int , args : Array<Dynamic> = null ) {
			
			_aPool 	= new Array<Dynamic>( );
			
			_cClass = cClass;
			_iLen 	= iLen;
			_aArgs 	= args;
			_iUsed 	= 0;

		}
	
	// -------o public
			
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function allocate( ) : Void {

			trace('allocate');
			for( i in 0..._iLen ){
				_aPool[ i ] = _createInstance( _cClass , _aArgs );
			}

		}
			
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function get( ) : T {
			
			if( ( _iUsed + 1 ) > _iLen )
				throw new Error( 'Pool is empty' );

			return _pop( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline public function put( d : T ) : Void {
			_iUsed--;
			_aPool.push( d );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			for( i in 0..._iLen )
				_aPool[ i ] = null;
				_aPool = null;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _pop( ) : T{

			if( _iUsed >= _iLen )
				return null;
			
			var o : T = _aPool.pop( );
			if( o == null )
				o = _createInstance( _cClass , _aArgs );
			
			_iUsed++;
			return o;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _createInstance<T>( c : Class<T> , a : Array<Dynamic> ) : T{
			if( a == null )
				a = [ ];
			return Type.createInstance( c , a );
		}

	// -------o misc
	
}