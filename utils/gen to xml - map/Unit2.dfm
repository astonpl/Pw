object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 539
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 239
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 225
    Height = 465
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object Memo2: TMemo
    Left = 328
    Top = 16
    Width = 345
    Height = 457
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object Button2: TButton
    Left = 598
    Top = 479
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
  end
end
