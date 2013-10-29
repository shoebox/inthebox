package org.shoebox.datas.structures;	

import flash.Memory;
import flash.utils.ByteArray;



/**
 * ...
 * @author shoe[box]
 */
class MemRange{
	
	public var offset : Int;
	
	public var raw : ByteArray;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( l : Int , r : ByteArray = null , offset : Int = 0 ) {
			if( r == null ){
				#if flash
					raw = new ByteArray( );
					raw.length = Std.int( Math.max( flash.system.ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH , l ) );
				#else
					raw = new ByteArray( l );
				#end
			}else
				raw = r;
				
			
			this.offset = offset;
		}
	
	// -------o public
				
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

	// -------o protected
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		inline private function _getAddr( i : Int ) : Int {
			return i + offset;
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */
class MemoryInt extends MemRange {

	public var type( default , default ) : MemoryIntTypes;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( t : MemoryIntTypes , l : Int , raw : ByteArray = null , offset : Int = 0 ) {
			this.type = t;
			super( l , raw , offset );
		}
	
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function get( addr : Int ) : Int {		
			addr = _getAddr( addr );
			return switch( this.type ) {
				
				case INT16:
					Memory.getUI16( addr );
				
				case INT32:
					Memory.getI32( addr );

				case BYTE:
					Memory.getByte( addr );
				
			}
			
		}	
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function set( addr : Int , value : Int ) : Void {
			addr = _getAddr( addr );
			//trace('set ::: $addr = $value');
			switch( this.type ) {
				
				case INT16:
					Memory.setI16( addr , value );
				
				case INT32:
					Memory.setI32( addr , value );
				
				case BYTE:
					Memory.setByte( addr , value );
				
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