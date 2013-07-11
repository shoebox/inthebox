/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice,
*   this list of conditions and the following disclaimer.
*
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
*
* Neither the name of shoe[box] nor the names of its
* contributors may be used to endorse or promote products derived from
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.shoebox.collections;

/**
 * Priority Queue
 * Queue sort by priority
 *
 * @author shoe[box]
 */

class PriorityQueue<T>{

	public var length( get_length , never ) : Int;

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
		* Add a value to the <code>PriorityQueue</code>
		*
		* @public
		* @param 	value 		: Value to add 	( T )
		* @param 	priority 	: Priority of the value in to the queue ( Int )
		* @return	Void
		*/
		public function add( value : T , ?prio : Int = 0 ) : Void {

			var desc = new PrioDesc<T>( );
				desc.content = value;
				desc.prio = prio;

			_add( desc , prio );
			_bInvalidate = true;
		}

		/**
		* Remove a value from the <code>PriorityQueue</code>
		*
		* @public
		* @param 	value 		: Value to remove 	( T )
		* @param 	priority 	: Priority of the value ( Int )
		* @return	success of the removal ( Bool )
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
		* Test if the <code>PriorityQueue</code> contains the the value at the priority N.
		*
		* @public
		* @value 	value 	: value to test ( T )
		* @value 	prio 	: prio of the value in to the queue ( Int )
		* @return	success ( Bool )
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
		* Sort the queue content
		*
		* @public
		* @return	void
		*/
		public function sort( ) : Void {
			_sort( );
		}

		/**
		* Test for invalidation and return the content Iterator
		*
		* @public
		* @return	queue content iterator ( PrioQueueIterator<T> ) );
		*/
		public function iterator(  ) : PrioQueueIterator<T> {

			if( !_bInvalidate ){
				_oIterator.reset( );
				return _oIterator;
			}

			if( _oIterator == null ){
				_oIterator = new PrioQueueIterator<T>( _aContent );
			}else{
				_oIterator.reset( );
				_oIterator.setContent( _aContent );
			}

			_bInvalidate = false;
			return _oIterator;
		}

		/**
		* Change the priority of a value
		*
		* @public
		* @param	value 	: Value 	( T )
		* @param	prio	: New priority ( Int )
		* @return	Void
		*/
		public function setPrioOf( value : T , prio : Int ) : Void {

			for( o in _aContent )
				if( o.content == value )
					o.prio = prio;

			_sort( );

		}

		/**
		* Get the priority of the first instance of T in the queue
		* return -1 if the value is not contained by the <code>PriorityQueue</code>
		*
		* @public
		* @param	value : Value to be test ( T )
		* @return	First priority of the value ( Int )
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
		* Get the content of the PriorityQueue childs <PrioDesc<T>>
		*
		* @public
		* @return	queue content ( PrioDesc<T> )
		*/
		public function getContent( ) : Array<PrioDesc<T>> {
			return _aContent;
		}

	// -------o protected

		/**
		* Sort the content of the queue by priority
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
		* Add a new value to the queue
		*
		* @private
		* @param 	value 	: Value to add 	( T )
		* @param 	prio 	: Priority of the value in to the queue ( Int )
		* @return	Void
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
		* Getter of the queue size
		*
		* @private
		* @return	size of the queue ( Int )
		*/
		private function get_length( ) : Int{
			return _aContent.length;
		}

	// -------o misc

}

/**
 * ...
 * @author shoe[box]
 */

class PrioDesc<T>{

	public var prio    : Int;
	public var content : T;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {

		}

	// -------o public



	// -------o protected



	// -------o misc

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
			setContent( content );
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setContent( content : Array<PrioDesc<T>> ) : Void {
			_aContent = content.copy( );
		}

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
		inline public function next( ) : T {
			return _aContent[ inc++ ].content;
		}

	// -------o protected

	// -------o misc

}