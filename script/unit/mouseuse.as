package  unit{
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.display.MovieClip;

	public class mouseuse {
		public var oldx:Number = 0;
		public var oldy:Number = 0;
		public var isup:Boolean = false;
		public var owner;
		var t;
		public var cursor:gui_debug32x32_mc;
		public var workbox:MovieClip;
		public var movemap:Boolean = false;
		public function mouseuse(owner) {
			// constructor code
			owner.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
			owner.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
			owner.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			this.workbox = new MovieClip();
			owner.addChild(this.workbox);
			this.cursor = new gui_debug32x32_mc();
			this.workbox.addChild(this.cursor);
			//ukrycie pierwsze kursora
			this.cursor.x = -32;
			this.cursor.y = -32;
			this.owner = owner;
		}
		function mouseMove(event:MouseEvent){
			if(this.isup == false){
				return 0;
			}
			var nx = this.owner.mouseX;
			var ny = this.owner.mouseY;
			var rx:Number = nx-this.oldx;
			var ry:Number = ny-this.oldy;
			if( (Math.abs(rx) >= 32) || (Math.abs(ry) >= 32) || (this.movemap) ){
				this.movemap = true;
				this.cursor.x = -32;
				this.cursor.y = -32;
				this.owner.mp.movemap(-rx,-ry);
				this.oldx =  this.owner.mouseX;
				this.oldy =  this.owner.mouseY;
			}
		}
		function mouseDown(event:MouseEvent){
			this.oldx = this.owner.mouseX;
			this.oldy = this.owner.mouseY;
			this.isup = true;
		}
		function mouseUp(event:MouseEvent){
			//Zazczacz miejsce
			if(this.movemap == false){
				var p:Point = new Point(this.owner.mouseX,this.owner.mouseY);
				p.x = Math.ceil((p.x-this.owner.mp.x)/32)-1;
				p.y = Math.ceil((p.y-this.owner.mp.y)/32)-1;
				trace(p.toString());
				this.cursor.x =p.x*32 +this.owner.mp.x;
				this.cursor.y =p.y*32 +this.owner.mp.y;
				//speed test
				var beforeTime = getTimer();
				var odpowiedz:result_mfw = owner.mp.szukajdroge(new Point(5,5),p);
				trace("FIND : "+odpowiedz.finded);
				var afterTime = getTimer();
				var measure = afterTime - beforeTime;
				this.t = measure;
			}
			this.isup = false;
			this.movemap = false;
		}
	}
	
}
