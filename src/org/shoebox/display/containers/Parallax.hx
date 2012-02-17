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
package org.shoebox.display.containers;

	import org.shoebox.geom.AABB;

	import nme.display.BitmapData;
	import nme.display.IBitmapDrawable;
	import nme.display.Sprite;
	import nme.filters.BitmapFilter;
	import nme.geom.Matrix;
	import nme.errors.Error;
	import nme.Lib;
	
	/**
	* Parallax
	* @author shoebox
	*/
	class Parallax extends Sprite{
	
		private var _iLayersCount		: Int;
		private var _fMaxRight			: Float;
		private var _lPrimary			: ParallaxLayer;
		private var _aLayers			: Array<ParallaxLayer>;
		
		// -------o constructor
		
			/**
			* Constructor of the Parallax class
			*
			* @public
			* @return	void
			*/
			public function new() : Void {
				super( );
				_aLayers = new Array<ParallaxLayer>( );
				_iLayersCount = 0;
				_fMaxRight = 999999999;
			}

		// -------o public
			
			/**
			* addLayer function
			* @public
			* @param 
			* @return
			*/
			public function addLayer( 
										display     : BitmapData,
										bPrim       : Bool			= false ,
										bLoop       : Bool			= false ,
										speedFactor : Float			= 1.0,
										dx          : Int			= 0 , 
										dy          : Int 			= 0 , 
										fScaleX     : Float 		= 1.0,
										fScaleY     : Float 		= 1.0,
										limits      : AABB = null							
									) : Void {
				
				var layer : ParallaxLayer = new ParallaxLayer ( display , speedFactor ,  bLoop , limits );
					layer.setTransform( dx , dy , fScaleX , fScaleY );
				
				addChild( layer );

				if( !bPrim )
					_aLayers.push( layer );
				else
					_lPrimary = layer;
				
				_iLayersCount++;
			}
			
			/**
			* dispose function
			* @public
			* @param 
			* @return
			*/
			public function dispose() : Void {
				
				for( layer in _aLayers ){
					layer.dispose( );	
					layer = null;
				}
				
				_aLayers = null;
				
			}
			
			/**
			* update function
			* @public
			* @param 
			* @return
			*/
			public function update( dx : Float , dy : Float = 0 ) : Bool {
				
				if( !_lPrimary.translate( dx , dy ) )
					return false;

				for( l in _aLayers ){
					l.translate( dx , dy );
				}
				
				return true;
				
			}
			
			
			
		// -------o private
			
		// -------o misc

	}
