package org.shoebox.display;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Stage;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.StageAlign;
import nme.geom.Rectangle;

import org.shoebox.geom.AABB;

/**
 * ...
 * @author shoe[box]
 */

class BoxDisplay{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function haxeStage( d : DisplayObject ) : nme.display.Stage {
			return nme.Lib.current.stage;		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function getStageW( d : DisplayObject ) : Int {
			return nme.Lib.current.stage.stageWidth;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function getStageH( d : DisplayObject ) : Int {
			return nme.Lib.current.stage.stageHeight;						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function purge( d : DisplayObjectContainer ) : Array<Dynamic> {
			var a = [ ];
			while( d.numChildren > 0 ){
				var child = d.getChildAt( 0 );
				a.push( d );
				d.removeChild( child );
			}

			return a;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function distribute( d : DisplayObjectContainer , iMargin : Int , ?bHor : Bool ) : Void {
			DisplayFuncs.distribute_childs( d , iMargin , bHor );						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function align( d : DisplayObject , ?dx : Int, ?dy : Int , ?where : StageAlign , ?bounds : AABB ) : Void {
			org.shoebox.display.DisplayFuncs.align( d , bounds , where , dx , dy );		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function centerX( d : DisplayObject ) : Void {
			align( d , 0 , 0 , StageAlign.TOP );						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline static public function alignIn( target : DisplayObject , container : DisplayObject ) : Void {
			DisplayFuncs.align_in_container( target ,container );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function rasterize( target : DisplayObject , ?bmp : BitmapData , ?iMarginX : Int , ?iMarginY : Int ) : BitmapData {
			
			var w = Std.int( target.width + iMarginX * 2 );
			var h = Std.int( target.height + iMarginY * 2 );

			var mat = new nme.geom.Matrix( );
				mat.tx = iMarginX;
				mat.ty = iMarginY;

			if( bmp == null || bmp.width != ( target.width + iMarginX * 2 ) || bmp.height != ( target.height + iMarginY * 2 ) )
				bmp = new BitmapData( w , h , true , 0 );
				bmp.unlock( );				
				bmp.draw( target , mat );
				bmp.lock( );

			return bmp;

		}


	// -------o protected
	
		

	// -------o misc
	
}
