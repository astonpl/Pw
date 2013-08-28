package unit{
	import flash.display.*;
	public class map{
		var workbox :MovieClip;
		var sectors	:Array;
		var sectorsi:Array;
		var mapname :String = "aeria";
		var	x		:Number=0;
		var y		:Number=0;
		function map(root){
			trace('Crate map object')
			this.workbox = new MovieClip();
			root.addChild(this.workbox)
			this.initsectors()
			this.updatemap()
			//loadsector(5,1)
		}
		function initsectors(){
			this.sectors  = new Array();
			this.sectorsi = new Array()
			for(var i=0;i<9;i++){
				this.sectors[i]  = this.workbox.createEmptyMovieClip("map_sector_"+i,this.workbox.getNextHighestDepth())
				this.sectorsi[i] = "" 
			}
		}
	
		function translatesectors(){
			var offsetx = this.x % 800;
			trace(this.x);
			var offsety = this.y % 800;
			for(var i=0;i<8;i++){
				var x = (i%3)-1
				var y = Math.floor(i/3)-1
				this.sectors[i+1]._x = x*800+offsetx;
				this.sectors[i+1]._y = y*800+offsety;
				trace((i+1)+" : "+this.sectors[i+1]._x+" "+this.sectors[i+1]._y)
			}
		}
	
		function updatemap(){
			this.translatesectors()
			if(this.x > 0){
				var disx = Math.floor(-this.x/800);
			}else{
				var disx =  Math.ceil(-this.x/800);
			}
			if(this.y > 0){
				var disy = Math.floor(-this.y/800);
			}else{
				var disy =  Math.ceil(-this.y/800);
			}
			trace("DX "+disx+" DY"+disy)
			for(var i=0;i<8;i++){
				var x = (i%3)-1
				var y = Math.floor(i/3)-1
				var kx = disx+x+1;
				var ky = disy+y;
				if( (kx>=1) && (ky>=0) ){
				//trace((i+1)+" "+(ky*10+kx));
					loadsector(i+1,(ky*10+kx));
				}
			}
		}
	
		function loadsector(secid,imgid){
			if(this.sectorsi[secid] != imgid){
				if(imgid < 10){
					imgid = "0"+imgid;
				}
				this.sectors[secid].loadMovie("worlds/aeria/aeria_"+imgid+".png")
				this.sectorsi[secid] = imgid;
			}else{
				trace("ISLOADED")
			}
		}
	}
}
