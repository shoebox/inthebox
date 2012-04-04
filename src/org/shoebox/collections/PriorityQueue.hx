package org.shoebox.collections;

/**
 * ...
 * @author shoe[box]
 */

class PriorityQueue<T>{

	public var length( _getLength , never ) : Int;

	private var _aContent    : Array<PrioDesc<T>>;
	private var _bInvalidate : Bool;
	private var _oIterator   : PrioQueueIterator<T>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			_aContent = [ ];
			_bInvalidate = true;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add( value : T , ?prio : Int = 0 ) : Void {
			
			var desc = { content : value , prio : prio };

			_add( desc , prio );
			_bInvalidate = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function remove( value : T , prio : Int = -1 ) : Bool {

			var desc;
			var b = false;
			for( desc in _aContent ){
				if( desc.content == value && ( prio == -1 || desc.prio == prio ) ){
					_aContent.remove( desc );
					b = true;
					break;
				}
			}
			_bInvalidate = true;
			return b;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function contains( value : T , prio : Int ) : Bool {
			
			var b = false;
			for( desc in _aContent ){
				if( desc.content == value && desc.prio == prio ){
					b = true;
					break;
				}
			}	

			return b;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function sort( ) : Void {
			_sort( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function iterator(  ) : PrioQueueIterator<T> {

			if( !_bInvalidate )
				return _oIterator;

			_oIterator = new PrioQueueIterator<T>( _aContent );
			return _oIterator;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setPrioOf( value : T , prio : Int ) : Void {
			
			for( o in _aContent )
				if( o.content == value )
					o.prio = prio;

			_sort( );

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getPrioOf( value : T ) : Int {
			var b = false;
			var p = -1;
			for( desc in _aContent ){
				if( desc.content == value )
					p = desc.prio;
			}

			return p;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getContent( ) : Array<PrioDesc<T>> {
			return _aContent;
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _sort( ) : Void{
			var a = _aContent.copy( );
			_aContent = [ ];
			for( desc in a )
				_add( desc , desc.prio );
			_bInvalidate = true;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _add( desc : PrioDesc<T> , prio : Int ) : Void{
			var inc = _aContent.length;
			while( inc-- > 0 ){
				if( _aContent[ inc ].prio >= prio )
					break;
			}

			_aContent.insert( inc + 1 , desc );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getLength( ) : Int{
			return _aContent.length;
		}

	// -------o misc
	
}

typedef PrioDesc<T>={
	var prio    : Int;
	var content : T;
}



/**
 * ...
 * @author shoe[box]
 */

class PrioQueueIterator<T>{

	public var inc : Int;
	
	private var _aContent : Array<PrioDesc<T>>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( content : Array<PrioDesc<T>> ) {
			_aContent = content.copy( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function reset( ) : Void {
			inc = 0;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function hasNext( ) : Bool {
			return inc < _aContent.length;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function next( ) : T {
			return _aContent[ inc++ ].content;
		}

	// -------o protected
	
	// -------o misc
	
}