package ;

import nme.Memory;
import nme.utils.ByteArray;

/**
 * ...
 * @author shoe[box]
 */

class BytesMemory{

	private var _baRaw : ByteArray;

	private var _length : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( l : Int , ba : ByteArray = null ) {
			
			_length	= l;

			if( ba == null ){
				#if flash
					_baRaw	= new ByteArray( );
					_baRaw.length = Std.int( Math.max( flash.system.ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH , l ));
				#else
					_baRaw = new ByteArray( l );
				#end
			}else
				_baRaw = ba;


		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function copy( ) : BytesMemory {
			var ba = new ByteArray( );
				ba.writeBytes( _baRaw , 0 , _baRaw.length );
				ba.position = 0;
			
			return new BytesMemory( _length , ba );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function fill( x : Int ) : Void {
			for( i in 0..._length )
				set( i , x );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function select( ) : Void {
			Memory.select( _baRaw );		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get( pos : Int ) : Int {
			return Memory.getByte( pos );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function set( pos : Int , val : Int ) : Void {
			Memory.setByte( pos , val );						
		}

	// -------o protected
	
		

	// -------o misc
	
}