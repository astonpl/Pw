unit unit_packages;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer,IdContext, IdTCPConnection, IdTCPClient,IdGlobal,idBuffer,IniFiles;
type

  User = record
    hash  : string;
    login : string;
    ini   : TIniFile;
    thread: TIdContext;
  end;

implementation

end.
