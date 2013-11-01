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
class MemGraph {
	
	public var mem : MemoryInt;
	
	private var _iLength : Int;
	private var _iOffset : Int;
	private var _iPos_len : Int;
	private var _iMax_links : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( 
								length : Int , 
								maxLinks : Int , 
								offset : Int = 0 , 
								raw : MemoryInt
							) {
			_iOffset = offset;
			_iLength = length;
			_iMax_links = maxLinks;
			_iPos_len = length * maxLinks + _iOffset;
			setRaw( raw );
		}
	
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setRaw( raw : MemoryInt ) : Void {
			mem = raw;
			mem.select( );	
		}
	
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
		* Add Mutual links between two nodes
		*
		* @public
		* @return	void
		*/
		public function addMutual( from : Int , to : Int ) : Void {
			add( from , to );
			add( to , from );
		}
		
		/**
		* Add link between two nodes
		*
		* @public
		* @return	void
		*/
		public function add( from : Int , to : Int ) : Void {
			//trace('add $from >> $to');
			
			//Cannot create a link if the nodes ids are the same
				#if debug
					if ( from == to )
						throw new Error("The nodes are the same");			
				#end
				
			//Does the links already exists ?
					if ( has( from , to ) )
						return;
				
			//Links limit by node
				var iCount = getLinks_count( from );
				if ( iCount >= _iMax_links )
					throw new Error("Max links limit");
			
			//The position
				mem.set( getPos( from , iCount++ ) , to );		
				
			//The new links count for the node
				setLinks_count( from , iCount );
				//tracePos( from );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function has( from : Int , to : Int ) : Bool {
			
			//Links count for node
				var iCount = getLinks_count( from );
			
			//Is there a link at node ?
				if ( iCount == 0 )
					return false;
			
			//Has a link ??
				var bRes = false;
				for ( i in 0...iCount ) {
					if ( mem.get( getPos( from , i ) ) == to ) {
						bRes = true;
						break;
					}
				}
				
			return bRes;			
		}
		
		/**
		* Remove a nodes and all connected links
		*
		* @public
		* @return	void
		*/
		public function remove( from : Int , to : Int ) : Bool {
			
			//Links count for node
				var iCount = getLinks_count( from );
			
			//Is there some links ?
				if ( iCount == 0 )
					return false;
					
			//Removing
				var iPos = -1;
				for ( i in 0...iCount ) {					
					if ( mem.get( getPos( from , i ) ) == to ){
						iPos = i;
						break;
					}					
				}
			
			//Si the node does not contains a link with that position
				if ( iPos == -1 )
					return false;
					
			//Moving the orthers
				for ( i in iPos...iCount )
						mem.set( getPos( from , i ) , mem.get( getPos( from , i + 1 ) ) );
			
			//changing the count
				setLinks_count( from , iCount - 1 );
		
			return true;
		}
		
		/**
		* Remove a node and all is connections
		*
		* @public
		* @return	void
		*/
		public function removeNode( id : Int ) : Void {		
			
			//Links count for node
				var iCount = getLinks_count( id );
						
			//
				var iTo : Int;
				for ( i in 0...iCount ) {
					iTo = mem.get( getPos( id , i ) );
					remove( iTo , id );
				}
				
			//
				setLinks_count( id , 0 );
		}
		
		/**
		* Return the number of links for the node
		*
		* @public
		* @return	void
		*/
		public function getLinks_count( id : Int ) : Int {			
			return mem.get( _iPos_len + id );			
		}
		
		/**
		* Set the number of links for the node
		*
		* @public
		* @return	void
		*/
		public function setLinks_count( id : Int , count : Int ) : Void {
			mem.set( _iPos_len + id , count );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function tracePos( id : Int ) : Void {			
			var iCount = getLinks_count( id );
			var sRes = '$iCount = [ ';
			for ( i in 0...iCount )
				sRes += mem.get( getPos( id , i ) )+" ";
			trace('tracePos( $id = $iCount ) ------------  ' + sRes + "]" );
		}
		
		/**
		* Get a node / links position
		*
		* @public
		* @return	void
		*/
		public function getPos( id : Int , i : Int ) : Int {
			return id * _iMax_links + i + _iOffset;
		}

	// -------o protected
	

	// -------o misc
	
}