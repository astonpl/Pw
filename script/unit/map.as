package unit{
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import unit.mapTile;
	import flash.system.*;
	import flash.geom.Point;
	import unit.result_mfw;

	public class map{
		public var workbox 	:MovieClip;
		public var sectors	:Array;
		public var mapname 	:String = "";
		public var x		:Number=0;
		public var y		:Number=0;
		public var owner;
		public var mapowner;
		public var boxarray	:Array;
		public var ready	:Boolean = false;
		public var lastline;
		var max_tiles:Number = 9;
		function map(mapname,root,mapowner){
			////trace('Crate map object');
			this.mapname = mapname;
			this.owner = root;
			this.workbox = new MovieClip();
			this.mapowner;
			mapowner.addChild(this.workbox)
			this.inithitbox();
			this.initsectors();
			this.updatemap();
		}
		
		public function free(){
			while(this.sectors.length>0){
				if(this.sectors[0].ml.parent != null){
					this.sectors[0].ml.parent.removeChild(this.sectors[0].ml);
				}
				this.sectors[0].ml.unloadAndStop()
				this.sectors[0].ml = null;
				this.sectors[0] = null;
				delete this.sectors[0];
				this.sectors.splice(0, 1);
			}
			this.sectors = null;
			this.mapowner.removeChild(workbox);
		}
		
		public function szukajdroge(Start:Point,Cel:Point):result_mfw{
			var mapA = new Array();
			for(var i=0;i<250;i++){
				mapA[i] = new Array();
				for(var j=0;j<250;j++){
					mapA[i][j] = -1;
				}
			}
			var res:result_mfw = new result_mfw(false,null);
			mapA[Start.x][Start.y] = 0;
			var q:Array = new Array();
			q.push(new Point(Start.x,Start.y));
			while(q.length > 0){
				var pa:Point = q[0];
				q.splice(0,1);
				var np:Point = new Point(0,0);
				//trace(pa.toString()+" WAGA "+mapA[pa.x][pa.y]);
				//trace(q.toString());
				if((pa.x == Cel.x) && (pa.y == Cel.y)){
					//zbieranie danych
					res.array = new Array();
					var myLine:Shape = new Shape();
					var aktp:Point = new Point(Cel.x,Cel.y);
					myLine.graphics.moveTo((Cel.x+0.5)*32+this.x,(Cel.y+0.5)*32+this.y);
					myLine.graphics.lineStyle(2,0xff0000);
					if(this.lastline != null){
						this.workbox.removeChild(lastline);
					}
					while( (aktp.x != Start.x) || (aktp.y != Start.y)){
						var waga = mapA[aktp.x][aktp.y];
						var nf:Boolean = false;
						if((aktp.x >=1) || (nf==false)){
							if(mapA[aktp.x-1][aktp.y] == (waga -1)){aktp.x=aktp.x-1;nf=true;}
						}
						if((aktp.y >=1) || (nf==false)){
							if(mapA[aktp.x][aktp.y-1] == (waga -1)){aktp.y=aktp.y-1;nf=true;}
						}
						if((aktp.x <=249) || (nf==false)){
							if(mapA[aktp.x+1][aktp.y] == (waga -1)){aktp.x=aktp.x+1;nf=true;}
						}
						if((aktp.y <=249) || (nf==false)){
							if(mapA[aktp.x][aktp.y+1] == (waga -1)){aktp.y=aktp.y+1;nf=true;}
						}
						if(nf==true){
							myLine.graphics.lineTo((aktp.x+0.5)*32+this.x,(aktp.y+0.5)*32+this.y);
							trace(aktp.toString());
							res.array.push(new Point(aktp.x,aktp.y));
							//roundObject.graphics.moveTo(aktp.x*32,aktp.y*32);
						}
					}
					this.workbox.addChild(myLine);
					this.lastline = myLine;
					//trace(roundObject);
					res.finded = true;
					//res.array  = mapA;
					return res;
				}
				//left
				if(pa.x >= 1){
					np.x = pa.x-1;
					np.y = pa.y;
					//trace(np.toString());
					if((mapA[np.x][np.y] == -1) && (this.boxarray[np.y][np.x] != 32)){
						mapA[np.x][np.y] = mapA[pa.x][pa.y]+1;
						q.push(new Point(np.x,np.y));
					}
				}
				//right
				if(pa.x <= 249){
					np.x = pa.x+1;
					np.y = pa.y;
					if((mapA[np.x][np.y] == -1) && (this.boxarray[np.y][np.x] != 32)){
						mapA[np.x][np.y] = mapA[pa.x][pa.y]+1;
						q.push(new Point(np.x,np.y));
					}
				}
				//top
				if(pa.y >= 1){
					np.x = pa.x;
					np.y = pa.y-1;
					if((mapA[np.x][np.y] == -1) && (this.boxarray[np.y][np.x] != 32)){
						mapA[np.x][np.y] = mapA[pa.x][pa.y]+1;
						q.push(new Point(np.x,np.y));
					}
				}
				//bottom
				if(pa.y <= 249){
					np.x = pa.x;
					np.y = pa.y+1;
					//trace(np.toString());
					if((mapA[np.x][np.y] == -1) && (this.boxarray[np.y][np.x] != 32)){
						mapA[np.x][np.y] = mapA[pa.x][pa.y]+1;
						q.push(new Point(np.x,np.y));
					}
				}

			}
			//szukajdalej(Start,Cel,mapA);
			trace("NO :"+mapA[Cel.x][Cel.y]);
			res.finded = false;
			return res;
		}
		
		public function onLoadBoxes(event:Event){
			var myXML:XML = new XML(event.target.data);
			for(var i=0;i<250;i++){
				var Line :String = myXML.line[i].toString();
				var LineA:Array  = Line.split(',');
				//trace(LineA);
				this.boxarray[i] = LineA;
			}
			//trace('ODP:'+this.boxarray[2][1]);
			myXML = null;
			this.ready = true;
		}
		
		public function inithitbox(){
			this.boxarray = new Array();
			var loader:URLLoader = new URLLoader(new URLRequest("worlds/"+this.mapname+"/box.xml"));
			loader.addEventListener(Event.COMPLETE, this.onLoadBoxes);
		}
		
		public function movemap(rx:Number,ry:Number){
			this.x = x-rx;
			this.y = y-ry;
			if(this.x > 0){
				this.x = 0;
			}
			if(this.y > 0){
				this.y = 0;
			}
			if(this.x < -7200){
				this.x = -7200;
			}
			if(this.y < -7400){
				this.y = -7400;
			}
			this.updatemap();
		}
		function initsectors(){
			this.sectors  = new Array();
		}
	
		function translatesectors(){
			////trace("przesuwam");
			var offsetx = this.x % 800;
			var offsety = this.y % 800;
			var disx = 0;
			var disy = 0;
			if(this.x > 0){
				disx =   Math.floor(-this.x/800);
			}else{
				disx =  -Math.ceil(this.x/800);
			}
			if(this.y > 0){
				disy =   Math.floor(-this.y/800);
			}else{
				disy =  -Math.ceil(this.y/800);
			}
			for(var i=0;i<9;i++){
				var x = (i%3)-1
				var y = Math.floor(i/3)-1
				var kx = disx+x;
				var ky = disy+y;
				this.loadSectors(kx,ky);
			}
			for(i=0;i<this.sectors.length;i++){
				this.ustawbyid(i);
			}
		}
		
		function loadSectors(kx,ky){
			////trace("==========");
			if( (kx < 0) || (ky < 0) || (ky > 9) || (kx > 9) ){
				return 0;
			}
			var find :Boolean = false;
			for(var i=0;i<this.sectors.length;i++){
				if ( (sectors[i].tx == kx) && (sectors[i].ty == ky) ){
					find = true;
					break;
				}
			}
			if( (find == false) && ( (kx >= 0) && (ky >= 0 ) ) ){
				//trace("Dla elementu :"+kx+" "+ky);
				createTile(kx,ky);
			}   
		}
		
		function createTile(kx,ky){
			if( (kx < 0) || (ky<0) ) {
				return 0;
			}
			//trace("Tworze segment "+kx+" "+ky);
			//trace("utworzylem");
			var lasti = this.sectors.length;
			this.sectors[lasti] = new mapTile();
			this.sectors[lasti].tx = kx;
			this.sectors[lasti].ty = ky;
			// S: Odpowiadzialna za dobranie textury
			var imgid = (ky*10+kx+1);
			/*function onLoaderReady(e:Event) {
      				xa.addChild(lo);
					////trace("Wczytalem")
			}*/
			if(imgid < 10){
					imgid = "0"+imgid;
			}
			var fileRequest :URLRequest = new URLRequest("worlds/"+this.mapname+"/"+this.mapname+"_"+imgid+".png");
			var lo			:Loader    = new Loader();
			//lo.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{ xa.addChild(lo);xa = null;lo = null }, false);
			lo.contentLoaderInfo.addEventListener(Event.COMPLETE,onL,false,0,true);
			lo.load(fileRequest);
			this.sectors[lasti].nm = imgid;
			this.sectors[lasti].ml = lo;
			this.ustawbyid(lasti);
			fileRequest = null;
		}
		function onL(e:Event):void{ 
				this.workbox.addChild(e.target.loader);
				//trace(e.target);
				e.target.removeEventListener(Event.COMPLETE,onL);
				//trace("odebralem");
				//event.target.lo = null; 
		}
		function ustawbyid(id){
			var offsetx = this.x % 800;
			var offsety = this.y % 800;
			var tx = this.sectors[id].tx;
			var ty = this.sectors[id].ty;
			var sx = Math.floor(-this.x / 800);
			var sy = Math.floor(-this.y / 800);
			////trace("SRODEK x:"+sx+" y:"+sy);
			var rx = sx-tx;
			var ry = sy-ty;
			this.sectors[id].ml.x = -(rx*800-offsetx);
			this.sectors[id].ml.y = -(ry*800-offsety);
			////trace("USTAWILEM :"+this.sectors[id].nm+" na "+this.sectors[id].ml.x+" "+this.sectors[id].ml.y);
		}
		
		function zwolnij(){
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
			if(this.sectors.length > max_tiles){
				for(var i=0;i<this.sectors.length;i++){
					if( (Math.abs(this.sectors[i].tx - disx) > 1) || (Math.abs(this.sectors[i].ty - disy) > 1)){ 
						/*BUG FIX:
							czasami sie kraszuje na tym przy przewijaniu
						this.workbox.removeChild(this.sectors[i].ml);
						*/
						//trace(this.sectors[i].ml);
						//this.workbox.
						if(this.sectors[i] != null){
						if(this.sectors[i].ml.parent != null){
							this.sectors[i].ml.parent.removeChild(this.sectors[i].ml);
						}
						this.sectors[i].ml.unloadAndStop()
						this.sectors[i].ml = null;
						this.sectors[i] = null;
						delete this.sectors[i];
						this.sectors.splice(i, 1);
						}
						//trace(this.sectors.toString());
					}
				}
			}
			////trace("ZWALNIANIA SRODEK "+disx+" "+disy+" ");
		}
		function updatemap(){
			this.translatesectors()
			this.zwolnij()
		}
	}
}
