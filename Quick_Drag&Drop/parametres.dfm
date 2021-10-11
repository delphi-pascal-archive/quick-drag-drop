object FormParametres: TFormParametres
  Left = 312
  Top = 149
  BorderStyle = bsToolWindow
  Caption = 'Parametres'
  ClientHeight = 529
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 77
    Height = 16
    Caption = 'Path to store:'
    Transparent = True
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 230
    Height = 16
    Caption = 'Transparence (Windows 2000 et plus) :'
    Transparent = True
  end
  object Label4: TLabel
    Left = 32
    Top = 136
    Width = 305
    Height = 32
    Caption = 
      'Afficher automatiquement une icone dans la barre des tache quand' +
      ' la cible est disponible.'
    Enabled = False
    Transparent = True
    WordWrap = True
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 8
    Top = 200
    Width = 101
    Height = 16
    Caption = 'Verifier toute les :'
    Enabled = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 217
    Top = 202
    Width = 68
    Height = 16
    Caption = 'seconde(s)'
    Enabled = False
    Transparent = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 480
    Width = 337
    Height = 9
  end
  object Bevel2: TBevel
    Left = 8
    Top = 360
    Width = 337
    Height = 9
  end
  object Label6: TLabel
    Left = 8
    Top = 408
    Width = 221
    Height = 16
    Caption = 'Taille du tampon de copie (en octes):'
    Transparent = True
  end
  object Bevel3: TBevel
    Left = 8
    Top = 432
    Width = 337
    Height = 9
  end
  object Cible: TEdit
    Left = 8
    Top = 32
    Width = 305
    Height = 25
    TabOrder = 0
  end
  object Button1: TButton
    Left = 320
    Top = 32
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object TransparenceTrackBar: TTrackBar
    Left = 8
    Top = 88
    Width = 289
    Height = 33
    LineSize = 10
    Max = 255
    PageSize = 10
    Frequency = 10
    TabOrder = 2
    ThumbLength = 16
    OnChange = TransparenceTrackBarChange
  end
  object AutoAddIconWhenCibleIsOk: TCheckBox
    Left = 8
    Top = 136
    Width = 20
    Height = 17
    TabOrder = 3
    OnClick = AutoAddIconWhenCibleIsOkClick
  end
  object TimerVerifEditText: TEdit
    Left = 128
    Top = 192
    Width = 60
    Height = 25
    Enabled = False
    TabOrder = 4
    Text = '50'
  end
  object UpDown1: TUpDown
    Left = 188
    Top = 192
    Width = 21
    Height = 25
    Associate = TimerVerifEditText
    Enabled = False
    Max = 60
    Position = 50
    TabOrder = 5
  end
  object AfficherEnBasADroite: TCheckBox
    Left = 8
    Top = 269
    Width = 218
    Height = 21
    Caption = 'Afficher toujours en bas a droite'
    TabOrder = 6
    OnClick = AfficherEnBasADroiteClick
  end
  object SaveWindowPos: TCheckBox
    Left = 8
    Top = 298
    Width = 228
    Height = 21
    Caption = 'Memoriser la position de la fenetre'
    TabOrder = 7
    OnClick = SaveWindowPosClick
  end
  object Button2: TButton
    Left = 8
    Top = 496
    Width = 97
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 8
    OnClick = Button2Click
  end
  object Annuler: TButton
    Left = 256
    Top = 496
    Width = 89
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object RunAsStartup: TCheckBox
    Left = 8
    Top = 328
    Width = 336
    Height = 21
    Caption = 'Lancer automatiquement au demarrage de la session'
    TabOrder = 10
  end
  object TransparenceEditText: TEdit
    Left = 304
    Top = 80
    Width = 41
    Height = 25
    TabOrder = 11
    Text = '0'
    OnChange = TransparenceEditTextChange
    OnKeyPress = TransparenceEditTextKeyPress
  end
  object ShowInSeparetedWindow: TCheckBox
    Left = 8
    Top = 239
    Width = 277
    Height = 21
    Caption = 'Afficher le lecteur dans une fenetre separee'
    TabOrder = 12
  end
  object Button3: TButton
    Left = 112
    Top = 448
    Width = 153
    Height = 25
    Caption = 'Set by default'
    TabOrder = 13
    OnClick = Button3Click
  end
  object CopyAttributs: TCheckBox
    Left = 8
    Top = 374
    Width = 289
    Height = 21
    Caption = 'Copier les attributs des fichiers et repertoires'
    TabOrder = 14
  end
  object TailleTamponCopie: TEdit
    Left = 240
    Top = 400
    Width = 82
    Height = 25
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 15
    Text = '0'
  end
  object UpDown2: TUpDown
    Left = 322
    Top = 400
    Width = 23
    Height = 25
    Associate = TailleTamponCopie
    Max = 32767
    TabOrder = 16
  end
end
