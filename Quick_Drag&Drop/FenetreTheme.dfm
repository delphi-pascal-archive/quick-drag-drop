object FormSkin: TFormSkin
  Left = 490
  Top = 218
  BorderStyle = bsDialog
  Caption = 'Theme'
  ClientHeight = 352
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 16
    Caption = 'Select theme:'
    Transparent = True
  end
  object Auteur: TLabel
    Left = 10
    Top = 187
    Width = 37
    Height = 16
    Caption = 'Autor :'
    Transparent = True
  end
  object Copyright: TLabel
    Left = 10
    Top = 207
    Width = 57
    Height = 16
    Caption = 'Copyright'
    Transparent = True
  end
  object DateOfCreation: TLabel
    Left = 10
    Top = 226
    Width = 92
    Height = 16
    Caption = 'DateOfCreation'
    Transparent = True
  end
  object DateOfRevision: TLabel
    Left = 10
    Top = 246
    Width = 95
    Height = 16
    Caption = 'DateOfRevision'
  end
  object Website: TLabel
    Left = 10
    Top = 266
    Width = 50
    Height = 16
    Cursor = crHandPoint
    Caption = 'Website'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    OnClick = WebsiteClick
  end
  object Comment: TLabel
    Left = 10
    Top = 286
    Width = 306
    Height = 60
    AutoSize = False
    Caption = 'Comment'
    Transparent = True
    WordWrap = True
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 201
    Height = 145
    ItemHeight = 16
    Sorted = True
    TabOrder = 0
    OnClick = ListBox1Click
    OnDblClick = ListBox1DblClick
  end
  object Appliquer: TButton
    Left = 216
    Top = 32
    Width = 97
    Height = 25
    Caption = 'Apply'
    TabOrder = 1
    OnClick = AppliquerClick
  end
  object Valider: TButton
    Left = 216
    Top = 64
    Width = 97
    Height = 25
    Caption = 'View'
    TabOrder = 2
    OnClick = ValiderClick
  end
  object Annuler: TButton
    Left = 216
    Top = 96
    Width = 97
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = AnnulerClick
  end
end
