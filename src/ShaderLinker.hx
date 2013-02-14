/**
 * ...
 * @author shoe[box]
 */

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
class ShaderLinker{

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
		static public function build( ) : Array<Field>{

			var oLocalClass = haxe.macro.Context.getLocalClass( ).get( );

			
			
			var fields = haxe.macro.Context.getBuildFields( );	
			
			var bValid = false;
			var sFileName;
			for( f in fields ){
				
				if( f.meta == null )
					continue;
				
				//Meta
					bValid = false;
					for( m in f.meta ){
						if( m.name == "shader"){
							sFileName = _convertExpr_to_string( m.params[ 0 ] );
							bValid = true;
						}
					}

				//
					if( !bValid )
						continue;

				//
					switch( f.kind ){

						case FFun( f ):

						case FProp( get , set , t , e ):

						case FVar( t , e ):
							Sys.println("[ShaderLinker] Variable : "+f.name+"\tShader : "+sFileName+"\tClass : "+_getFull_class_name( oLocalClass ));
							e.expr = EConst( CString( getFile_content( sFileName ) ) );
							

					}

				//trace( sFileName );
			}
			
			return fields;
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _convertExpr_to_string( e : Expr ) : String{

			return switch( e.expr ){

				case EConst( c ):
					switch( c ){
						case CString( s ) : 
							s;

						default: 
							null;
					}

				default : null;
			}
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function getFile_content( sPath : String ) : String{
			return sys.io.File.getContent( sPath );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _getFull_class_name( ofClass : ClassType ) : String{
			return ofClass.pack.join(".")+((ofClass.pack.length == 0) ? "" : ".")+ofClass.module;
		}

	// -------o misc
	
}