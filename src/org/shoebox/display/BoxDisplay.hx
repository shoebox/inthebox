package org.shoebox.display;

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
		inline static public function alignIn( target : DisplayObject , container : DisplayObject ) : Void {
			DisplayFuncs.align_in_container( target ,container );
		}


	// -------o protected
	
		

	// -------o misc
	
}