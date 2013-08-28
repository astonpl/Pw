object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 468
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 738
    Height = 468
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object ss: TIdTCPServer
    Bindings = <>
    DefaultPort = 44550
    OnConnect = ssConnect
    OnDisconnect = ssDisconnect
    OnExecute = ssExecute
    Left = 392
    Top = 16
  end
  object IdTCPServer1: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 843
    OnConnect = IdTCPServer1Connect
    OnExecute = IdTCPServer1Execute
    Left = 432
    Top = 16
  end
end
