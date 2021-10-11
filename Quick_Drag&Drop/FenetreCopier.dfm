object FormCopier: TFormCopier
  Left = 274
  Top = 169
  BorderStyle = bsToolWindow
  Caption = 'Copying ...'
  ClientHeight = 114
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 16
    Caption = 'Copying:'
    Transparent = True
  end
  object NomDuFichierEnCours: TLabel
    Left = 8
    Top = 30
    Width = 273
    Height = 16
    AutoSize = False
    Caption = 'Filename'
    Transparent = True
  end
  object Label2: TLabel
    Left = 8
    Top = 79
    Width = 34
    Height = 16
    Caption = 'Time:'
    Transparent = True
  end
  object ElapsedTime: TLabel
    Left = 108
    Top = 79
    Width = 3
    Height = 16
    Transparent = True
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 56
    Width = 273
    Height = 17
    Smooth = True
    TabOrder = 0
  end
  object Annuler: TButton
    Left = 192
    Top = 80
    Width = 89
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = AnnulerClick
  end
end
