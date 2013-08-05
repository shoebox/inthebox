package ;

import BytesMemory;
import flash.Memory;
import flash.utils.ByteArray;

/**
 * ...
 * @author shoe[box]
 */

class MemoryGraph{

	public var root ( default , default ) : Int;
	public var offset ( default , default ) : Int;

	public var length	: Int;
	public var raw		: BytesMemory;

	private var _offset : Int;
	private var _iMax_node_links	: Int;
	private var _iMaxNodes			: Int;

	// -------o constructor

		/**
		* constructor
		*if
		* @param
		* @return	void
		*/
		public function new( iMax_node_links : Int , iMaxNodes : Int , offset : Int = 0 ) {
			_iMaxNodes			= iMaxNodes;
			_iMax_node_links	= iMax_node_links;
			this.offset			= offset;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function addMutual_link( from : Int ,  to : Int ) : Void {

			if( from == to )
				return;

			trace("addMutual_link ::: "+from+" to "+to);

			addLink( from , to );
			addLink( to , from );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function addLink( from : Int , to : Int ) : Void {
			if( from == to || hasLink( from , to ) )
				return;

			var count = _getCount( from );
			raw.set( _getPosition( from , count ) , to );
			_setCount( from , count + 1 );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		inline public function hasLink( from : Int , to : Int ) : Bool {
			var count = _getCount( from );
			var bRes = false;
			for( i in 0...count ){
				if( raw.get( _getPosition( from , i ) ) == to ){
					bRes = true;
					break;
				}
			}
			return bRes;

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function unlink( id : Int ) : Void {
			//trace("unlink ::: "+id);
			var iCount	: Int;
			var iPos	: Int;
			for( i in 0..._iMaxNodes ){

				iCount = _getCount( i );
				if( iCount == 0 )
					continue;

				iPos = -1;

				for( z in 0...iCount ){
					if( _getValue( i , z ) == id )
						iPos = z;
				}

				if( iPos == -1 )
					continue;

				//tracePos( i );

				for( z in iPos...iCount )
					raw.set( _getPosition( i , z ) , _getValue( i , z + 1 ) );

				iCount--;
				_setCount( i , iCount );
				//tracePos( i );
			}

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function tracePos( id : Int ) : Void {
			trace("-------------------------------------------------------");
			var count = _getCount( id );
			for( z in 0...count )
				trace( z+" === "+_getValue( id , z ) );


		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function push( from : Int , to : Int ) : Void {

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function bfs( to : Int ) : Bool {
			var queue	: Array<Int> 	= [root];
			var visited	: Array<Bool> 	= [];
				visited[root] = true;

			var iCount	: Int;
			var iPos	: Int;
			var iTo		: Int;
			var res		: Array<Int> = [ ];
			var t		: Int;
			while( queue.length > 0 ){

				t = queue.pop( );
				if( t == to )
					return true;

				iCount	= _getCount( t );

				for( i in 0...iCount ){
					iTo = _getValue( t , i );
					if( !visited[ iTo ] ){
						visited[ iTo ] = true;
						queue.push( iTo );

					}
				}

			}
			return false;
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getCount( id : Int ) : Int{
			return raw.get( id + offset );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _setCount( id : Int , count : Int ) : Void{
			raw.set( id + offset , count );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getCount_pos( id : Int , ?pos : Int = 0 ) : Int{
			return id * _iMaxNodes + pos + offset;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getPosition( id : Int , z : Int ) : Int{
			return id * _iMax_node_links + z + _iMaxNodes + offset;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getValue( id : Int , z : Int ) : Int{
			return raw.get( _getPosition( id , z ) );
		}

	// -------o misc

}
