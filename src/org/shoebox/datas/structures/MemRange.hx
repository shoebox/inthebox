package org.shoebox.datas.structures;	

import flash.errors.Error;
import flash.Memory;
import flash.utils.ByteArray;



/**
 * ...
 * @author shoe[box]
 */
class MemRange<T>{
	
	public var raw : ByteArray;
	
	private var _iOffset : Int;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( l : Int , r : ByteArray = null ) {
			if( r == null ){
				#if flash
					raw = new ByteArray( );
					raw.length = Std.int( Math.max( flash.system.ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH , l ) );
				#else
					raw = new ByteArray( l );
				#end
			}else
				raw = r;
				
			_iOffset = 0;
		}
	
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getOffset( l : Int ) : Int {
			return _iOffset += l;
		}
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function select( ) : Void {
			Memory.select( raw );
		}	
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function reset( ) : Void {
			for( i in 0...raw.length )
				raw[ i ] = 0;
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function get( addr : Int ) : T {
			return null;
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function set( addr : Int , value : T ) : Void {
			
		}

	// -------o protected
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		inline private function _getAddr( i : Int ) : Int {
			return i;
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */
class MemoryByte extends MemRange<Int>{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( l : Int , raw : ByteArray = null ) {
			super( l , raw );
		}
	
	// -------o public
				
		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function get( addr : Int ) : Int {
			return Memory.getByte( addr );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function set( addr : Int , value : Int ) : Void {
			
			//debug
				#if debug
					if ( value < 0 || value > 255 )
						throw new Error( );
				#end
				
			Memory.setByte( addr , value );
			
		}

	// -------o protected
	
		

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */
class MemoryInt extends MemRange<Int> {

	public var type( default , default ) : MemoryIntTypes;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( t : MemoryIntTypes , l : Int , raw : ByteArray = null ) {
			this.type = t;
			super( l , raw );
		}
	
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function get( addr : Int ) : Int {		
			return switch( this.type ) {
				
				case INT16:
					Memory.getUI16(  _getAddr( addr ) );
				
				case INT32:
					Memory.getI32(  _getAddr( addr ) );

				case BYTE:
					Memory.getByte(  _getAddr( addr ) );
				
			}
			
		}	
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function set( addr : Int , value : Int ) : Void {
			switch( this.type ) {
				
				case INT16:
					Memory.setI16( _getAddr( addr ) , value );
				
				case INT32:
					Memory.setI32( _getAddr( addr ) , value );
				
				case BYTE:
					Memory.setByte( _getAddr( addr ) , value );
				
			}
		}

	// -------o protected
	
		

	// -------o misc
	
}

enum MemoryIntTypes {
	INT16;
	INT32;
	BYTE;
}