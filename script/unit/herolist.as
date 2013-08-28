package  unit{
	import unit.hero;
	import flash.display.*;
	import flash.utils.*;
	public class herolist {
		public var list 	:Array;
		public var count	:Number;
		public var workbox	:MovieClip;
		public var owner ;
		public var interval;
		public function herolist(owner) {
			// constructor code
			this.owner  = owner;
			this.list 	= new Array();
			this.count 	= 0; 
			this.workbox = new MovieClip();
			owner.addChild(this.workbox);
			this.interval = setInterval(UpdatePlayers,25);
		}
		
		public function UpdatePlayers(){
			for(var i=0;i<count;i++){
				//trace(this.list[i].hname);
				this.list[i].updatePlayer();
			}
		}
		
		public function AddHero(HName :String,HModel :String,Hx :Number,Hy :Number,HData :Array){
			var h = new hero(this.owner,this.workbox,HName,HModel,Hx,Hy,HData);
			//h.goDown(10);
			this.list[this.count] = h;
			this.count++;
		}
		
		public function Move(HName :String,Step :Number,direction :Number){
			for(var i=0;i<this.count;i++){
				var pl:hero = this.list[i];
				if(pl.hname == HName){
					switch(direction){
						case 1:
							pl.goUp(Step);
							break;
						case 2:
							pl.goRight(Step);
							break;
						case 3:
							pl.goDown(Step);
							break;
						case 4:
							pl.goLeft(Step);
							break;
					}
					return true;
				}
			}
			return false;
		}

	}
	
}
