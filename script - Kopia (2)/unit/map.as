package unit{
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	public class map{
		var workbox :MovieClip;
		public var sectors	:Array;
		var sectorsi:Array;
		var mapname :String = "aeria";
		public var	x		:Number=-799;
		var y		:Number=-16;
		function map(root){
			trace('Crate map object')
			this.workbox = new MovieClip();
			root.addChild(this.workbox)
			this.initsectors()
			this.updatemap()
			sectors[5].rotate = 45
			//loadsector(5,1)
		}
		
		public function movemap(rx:Number,ry:Number){
			this.x = x-rx;
			this.y = y-ry;
			this.updatemap();
			for(var i=1;i<9;i++){
				trace(i+" "+this.sectorsi[i]);
			}
		}
		function initsectors(){
			this.sectors  = new Array();
			this.sectorsi = new Array()
			for(var i=0;i<=9;i++){
				this.sectors[i]  = new MovieClip();
				this.workbox.addChild(this.sectors[i])
				this.sectorsi[i] = "" 
			}
		}
	
		function translatesectors(){
			var offsetx = this.x % 800;
			var offsety = this.y % 800;
			var disx = 0;
			var disy = 0;
			if(this.x > 0){
				disx = Math.floor(-this.x/800);
			}else{
				disx =  -Math.ceil(this.x/800);
			}
			if(this.y > 0){
				disy =  Math.floor(-this.y/800);
			}else{
				disy =  -Math.ceil(this.y/800);
			}
			for(var i=0;i<9;i++){
				var x = (i%3)-1
				var y = Math.floor(i/3)-1
				var kx = disx+x+1;
				var ky = disy+y;
				trace("X:"+this.x.toString());
				if( (kx>=1) && (ky>=0) ){
					trace((i+1)+" "+(ky*10+kx));
					loadsector(i+1,(ky*10+kx));
				}
				this.sectors[i+1].x = x*800+offsetx;
				this.sectors[i+1].y = y*800+offsety;
				trace((i+1)+" : "+this.sectors[i+1].x+" "+this.sectors[i+1].y)
			}
		}
	
		function updatemap(){
			this.translatesectors()
			/*var disx = 0;
			var disy = 0;
			if(this.x > 0){
				disx = Math.floor(-this.x/800);
			}else{
				disx =  -Math.ceil(this.x/800);
			}
			if(this.y > 0){
				disy =  Math.floor(-this.y/800);
			}else{
				disy =  -Math.ceil(this.y/800);
			}
			trace(this.x)
			trace("DX "+disx+" DY"+disy)
			for(var i=0;i<9;i++){
				var x = (i%3)-1
				var y = Math.floor(i/3)-1
				var kx = disx+x+1;
				var ky = disy+y;
				if( (kx>=1) && (ky>=0) ){
				    trace((i+1)+" "+(ky*10+kx));
					loadsector(i+1,(ky*10+kx));
				}
			}*/
		}
	
		function loadsector(secid,imgid){
			function onLoaderReady(e:Event) {
					trace(xa);
      				xa.addChild(lo);
			}
			if(this.sectorsi[secid] != imgid){
				if(imgid < 10){
					imgid = "0"+imgid;
				}
				var fileRequest:URLRequest = new URLRequest("worlds/aeria/aeria_"+imgid+".png");
				var lo			:Loader    = new Loader()
				lo.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderReady);
				lo.load(fileRequest);
				//trace(lo.x);
				var xa = this.sectors[secid];
				this.sectorsi[secid] = imgid;
			}else{
				//trace("ISLOADED")
			}
		}
	}
}
