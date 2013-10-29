package org.shoebox.datas.structures;

import flash.errors.Error;
import flash.display.Bitmap;
import flash.utils.ByteArray;
import org.shoebox.datas.structures.MemRange.MemoryInt;
import org.shoebox.datas.structures.MemRange.MemoryIntTypes;

/**
 * ...
 * @author shoe[box]
 */
class MemGraph{

	public var mem : MemoryInt;
	
	private var _iMax_links : Int;
	private var _iLength : Int;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( length : Int , maxLinks : Int , offset : Int = 0 , ?raw : ByteArray , ?t : MemoryIntTypes ) {
			
			if ( t == null )
				t = MemoryIntTypes.BYTE;
			
			_iLength = length;
			_iMax_links = maxLinks;
			mem = new MemoryInt( t , _iLength * ( maxLinks + 1 ) , raw , offset );
			mem.select( );
		}
	
	// -------o public
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function reset( ) : Void {
			mem.reset( );
		}
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function addMutual( from : Int , to : Int ) : Void {
			add( from , to );
			add( to , from );
		}	
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function removeMutual( from : Int , to : Int ) : Void {
			remove( from , to );
			remove( to , from );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function add( from : Int , to : Int ) : Void {
			
			//Cannot create a link if the nodes ids are the same
				#if debug
					if ( from == to )
						throw new Error("The nodes are the same");			
				#end
				
			//Maximal links count by node
				var iCount = _getLinks_count( from );
				if ( iCount >= _iMax_links )
					throw new Error("Max links limit");
			
			//
				iCount++;
									
			//Stocking the new link
				var p = _getPosition( from , iCount );
				mem.set( p , to );
				
			//Stocing the new links count
				mem.set( _getPosition( from ) , iCount );
				
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function has( from : Int , to : Int ) : Bool {
			
			//Link count for the node
				var iCount = _getLinks_count( from );
								
			//Testing the links
				var bRes = false;
				var iPos : Int;
				for ( i in 0...iCount ) {
					
					//The link position
						iPos = _getPosition( from , i + 1 );
						
					//Link already exists ?
						if ( mem.get( iPos ) == to ){
							bRes = true;
							break;
						}
					
				}
				
			return bRes;
		}
		
		/**
		* Remove a link between to nodes
		*
		* @public
		* @return	void
		*/
		public function remove( from : Int , to : Int ) : Void {
			
			//The links count for the node
				var iCount = _getLinks_count( from );
			
			//Link exists ?
				#if debug
					if ( iCount == 0 || !has( from , to ) )
						throw new Error("Cannot remove a inexisting link");
				#end
			
			//
				var iPos : Int;
				var iIndex : Int = -1;
				for ( i in 0...iCount ) {
					
					//The link position
						iPos = _getPosition( from , i + 1 );
						
					//Link already exists ?
						if ( mem.get( iPos ) == to ){
							iIndex = i;
							break;
						}
					
				}
				
			//
				for ( i in iIndex...iCount )
					mem.set( _getPosition( from , i ) , mem.get( _getPosition( from , i + 1 ) ));
			
			//
				for ( i in iCount..._iMax_links )
					mem.set( _getPosition( from , i ) , 0 );
		
		}

	// -------o protected
		
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _setLinks_count( iNode : Int , count : Int ) : Void {
			mem.set( _getPosition( iNode ) , count );
		}
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getLinks_count( iNode : Int ) : Int {
			return mem.get( _getPosition( iNode ) );
		}
		
		/**
		*
		*
		* @private
		* @return	void
		*/
		inline private function _getPosition( iNode : Int , p : Int = 0 ) : Int {
			return iNode * _iMax_links + p;
		}

	// -------o misc
	
}