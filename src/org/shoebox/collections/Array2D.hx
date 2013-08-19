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
 * ...
 * @author shoe[box]
 */

private typedef Array2DDef<T> = {
	private var _aContent : Array<T>;
	private var _iWidth   : Int;
	private var _iHeight  : Int;
}

class Array2D<T>{

	public var length ( get , never ) : Int;
	public var width ( default , set ) : Int;
	public var height ( default , set ) : Int;

	private var _aContent : Array<T>;
	private var _iWidth   : Int;
	private var _iHeight  : Int;

	// -------o constructor

		/**
		* Create a new Array2D collection
		*
		* @public
		* @param	width  : Size X ( Int )
		* @param	height : Size Y ( Int )
		* @return	void
		*/
		public function new( w : Int , h : Int ) {
			_aContent = new Array<T>( );
			_iWidth   = w;
			_iHeight  = h;
		}

	// -------o public

		/**
		* Validate than the coordinates are contained in the Array2D Bounds
		*
		* @public
		* @return	true if coordinates are valid ( Bool )
		*/
		public function validate( dx : Int , dy : Int ) : Bool {
			return ( dx >= 0 && dy >= 0 && dx < _iWidth && dy < _iHeight );
		}

		/**
		* Convert the position to Index
		*
		* @public
		* @param 	dx : X position ( Int )
		* @param 	dy : Y position ( Int )
		* @return	index position in the Array ( Int )
		*/
		inline public function getIndex( dx : Int , dy : Int ) : Int{
			return dy * _iWidth + dx;
		}

		/**
		* Set a value inside the Array
		*
		* @param 	dx : X position 		( Int )
		* @param 	dy : Y position 		( Int )
		* @param	value : Value to insert ( T )
		* @return	true if valid 			( Bool )
		*/
		inline public function set( dx : Int , dy : Int , value : T ) : Bool{
			return _set( dx , dy , value );
		}

		/**
		* Get the value at position
		*
		* @public
		* @param 	dx : X position 		( Int )
		* @param 	dy : Y position 		( Int )
		* @return	value at position		( Int )
		*/
		inline public function get( dx : Int , dy : Int ) : T{
			return _get( dx , dy );
		}

		/**
		* Iterator of the Array2D content
		*
		* @public
		* @return	iterator of the Array2D content ( Array2DIterator<T> )
		*/
		public function iterator() : Array2DIterator<T>{
			return new Array2DIterator<T>( this );
		}

		/**
		* Check if the content at position is not null
		*
		* @public
		* @param 	dx : X position 		( Int )
		* @param 	dy : Y position 		( Int )
		* @return	true if not null		( Bool )
		*/
		inline public function hasContentAt( dx : Int , dy : Int ) : Bool {
			return _aContent[getIndex( dx , dy )] != null;
		}

		/**
		* Get the content of a region of the Array2D
		*
		* @public
		* @param 	minX : AABB min X ( Int )
		* @param 	minY : AABB min Y ( Int )
		* @param 	maxX : AABB max X ( Int )
		* @param 	maxY : AABB max Y ( Int )
		* @param	res  : Optional Array to be populated ( Array<T> )
		* @return	content of the region Array<T>
		*/
		public function getRegion( minX : Int , minY : Int , maxX : Int , maxY : Int , res : Array<T> = null ) : Array<T> {

			var res : Array<T> = res!=null ? res : new Array<T>( );
			for( dy in minY...maxY ){
				res = res.concat( _aContent.slice( getIndex( minX , dy ) , getIndex( maxX , dy ) ) );
			}

			return res;
		}

		/**
		* Get the content of a region of the Array2D with a custom Concatenator
		*
		* @public
		* @param 	minX : AABB min X ( Int )
		* @param 	minY : AABB min Y ( Int )
		* @param 	maxX : AABB max X ( Int )
		* @param 	maxY : AABB max Y ( Int )
		* @param	res  : Optional Array to be populated ( Array<T> )
		* @param	fContent  : Optional Concat function ( Array<T> -> Array<B> -> Array<B> )
		* @return	content of the region Array<T>
		*/
		public function getRegionCustom<B>( minX : Int , minY : Int , maxX : Int , maxY : Int , res : Array<B> , fConcat : Array<T> -> Array<B> -> Array<B> = null ) : Array<B> {

			for( dy in minY...maxY )
				res = fConcat( _aContent.slice( getIndex( minX , dy ) , getIndex( maxX , dy ) ) , res );

			return res;
		}

		/**
		* Trace the Array2D content
		*
		* @public
		* @return	void
		*/
		public function trace( ) : Void {

			var s : String;
			for( dy in 0..._iHeight ){
				s = '';
				for( dx in 0..._iWidth ){
					s = s + ' - '+get( dx , dy );
				}

				trace( s );
			}

		}

	// -------o protected

		/**
		* Size X of the Array2D
		*
		* @private
		* @param 	w : X size of the Array2D ( Int )
		* @return	Int
		*/
		private function set_width( w : Int ) : Int{
			return _iWidth = w;
		}

		/**
		* Size Y of the Array2D
		*
		* @private
		* @param 	h : Y size of the Array2D ( Int )
		* @return	Int
		*/
		private function set_height( h : Int ) : Int{
			return _iHeight = h;
		}

		/**
		* Getter of the Array2D length;
		*
		* @private
		* @return	Array2D length ( Int )
		*/
		inline private function get_length( ) : Int{
			return _iWidth * _iHeight;
		}

		/**
		* Setter of the content at position
		*
		* @private
		* @param 	dx : X position 		( Int )
		* @param 	dy : Y position 		( Int )
		* @param 	value : Value to insert	( T )
		* @return	Bool
		*/
		inline private function _set( dx : Int , dy : Int , value : T ) : Bool{
			_aContent[ getIndex( dx , dy ) ] = value;
			return true;
		}

		/**
		* Get the content at position
		*
		* @private
		* @param 	dx : X position 		( Int )
		* @param 	dy : Y position 		( Int )
		* @return	value at position		( T )
		*/
		inline private function _get( dx : Int , dy : Int ) : T{
			return _aContent [ getIndex( dx , dy ) ];
		}

	// -------o misc

}


class Array2DIterator<T>{

	private var _aRef			: Array2D<T>;
	private var _aContent		: Array<T>;

	private var _iInc			: Int;
	private var _iLen			: Int;

	// -------o constructor

		/**
		* Iterator constructor
		*
		* @public
		* @return	void
		*/
		public function new( ref : Array2D<T> ) {
			_aRef = ref;
			reset( );
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		inline public function reset( ) : Array2DIterator<T>{
			_aContent = __a( _aRef );
			_iLen = __size( _aRef );
			_iInc = 0;
			return this;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		inline public function hasNext( ) : Bool{
			return _iInc <= _iLen;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		inline public function next( ) : T{
			return _aContent[_iInc++];
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		inline public function remove( ) : Void{
			_aContent[_iInc - 1] = null;
		}

	// -------o protected

		inline function __a<T>( ref : Array2DDef<T> ) return ref._aContent;
		inline function __size<T>( ref : Array2DDef<T> ) return ref._iWidth * ref._iHeight;

	// -------o misc

}
