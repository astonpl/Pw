unit glowna;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer,IdContext, IdTCPConnection, IdTCPClient,IdGlobal,idBuffer,IniFiles,
  unit_packages;

type
  TStringArray = array of string;
  TForm2 = class(TForm)
    ss: TIdTCPServer;
    Memo1: TMemo;
    IdTCPServer1: TIdTCPServer;
    procedure ssConnect(AContext: TIdContext);
    procedure ssDisconnect(AContext: TIdContext);
    procedure ssExecute(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
    procedure send_SerwerOK(AContext: TIdContext);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Connect(AContext: TIdContext);
  private
    { Private declarations }
    procedure rec_ClientVersion(com:TStringList;AContext: TIdContext);
    procedure rec_ClientLogin(com:TStringList;AContext: TIdContext);
  public
    { Public declarations }
    procedure Log(txt : String);
    procedure SendP(AContext: TIdContext;Parms : TStringArray);
    procedure Interpretuj(com : TStringList;AContext: TIdContext);
    function LogujUsera(Login:String;A:TIdContext):string;
    procedure Zwolnij(Login:String);
    procedure UpdateMap(Login:String);
  end;

var
  Form2: TForm2;
  appdir : string;
  users  : array of user;
implementation

{$R *.dfm}

procedure TForm2.Zwolnij(Login:String);
var
  i : integer;
begin
  for i := 0 to length(users)-1 do
  if users[i].login = Login then
  begin
     users[i].login := '';
     exit;
  end;
end;

function TForm2.LogujUsera(Login:String;A:TIdContext):string;
var
  hash:string;
  i,last   :integer;
begin
  Zwolnij(Login);
  for i := 1 to 10 do
    hash := hash + chr(random(25)+65);
  last := length(users);
    hash := inttostr(last)+'/'+hash;
  setLength(users,last+1);
  users[last].hash  := hash;
  users[last].login := Login;
  users[last].ini   := TIniFile.Create(appdir+'accounts\'+Login+'.ini');
  users[last].thread:= A;
  LogujUsera := hash;
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStringList) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter     := Delimiter;
   ListOfStrings.DelimitedText := Str;
end;


procedure Tform2.Log(txt : String);
begin
  memo1.lines.add(txt);
end;
procedure TForm2.FormCreate(Sender: TObject);
begin
  appdir := ExtractFileDir(application.ExeName)+'\';
  ss.Active := true;
  if ss.Active then
    log('Serwer aktywny !');
end;

procedure Tform2.SendP(AContext: TIdContext;Parms : TStringArray);
var
  pck : string;
  i   : integer;
begin
  pck := '';
  for i := 0 to length(Parms)-1 do
    pck := pck + parms[i]+':';
  log('Send : '+pck);
  pck := pck +chr(13)+chr(10)+chr(0);
  AContext.Connection.IOHandler.WriteLn(pck);
  AContext.Connection.IOHandler.WriteBufferFlush;
end;

procedure TForm2.send_SerwerOK(AContext: TIdContext);
var
  pck    : TStringArray;
begin
  SetLength(pck,2);
  pck[0] := 'StatusServer';
  pck[1] := 'OK';
  sendP(AContext,pck);
end;

procedure TForm2.ssConnect(AContext: TIdContext);

begin
  log('Utowrzono nowe po³¹czenie :'+AContext.Connection.Socket.Binding.PeerIP);
  //send_SerwerOk(AContext);
end;

procedure TForm2.ssDisconnect(AContext: TIdContext);
begin
  memo1.Lines.Add('DC :'+AContext.Connection.Socket.Binding.PeerIP);
end;

procedure TForm2.ssExecute(AContext: TIdContext);
var
  RxBufStr: String; // not UTF8String
  command : TStringList;
  f:textfile;
  tf,buff : string;
begin
  with AContext.Connection.IOHandler do
  begin
    CheckForDataOnSource(10);
    if not InputBufferIsEmpty then
    begin
      command := TStringList.Create;
      InputBuffer.Encoding := IdGlobal.enUTF8;
      RxBufStr := InputBuffer.Extract();
      if(RxBufStr = '<policy-file-request/>'+chr(0))then
      begin
        log('policy!');
        assignFile(f,appdir+'crossdomain.xml');
        reset(f);
        tf := '';
        while(not(eof(f))) do
        begin
          system.readln(f ,buff);
          tf := tf+buff;
        end;
        tf := tf+chr(0);
        //AContext.Connection.IOHandler.WriteFile(appdir+'crossdomain.xml',false);
        AContext.Connection.IOHandler.WriteLn(tf);
        AContext.Connection.IOHandler.WriteBufferFlush;
        exit;
      end;
      log('Recive : '+RxBufStr);
      split(':',RxBufStr,command);
      command.Text := command.Text;
      interpretuj(command,AContext);
      command.Free;
      RxBufStr := RxBufStr;
    end;
  end;
end;

procedure TForm2.IdTCPServer1Connect(AContext: TIdContext);
begin
  log('Policy connection');
end;

procedure TForm2.IdTCPServer1Execute(AContext: TIdContext);
var
  RxBufStr: String; // not UTF8String
  f : textfile;
  buff,tf : string;
begin
  with AContext.Connection.IOHandler do
  begin
    CheckForDataOnSource(10);
    if not InputBufferIsEmpty then
    begin
      InputBuffer.Encoding := IdGlobal.enUTF8;
      RxBufStr := InputBuffer.Extract();
      log('Policy req :'+RxBufStr);
      assignFile(f,appdir+'crossdomain.xml');
        reset(f);
        tf := '';
        while(not(eof(f))) do
        begin
          system.readln(f ,buff);
          tf := tf+buff;
        end;
        tf := tf+chr(0);
        //AContext.Connection.IOHandler.WriteFile(appdir+'crossdomain.xml',false);
        AContext.Connection.IOHandler.WriteLn(tf);
        AContext.Connection.IOHandler.WriteBufferFlush;
    end;
  end;
end;

procedure TForm2.Interpretuj(com: TStringList;AContext: TIdContext);
begin
   if(com[0] = 'ClientVersion') then
   begin
     rec_ClientVersion(com,AContext);
     exit;
   end;
   if(com[0] = 'ClientLogin') then
   begin
     rec_ClientLogin(com,AContext);
     exit;
   end;
end;

procedure TForm2.rec_ClientVersion(com:TStringList;AContext: TIdContext);
var
  p : TStringArray;
begin
  SetLength(p,2);
  p[0] := 'ReClientVersion';
  if com[1] = '1.0b' then
    p[1] := 'OK'
  else
    p[1] := 'NO';
  sendp(AContext,p);
end;


procedure TForm2.rec_ClientLogin(com:TStringList;AContext: TIdContext);
var
  p: TStringArray;
  ini : TIniFile;
begin
  SetLength(p,3);
  p[0] := 'ReClientLogin';
  p[2] := '';
  com[1] := lowercase(com[1]);
  if not FileExists(appdir+'accounts\'+com[1]+'.ini') then    //Account dont exists
  begin
    p[1] := 'NO';
    self.SendP(AContext,p);
    exit;
  end;
  ini := TIniFile.Create(appdir+'accounts\'+com[1]+'.ini');
  if(ini.ReadString('account','password','~~~~~~') = com[2] )then
  begin
    p[1] := 'OK';
    p[2] := LogujUsera(com[1],AContext);
    self.SendP(AContext,p);
    self.UpdateMap(com[1]);
    exit;
  end
  else
  begin
    p[1] := 'NO';
    self.SendP(AContext,p);
    exit;
  end;
end;

procedure TForm2.UpdateMap(Login:String);
var
  i : integer;
  p : TStringArray;
begin
  setLength(p,2);
  p[0] := 'ReMapUpdate';
  for i := 0 to length(users)-1 do
  if users[i].login = Login then
  begin
    p[1] := users[i].ini.ReadString('account','map','ban');
    sendp(users[i].thread,p);
    exit;
  end;
    
end;

end.
