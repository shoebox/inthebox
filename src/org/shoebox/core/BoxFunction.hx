package org.shoebox.core;

/**
 * ...
 * @author shoe[box]
 */

class BoxFunction{

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
		*  Memoize function ( see : http://haxe.org/doc/snip/memoize )
		*
		*	@param func : Target function ( Dynamic )
	  	*	@param maxSize : Hash max size ( Int )
		*	@return Dynamic The memoized function
		*/		
		public static function memoize(func:Dynamic , maxSize:Int = 100) : Dynamic {

			var arg_hash = new Map<String,Dynamic>();
			var f =  function(args:Array<Dynamic>){

				var arg_string = args.join('|');
				if (arg_hash.exists(arg_string)) {
					
					return arg_hash.get(arg_string);

				}else{
					
					var ret = Reflect.callMethod({},func,args);
					if( Lambda.count(arg_hash) < maxSize ) 
						arg_hash.set( arg_string , ret );

					return ret;
				}
			}

			f = Reflect.makeVarArgs(f);
			return f;
		}


	// -------o protected
	
		

	// -------o misc
	
}