package org.shoebox.datas.structures;

import flash.Memory;
import flash.errors.Error;
import org.shoebox.datas.structures.MemRange;

/**
 * ...
 * @author shoe[box]
 */
class MemArray<T:Float>{
	
	private var _iOffset : Int;
	private var _iMax_length : Int;
	private var _mem : MemRange<T>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( mem : MemRange<T> , l : Int , offset : Int = -1 ) {
			setMem( mem );
			setOffset( offset == -1 ? _mem.getOffset( l + 1 ) : offset );
			set_length( offset == -1 ? 0 : getLength( ) );
			_iMax_length = l;
		}
	
	// -------o public
			
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setMem( m : MemRange<T> ) : Void {
			_mem = m;
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setOffset( i : Int ) : Void {
			_iOffset = i;
		}
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function add( value : T ) : Void {
			//trace("add ::: " + value);
			
			//Tests if max length
				#if debug
					//if ( length >= _iMax_length )
						//throw new Error("The MemArray is full");
				#end
				
			//
				var l = getLength( );
				_set( l , value );
				set_length( l + 1 );
		}		
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function get( pos : Int ) : T {
			return _get( pos );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function has( value : T ) : Int {
			var res = -1;
			for ( i in 0...getLength( ) ){
				if ( _get( i ) == value ){
					res = i;
					break;
				}
			}
			
			return res;
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function remove( value : T ) : Void {
			trace("remove ::: " + value);
			//Position of the value in the array
				var pos = has( value );
				
			//Cannot remove a value which is not contained
				if ( pos == -1 )
					return;
				
			//Moving bytes
				var l = getLength( );
				for ( i in has( value )...l )
					_set( i , _get( i + 1 ) );
					
			//Decrementing the length
				set_length( l - 1 );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return "[MemArray " + [for ( i in 0...getLength( ) ) get( i ) ] + " ]";
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getLength( ) : Int {
			return Memory.getByte( _iOffset );
		}

	// -------o protected
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _get( pos : Int ) : T {
			return _mem.get( pos + _iOffset + 1 );
		}
		
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _set( pos : Int , value : T ) : Void {
			_mem.set( pos + _iOffset + 1 , value );			
		}
		
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_length( i : Int ) : Int {
			Memory.setByte( _iOffset , i );
			return i;
		}

	// -------o misc
	
}