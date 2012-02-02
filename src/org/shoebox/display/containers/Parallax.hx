/**
* This is about <code>Parallax</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/
package org.shoebox.display.containers;

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
										bLoop		: Bool				= false ,
										display		: BitmapData		,
										speedFactor : Float				= 1.0,
										dx 			: Int		 		= 0 , 
										dy 			: Int 				= 0 , 
										fScaleX		: Float 			= 1.0,
										fScaleY		: Float 			= 1.0										
									) : Void {
				
				var layer : ParallaxLayer = new ParallaxLayer ( display , speedFactor ,  bLoop );
					layer.setTransform( dx , dy , fScaleX , fScaleY );
				
				addChild( layer );
				_aLayers.push( layer );
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
				
				for( l in _aLayers ){
					l.translate( dx , dy );
				}
				
				return true;
				
			}
			
			
			
		// -------o private
			
		// -------o misc

	}
