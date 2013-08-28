package  unit{
	import flash.text.*;
	import flash.system.*;
	import flash.utils.*;
	public class debugos {
		public var owner;
		public var debug_memoryuse:TextField;
		public var debug_tilecount:TextField;
		public var debug_herocount:TextField;
		public var debug_waytime  :TextField;
		public function debugos(owner) {
			this.owner = owner;
			this.debug_memoryuse = new TextField();
			this.debug_tilecount = new TextField();
			this.debug_herocount = new TextField();
			this.debug_waytime   = new TextField();
			this.owner.addChild(this.debug_memoryuse);
			this.owner.addChild(this.debug_tilecount);
			this.owner.addChild(this.debug_herocount);
			this.owner.addChild(this.debug_waytime);
			this.debug_waytime.x   =0
			this.debug_waytime.y   = 36;
			this.debug_waytime.width   = 300;
			this.debug_memoryuse.x = 0;	
			this.debug_memoryuse.y = 12;
			this.debug_herocount.x = 0;
			this.debug_herocount.y = 24;
			this.debug_herocount.width = 300;
			this.debug_memoryuse.width = 300;
			this.debug_tilecount.x = 0;
			this.debug_tilecount.y = 0;
			this.debug_tilecount.width = 300;
			setInterval(this.updatedebug,100);
		}
		
		function updatedebug(){
			//TileCount
			if(this.owner.mp != null){
				this.debug_tilecount.text = "Tiles count loaded : "+this.owner.mp.workbox.numChildren;
			}
			//Memory Usage
			var mem:String = Number( System.totalMemory / 1024/ 1024 ).toFixed(2) +"Mb";
			this.debug_memoryuse.text = "Memory used: "+mem;
			//hero list
			this.debug_herocount.text = "Hero count loaded : "+this.owner.hl.count;
			this.debug_waytime.text   = "Last find way time: "+this.owner.mu.t;
			
		}

	}
	
}
