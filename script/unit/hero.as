package  unit{
	import flash.display.Loader;
	import flash.display.MovieClip;
	public class hero {
		public var hlo;
		public var hdata	:Array;
		public var hx		:Number;
		public var hy		:Number;
		public var nx		:Number;
		public var ny		:Number;
		public var hname	:String;
		public var hmodel	:String;
		public var wb		:MovieClip;
		public var is_move  :Boolean = false;
		public var direction:Number  = 3;// 1up,2right,3bottom,4left
		public var speed    :Number = 2;
		public var owner;
		
		public function hero(owner,WorkBox:MovieClip,HName :String,HModel :String,Hx :Number,Hy :Number,HData :Array) {
			this.owner  = owner;
			this.wb		= WorkBox;
			this.hname 	= HName;
			this.hmodel = HModel;
			this.hdata	= HData;
			if(HModel == "char_ash"){ 
				this.hlo = new char_ash() 
			}
			WorkBox.addChild(this.hlo);
			setpos(Hx,Hy);
			this.repaint();
			////trace("NOWY CHIPEK");
		}
		
		public function updatePlayer(){
			////trace("update");
			if(this.is_move){
				this.move()
			}
			this.repaint();
		}
		
		public function move(){
			if(direction == 1){
				this.hy = this.hy-this.speed;
			}
			if(direction == 3){
				this.hy = this.hy+this.speed;
			}
			if(direction == 2){
				this.hx = this.hx+this.speed;
			}
			if(direction == 4){
				this.hx = this.hx-this.speed;
			}
			////trace(Math.floor(this.hy)+" "+ Math.floor(this.ny));
			if( (Math.floor(this.hy) == Math.floor(this.ny)) &&
				(Math.floor(this.hx) == Math.floor(this.nx))   ){
					if( this.direction == 1 ){ this.hlo.gotoAndPlay("stop_up"); }
					if( this.direction == 2 ){ this.hlo.gotoAndPlay("stop_right"); }
					if( this.direction == 3 ){ this.hlo.gotoAndPlay("stop_down"); }
					if( this.direction == 4 ){ this.hlo.gotoAndPlay("stop_left"); }
					this.is_move = false;
				}
		}
		
		
		
		public function goDown(count : Number){
			if(this.is_move){
				return false;
			}
			this.direction = 3;
			this.ny  = this.hy+count*32;
			this.hlo.gotoAndPlay("mov_down");
			this.is_move =true;
		}
		public function goUp(count : Number){
			if(this.is_move){
				return false;
			}
			this.direction = 1;
			this.ny  = this.hy-count*32;
			this.hlo.gotoAndPlay("mov_up");
			this.is_move =true;
		}
		public function goLeft(count : Number){
			if(this.is_move){
				return false;
			}
			this.direction = 4;
			this.nx  = this.hx-count*32;
			this.hlo.gotoAndPlay("mov_left");
			this.is_move =true;
		}
		public function goRight(count : Number){
			if(this.is_move){
				return false;
			}
			this.direction = 2;
			this.nx  = this.hx+count*32;
			this.hlo.gotoAndPlay("mov_right");
			this.is_move =true;
		}
		
		public function setpos(Hx :Number,Hy :Number){
			this.hx		= Hx;
			this.hy		= Hy;
			this.nx     = Hx;
			this.ny     = Hy;
			this.is_move = false;
		}
		
		public function repaint(){
			this.hlo.x = this.hx + this.owner.mp.x;
			this.hlo.y = this.hy-16 + this.owner.mp.y;
		}
		
		public function dest(){
			this.wb.removeChild(this.hlo);
		}

	}
	
}
