package  unit{
	import flash.net.Socket;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.errors.*;
	
	public class gameconnection {
		var soc:Socket;
		var owner:MovieClip;
		
		function trim( s:String ):String
		{
  			return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
		}

		public function gameconnection(owner) {
			trace('1.0b - a');
			// constructor code
			this.owner = owner;
			this.soc = new Socket();
			try{
			this.soc.connect('10.0.0.42',44550);
			}catch(e:IOError){
				trace(e);
			}
			//this.soc.writeUTFBytes('<policy-file-request/>');
			//this.soc.flush();
			this.soc.addEventListener(ProgressEvent.SOCKET_DATA,this.onRecive);
			setTimeout(sendbuff('ClientVersion','1.0b'),1000);
		}
		
		function onRecive(event:ProgressEvent){
			var msg = (this.soc.readUTFBytes(this.soc.bytesAvailable));
			interpretuj(msg);
		}
		
		public function sendbuff(prot:String,	msg:String){
			//this.owner.edit_login.text = prot+":"+msg+"\n";
			try {
				this.soc.writeUTFBytes(prot+":"+msg+"\n");
				this.soc.flush();
        	}catch(e:IOError) {
            	trace(e);			
			}
			
		}
		function interpretuj(msg :String){
			var lines:Array    = msg.split(String.fromCharCode(13)+String.fromCharCode(10));
			for(var i=0;i<lines.length;i++){
				if(trim(lines[i]) == ''){
					continue;
				}
				var commands:Array = lines[i].split(':');
				trace('Odebrano :'+commands.toString());
				if (commands[0] == 'ReClientVersion') {
					rec_ClientVersion(commands);
					return true;
				}
				if (commands[0] == 'ReClientLogin') {
					rec_ClientLogin(commands);
					return true;
				}
				if (commands[0] == 'ReMapUpdate') {
					rec_Map(commands);
					return true;
				}
			}
		}
		
		function rec_Map(c:Array){
			if(this.owner.mp != null){
				this.owner.mp.free();
				trace('Czyszczenie mapy');
			}
			//
			
			//
			this.owner.mp = new map(c[1],this.owner,this.owner.mapwork);
			trace('tworze');
		}
		
		function rec_ClientLogin(c:Array){
			if(c[1] == 'OK'){
				this.owner.gotoAndPlay(1,"Gra");
			}
		}
		
		function rec_ClientVersion(c:Array){
			if(c[1] != 'OK'){
				this.owner.version_info.text = 'New updates avaible';
			}else{
				this.owner.version_info.text = 'Ready to play !';
				this.owner.bt_login.visible = true;
			}
		}
	}
}
