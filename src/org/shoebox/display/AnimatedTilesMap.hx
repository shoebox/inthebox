package org.shoebox.display;

import haxe.xml.Fast;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author shoe[box]
 */

class AnimatedTilesMap extends TilesMap{

	private var _hCyclesFrames : Hash<Array<Int>>;
	private var _hCyclesLen    : Hash<Int>;
	private var _hCustomCenter : Hash<Point>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( bmp : BitmapData ) {
			super( bmp );
			_hCyclesFrames = new Hash<Array<Int>>( );
			_hCyclesLen    = new Hash<Int>( );
			_hCustomCenter = new Hash<Point>( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getDefaultCycle( ) : String {
			return _hCyclesFrames.keys( ).next( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getCycleId( sCycle : String , frame : Int ) : Int {
			return _hCyclesFrames.get( sCycle )[ frame ];
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getCycleLen( sCycle : String ) : Int {
			return _hCyclesLen.get( sCycle );						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setCycleCenter( s : String , fx : Float , fy : Float ) : Void {
			_hCustomCenter.set( s , new Point( fx , fy ) );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function parseXML( sXml : String , fCenterX : Float = 0.0 , fCenterY : Float = 0.0 , fDecalX : Float = 0 , fDecalY : Float = 0 ) : Void {

			var x = Xml.parse( sXml );
			var f = new Fast( x.firstElement( ) );
			var a : Array<String>;

			var iLen   : Int;
			var iFrame : Int;
			var sCycle : String;
			var aIds   : Array<Int>;
			var rec    : Rectangle = new Rectangle( );
			var pt     : Point = new Point( fCenterX , fCenterY );
			for( s in f.nodes.SubTexture ){
				
				//
					a      = s.att.name.split('/');
					iFrame = Std.parseInt( a[ 1 ] );
					sCycle = a[ 0 ];

				//
					if( _hCyclesLen.exists( sCycle ) )
						iLen = _hCyclesLen.get( sCycle );
					else 
						iLen = 0;
						iLen++;

					_hCyclesLen.set( sCycle , iLen );

				//
					rec.x      = Std.parseFloat( s.att.x ) + fDecalX;
					rec.y      = Std.parseFloat( s.att.y ) + fDecalY;
					rec.width  = Std.parseFloat( s.att.width );
					rec.height = Std.parseFloat( s.att.height );
					
				//
					if( _hCyclesFrames.exists( sCycle ) )
						aIds = _hCyclesFrames.get( sCycle );
					else
						aIds = new Array<Int>( );

					if( _hCustomCenter.exists( sCycle ) )
						aIds[ iFrame ] = addByName( s.att.name , rec.clone( ) , _hCustomCenter.get( sCycle ) );
					else
						aIds[ iFrame ] = addByName( s.att.name , rec.clone( ) , pt );
					
					_hCyclesFrames.set( sCycle , aIds );
			}

		}

		
	// -------o protected
	
	// -------o misc
	
}