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

import nme.errors.Error;

/**
 * ...
 * @author shoe[box]
 */

class ObjectPool<T>{

	private var _aContent  : Array<T>;
	private var _cClass    : Class<T>;
	private var _iAllocate : Int;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( cClass : Class<T> ) {
			_cClass   = cClass;
			_aContent = [ ];
			_iAllocate = 0;
		}
	
	// -------o public
		
		/**
		* Get a T instance from the ObjectPool
		* 
		* @public
		* @return	void
		*/
		inline public function get( ) : T {
			_iAllocate--;
			if( _aContent.length == 0 )
				return _create( );

			return _aContent.shift( );
		}

		/**
		* Repool a T instance
		* 
		* @public
		* @param	d : Instance to be pooled ( T )
		* @return	void
		*/
		inline public function put( d : T ) : Void {
			_aContent.push( d );
			_iAllocate --;
		}

		/**
		* Dispose of the pool content
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			_aContent = null; 
		}

		/**
		* Getter of the remaining pool content
		* 
		* @public
		* @return	content of the Pool ( Array<T> )
		*/
		public function getContent( ) : Array<T> {
			return _aContent;
		}

	// -------o protected

		/**
		* Setter of the pool size
		* 
		* @private	
		* @param	i : New size of the Pool ( Int )
		* @return	new size ( Int )
		*/
		private function _setSize( i : Int ) : Int{
			return i;
		}

		/**
		* Create a new instance of the reference Class
		* 
		* @private
		* @return	new instance of T ( T )
		*/
		private function _create( ) : T{
			return Type.createInstance( _cClass , [ ] );
		}

	// -------o misc
	
}