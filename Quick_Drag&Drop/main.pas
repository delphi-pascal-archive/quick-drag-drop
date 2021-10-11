{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * Quick Drag&Drop
 * Copyright (C) 2005 - MARTINEAU Emeric
 *
 * Distribu� sous GPL
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * Copyright :
 * Feuille non rectangulaire :
 *   Marchioni Val�rian
 *   loub1@caramail.com
 *   icq: 30687888
 *
 * Les boutons (TGlyphButton) :
 *   WebCheck
 *   webcheck@arcor.de
 *   http://webcheck.we.ohost.de
 *
 * Gestion Systray
 *   Nono40
 *   http://nono40.developpez.com
 *
 * Logo (Crystal SVG)
 *   Everaldo
 *   http://www.everaldo.com
 *
 * Affichage boite de dialogue propri�t�s
 *   Michel Bardou
 *   http://www.phidels.com
 *
 * Calcule du temps de copie
 *   Sub0
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * Registre :
 * ---------
 * HKEY_CURRENT_USER
 * \Software\Microsoft\Windows\CurrentVersion\Run\ :
 * - QuickDrag&Drop
 *
 * \Software\Quick Drag&Drop :
 * - AfficherEnBasADroite (DWORD) :
 *   Indique si on affiche la fen�tre en bas � droite
 *
 * - AutoAddIconWhenCibleIsOk (DWORD) :
 *   Ajoute l'icone quand le p�riph�rique est pr�t ou change l'icone
 *
 * - Disk (STRING) :
 *   P�riph�rique o� r�pertoire de destination
 *
 * - PosX (DWORD) :
 *   Postition horizontale
 *
 * - PosY (DWORD) :
 *   Position verticale
 *
 * - SaveWindowPos (DWORD) :
 *   Indique s'il faut m�moriser la position de la fen�tre
 *
 * - ShowInSeparetedWindow (DWORD)
 *   Afficher le lecteur dans une fen�tre s�parer
 *
 * - ShowInTaskBar (DWORD)
 *   Afficher dans la barre des t�ches (systray)
 *
 * - StayOnTop (DWORD) :
 *   Fen�tre toujours au premier plan
 *
 * - Timer (DWORD) :
 *   Temps de v�rification pour ajouter le systray
 *
 * - Transparence (DWORD) :
 *   Valeur de transparence
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * TODO pour la version 2
 *  - pouvoir param�tre la taille du tampon de copie
 *  - copier aussi les attributs
 *  - multi-langue
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ShellApi, Menus, StdCtrls, Registry, GlyphButton,
  ExtCtrls, aproposde, parametres, FenetreCopier, mmSystem, IniFiles,
  FenetreTheme, FileCtrl;

Const
  { D�finition d'un message personnalis�. }
  { Ce message est envoy� par Windows sur demande quand un �v�nement }
  { li� � la souris intervient. }
  WM_MONICONE = WM_USER +1;
  CHEMIN_REGISTRE = 'Software\Quick Drag&Drop' ;
  { Message indiquant que le theme sous Winodws XP change }
  WM_THEMECHANGED = 794 ;

type
  TForm1 = class(TForm)
    PopupDroit: TPopupMenu;
    ShowInTaskBar: TMenuItem;
    StayOnTop: TMenuItem;
    N1: TMenuItem;
    Parametres1: TMenuItem;
    N2: TMenuItem;
    Masquer1: TMenuItem;
    Affichercontenududisque1: TMenuItem;
    Propritdudisque1: TMenuItem;
    N3: TMenuItem;
    Aproposde1: TMenuItem;
    N4: TMenuItem;
    Quitter1: TMenuItem;
    ImageList1: TImageList;
    Image1: TImage;
    BoutonStayOnTop: TGlyphButton;
    BoutonClose: TGlyphButton;
    BoutonMinimiser: TGlyphButton;
    BoutonApropos: TGlyphButton;
    BoutonDossier: TGlyphButton;
    BoutonMenu: TGlyphButton;
    TimerPresenceDisque: TTimer;
    TimerCopie: TTimer;
    SkinMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure StayOnTopClick(Sender: TObject);
    procedure Masquer1Click(Sender: TObject);
    procedure ShowInTaskBarClick(Sender: TObject);
    procedure BoutonStayOnTopClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BoutonCloseClick(Sender: TObject);
    procedure BoutonMinimiserClick(Sender: TObject);
    procedure BoutonMenuClick(Sender: TObject);
    procedure BoutonAproposClick(Sender: TObject);
    procedure Aproposde1Click(Sender: TObject);
    procedure Parametres1Click(Sender: TObject);
    procedure TimerPresenceDisqueTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BoutonDossierClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Propritdudisque1Click(Sender: TObject);
    procedure TimerCopieTimer(Sender: TObject);
    procedure SkinMenuClick(Sender: TObject);
  private
    { D�clarations priv�es }
    { Ce tableau regroupe est Handles des icones extraites du fichier }
    LesIcones : array[0..2] of HICON;
    { Numero dans le tableau ci-dessus de l'icone actuellement affich�e }
    IconeEnCours : Integer;
    { Configuration }
    DisqueCible : String ;
    SaveWindowPos : Boolean ;
    AutoAddIconWhenCibleIsOk : Boolean ;
    TimerIntervale : Integer ;
    ShowInSeparetedWindow : Boolean ;
    { Fen�tre de copie }
    FCopier : TFormCopier ;
    { Message en cours pour le timer }
    MessageEncoursSysTray : String ;
    { Buffer pour la copie. Mit ici car lorsqu'on copie plusieurs fichiers, cela
      �vite de r�initialiser la m�moire � chaque fois. }
    Buf : PChar ;
    { Indique si on est en cours de copie }
    CopieEnCours : Boolean ;
    { Copie les attributs des fichiers }
    CopyAttributs : Boolean ;
    { Taille m�moire tampon pour la copie - USB 1.1 : 1.5Mb/s et 12Mb/s - USB 2.0 : 480Mb/s }
    TailleTamponCopie : Integer ;

    { D�finition d'une m�thode de r�ponse au message personnalis� cr�� }
    procedure MessageIcone(Var Msg: TMsg);Message WM_MONICONE;
    { Proc�dure d'ajout de l'icone, est appel�e au d�but de l'application }
    procedure AjouteIcone;
    { Proc�dure de mise � jour de l'icone }
    procedure ModifieIcone(Texte : String) ;
    { Proc�dure de suppression de l'icone, est appel�e � la fermeture }
    procedure SupprimeIcone;
    { Lit la configuration }
    procedure LireConfiguration ;
    { Stay OnTop }
    procedure SetStayOnTop ;
    { Cr�er la transparence }
    procedure former(Obj:tform;img:tbitmap;couleur:tcolor);
    { Cache la feuille }
    procedure CacherFeuille ;
    { Test si le lecteur est pr�sent }
    function DiskIsPresent : Boolean;
    { Si le theme change sous Windows XP }
    procedure StyleChanged( var msg:TMessage); message WM_THEMECHANGED;
    { Affiche les info du disque }
    procedure OuvreProprieteFichier(NomFichier:string);
    { R�initialise la config }
    procedure ResetConfig ;
    { Proc�dure appeler quand on fait le drag&drop }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    { Copie de fichier }
    procedure CopieFichier(NomFicSource : string; NomFicCible: string);
    { Affiche le temps }
    function AffTime(ts: Integer): String;
    { Donne l'espace disponible du lecteur }
    function GetDiskSize(lecteur : String): int64 ;
    { Copie un r�pertoire }
    procedure CopierRepertoire(Chemin : String; CheminCible : String) ;
  public
    { D�clarations publiques }
    { Indique la r�ponse pour le remplacement de fichier }
    ReponseRemplacement :  Word ;
    AnnulerCopie : Boolean ;
    Theme : String ;
        
    { applique le theme }
    procedure SetSkin(ThemeLocal : String) ;
    { Enregistre le th�me }
    procedure SaveSkin(ThemeLocal : String) ;
    { Supprime la transparance }
    procedure SupprimerTransparence(Obj : tform; img : tbitmap; couleur : tcolor);
  end;

var
  Form1: TForm1;
  OSInfos : OSVERSIONINFO ;

implementation

{$R *.dfm}
{$R ressource.RES}

{*******************************************************************************
 * Cr�ation de la feuille
 *******************************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
begin
    { On n'est pas en cours de copie }
    CopieEnCours := False ;

    MessageEncoursSysTray := '' ;

    { Charge l'icone de la main de Windows plut�t que de delphi }
    Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);

    { R�cup�re les informations du syst�me d'exploitation }
    OSInfos.dwOSVersionInfoSize := Sizeof(OSInfos);
    GetVersionEx(OSInfos);

    { Charge les icones }
    { Sinon charche les icones basse r�solution }
    { Icone normale }
    LesIcones[0] := ExtractIcon(Application.Handle,PChar(Application.exename),4);
    { Icone en cours d'�criture }
    LesIcones[1] := ExtractIcon(Application.Handle,PChar(Application.exename),5);
    { Icone d�sactiv�e }
    LesIcones[2] := ExtractIcon(Application.Handle,PChar(Application.exename),6);

    { Si c'est Windows XP et plus on charche les icones en haut r�solution }
    if (OSInfos.dwMajorVersion > 5) or ((OSInfos.dwMajorVersion = 5) and (OSInfos.dwMinorVersion > 0))
    then begin
        { Lecture nb de couleur }
        if GetDeviceCaps(Form1.Canvas.Handle, BITSPIXEL) > 16
        then begin
            { Sinon charche les icones haute r�solution }
            LesIcones[0] := ExtractIcon(Application.Handle,PChar(Application.exename),1);
            LesIcones[1] := ExtractIcon(Application.Handle,PChar(Application.exename),2);
            LesIcones[2] := ExtractIcon(Application.Handle,PChar(Application.exename),3);
        end ;
    end ;

    { Lit la configuration & applique le th�me }
    LireConfiguration ;

    case ParamCount of
        0 : begin
            end ;
        1 : begin { ParamStr(1) }
                if UpperCase(ParamStr(1)) = '/RESETCONFIG'
                then begin
                    ResetConfig ;
                end ;
            end ;
        else
            MessageDlg('Trop de param�tre en ligne de commande.' + #13 + #10 + 'qdd.exe /resetconfig.', mtError, [mbOK], 0) ;
    end ;

    DiskIsPresent ;

    { Indique que l'on peut faire du drag&drop sur la feuille }
    DragAcceptFiles(Self.Handle, true);
end;

{******************************************************************************
 * Ajoute l'ic�ne dans le SysTray
 ******************************************************************************}
procedure TForm1.AjouteIcone;
var Info : TNotifyIconData;
begin
    { If faut tout d'abord remplir la structure Info
      avec ce que l'on veut faire }

    { cbSize doit contenir la taille de la structure }
    Info.cbSize := SizeOf(Info);
    { Wnd doit contenir le Handle de la fen�tre qui recevra les messages de
      notification d'�v�nement de la souris }
    Info.Wnd := Handle;
    { uID Num�ro d'icone, c'est utile si plusieurs icones sont affich�es en
      simultann�es dans la barre des taches. Car c'est ce num�ro qui permettra
      ensuite de modifier celle que l'on veut. }
    Info.uID := 1;
    { szTip contient le texte de l'info bulle affich� au dessus de l'icone }
    Info.szTip := 'Quick Drag&Drop';
    { hIcon contient le handle de l'icone qui doit �tre affich�e }
    Info.hIcon := LesIcones[IconeEnCours];
    { uCallBackMessage contient le message qui sera retourn� � la fen�tre
      donn�e par Wnd quand un �v�nement de souris apparait sur l'icone }
    Info.uCallbackMessage := WM_MONICONE;
    { uFlags doit contenir le liste des champs utilis�s dans la structure
      parmis les champs szTip,hIcon et uCallBackMessage }
    Info.uFlags := NIF_TIP Or NIF_ICON Or NIF_MESSAGE;

    { Appel de la fonction API ajoutant l'icone }
    Shell_NotifyIcon(NIM_ADD, @Info);
end;

{******************************************************************************
 * Modifie l'ic�ne dans le SysTray
 ******************************************************************************}
procedure TForm1.ModifieIcone(Texte : String) ;
var Info : TNotifyIconData ;
    i, longueur : ShortInt ;

begin
    if Texte = ''
    then
        Texte := 'Quick Drag&Drop' ;

    if length(Texte) > 63
    then
        longueur := 63
    else
        longueur := length(Texte) ;

    for i := 1 to longueur + 1 do
    begin
        Info.szTip[i - 1] := Texte[i] ;
    end ;

    { If faut tout d'abord remplir la structure Info
      avec ce que l'on veut faire
      ( voir la proc�dure ci-dessus pour les d�tails ) }
    Info.cbSize := SizeOf(Info) ;
    Info.Wnd    := Handle ;
    Info.uID    := 1 ;
    Info.uFlags := NIF_TIP Or NIF_ICON Or NIF_MESSAGE ;
    Info.hIcon  := LesIcones[IconeEnCours] ;
    Info.uCallbackMessage := WM_MONICONE ;
    Shell_NotifyIcon(NIM_MODIFY, @Info) ;
end;

{******************************************************************************
 * Supprime l'ic�ne dans le SysTray
 ******************************************************************************}
procedure TForm1.SupprimeIcone ;
var Info:TNotifyIconData;
begin
    { Dans le cas de la suppression d'une icone, seuls les champs ci-dessous
      sont n�cessaires }
    Info.cbSize := SizeOf(Info) ;
    Info.Wnd    := Handle ;
    Info.uID    := 1 ;
    Shell_NotifyIcon(NIM_DELETE, @Info) ;
end;

{******************************************************************************
 * D�truit la fiche
 ******************************************************************************}
procedure TForm1.FormDestroy(Sender: TObject) ;
Var i : Integer ;
    Registre : TRegistry ;
begin
    { L'icone est supprim�e de la barre des taches }
    SupprimeIcone;
    { Et les handles des icones sont lib�r�s }
    for i := 0 to 2 do
        DestroyIcon(LesIcones[i]) ;

    if SaveWindowPos
    then begin
        Registre := TRegistry.Create ;

        try
            { Lancer au d�marrage de la session }
            Registre.RootKey := HKEY_CURRENT_USER ;
            Registre.OpenKey(CHEMIN_REGISTRE, True) ;

            Registre.WriteInteger('PosX', Self.Left) ;
            Registre.WriteInteger('PosY', Self.Top) ;

            Registre.CloseKey ;
        finally
            Registre.Free ;
        end ;
    end ;
end;

{******************************************************************************}
{* Proc�dure de r�ponse � notre message personnalis�
 * Windows retourne dans le champ wParam du message le message original de
 * l'icone.
 * Ainsi, MSG.Message contient WM_MONICONE et MSG.wParam contient WM_LBUTTONDOWN
 * ou WM_LBUTTONUO ou ...
 *}
{******************************************************************************}
procedure TForm1.MessageIcone(Var MSG:TMSG) ;
begin
    { Click du bouton gauche }
    if MSG.wParam = WM_LBUTTONDOWN
    then begin
        { Attention, si le double click doit �tre g�r�, il ne faut pas ex�cuter
          tout de suite l'action li� � ce message. Surtout si un menu est affich�
          sur le click gauche. Dans ce cas le double-click ne se produit pas car
          le deuxi�me click n'est plus li� � l'icone mais au menu. }

        { Le click ici restaure l'application et elle est mise au premier plan }
        { Si on est en cours de copie, on n'affiche pas la feuille m�re }
        if CopieEnCours = False
        then begin
            Show ;
            Application.Restore;
            Application.BringToFront ;

            if not ShowInTaskBar.Checked
            then
                SupprimeIcone ;
        end
        else begin
            { ram�ne au premier plan pour acc�s menu }
            SetForegroundWindow(Handle) ;
            FCopier.SetFocus ;
        end ;
    end;

    if MSG.wParam = WM_RBUTTONUP
    then begin
        { Dans le cas du bouton droit, le double-clique n'est pas g�r�
          le menu li� au bouton droit peut donc �tre affich� de suite.
          Il est pr�f�rable dans ce cas d'utiliser WM_RBUTTONUP plut�t
          que WM_RBUTTONDOWN }
        PopUpDroit.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y) ;
    end;

    if MSG.wParam = WM_LBUTTONDBLCLK
    then begin
        { Un double-clique est d�tect�, alors il faut annuler le timer avant
          qu'il n'arrive � terme. Ainsi le l'action li�e au click simple
          n'est pas ex�cut�e }

        { Afficher le contenu du disque sauf si on est d�sactiv� }
        if DiskIsPresent
        then
            BoutonDossierClick(BoutonDossier) ;
    end;
end;

{******************************************************************************
 * Quitte l'application
 ******************************************************************************}
procedure TForm1.Quitter1Click(Sender: TObject);
begin
    Close ;
end;

{******************************************************************************
 * Met la feuille au primer plan
 ******************************************************************************}
procedure TForm1.StayOnTopClick(Sender: TObject);
begin
    SetStayOnTop ;
end ;

{******************************************************************************
 * Met la feuille au primer plan
 ******************************************************************************}
procedure TForm1.SetStayOnTop ;
var
    Registe : TRegistry;
begin
    StayOnTop.Checked := not StayOnTop.Checked ;

    if StayOnTop.Checked
    then begin
        { Met la feuille au premier plan et change les images du boutons }
        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE) ;
        ImageList1.GetBitmap(0, BoutonStayOnTop.Bild_Button) ;
        ImageList1.GetBitmap(1, BoutonStayOnTop.Bild_MouseOver) ;
        ImageList1.GetBitmap(2, BoutonStayOnTop.Bild_Down) ;
        BoutonStayOnTop.Refresh ;
        BoutonStayOnTop.Hint := 'Ne fixe plus la fen�tre au dessus des autres' ;
    end
    else begin
        { El�ve la feuille du premier plan et change les images du boutons }
        SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE) ;
        ImageList1.GetBitmap(3, BoutonStayOnTop.Bild_Button) ;
        ImageList1.GetBitmap(4, BoutonStayOnTop.Bild_MouseOver) ;
        ImageList1.GetBitmap(5, BoutonStayOnTop.Bild_Down) ;
        BoutonStayOnTop.Refresh ;
        BoutonStayOnTop.Hint := 'Fixer la fen�tre au dessus des autres' ;
    end ;

    Registe := TRegistry.Create;

    try
        Registe.RootKey := HKEY_CURRENT_USER ;

        if Registe.OpenKey(CHEMIN_REGISTRE, True)
        then begin
            Registe.WriteBool('StayOnTop', StayOnTop.Checked);
        end ;
    finally
        Registe.CloseKey;
        Registe.Free;
    end;
end;

{******************************************************************************
 * Cahce la feuille
 ******************************************************************************}
procedure TForm1.Masquer1Click(Sender: TObject);
begin
    CacherFeuille ;
end;

{******************************************************************************
 * Affiche ou non dans la barre de tache
 ******************************************************************************}
procedure TForm1.ShowInTaskBarClick(Sender: TObject);
var
    Registe : TRegistry;
begin
    TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked ;

    if TMenuItem(Sender).Checked
    then
        AjouteIcone
    else
        SupprimeIcone ;

    Registe := TRegistry.Create;

    try
        Registe.RootKey := HKEY_CURRENT_USER ;

        if Registe.OpenKey(CHEMIN_REGISTRE, True)
        then begin
            Registe.WriteBool('ShowInTaskBar', TMenuItem(Sender).Checked);
        end ;
    finally
        Registe.CloseKey;
        Registe.Free;
    end;
end;

{******************************************************************************
 * Lit la configuration
 ******************************************************************************}
procedure TForm1.LireConfiguration ;
var
    Registre : TRegistry;
    tmp : Integer ;
    Rectangle : TRect ;    
begin
    Registre := TRegistry.Create;

    try
        Registre.RootKey := HKEY_CURRENT_USER ;

        if Registre.OpenKey(CHEMIN_REGISTRE, True)
        then begin
            { Afficher dans la barre des t�che }
            if Registre.ValueExists('ShowInTaskBar')
            then begin
                ShowInTaskBar.Checked := Registre.ReadBool('ShowInTaskBar') ;
            end
            else
                ShowInTaskBar.Checked := True ;

            if ShowInTaskBar.Checked
            then
                AjouteIcone;

            { Afficher dans la barre des t�che }
            if Registre.ValueExists('StayOnTop')
            then begin
                StayOnTop.Checked := Registre.ReadBool('StayOnTop') ;

                if StayOnTop.Checked
                then begin
                    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE) ;
                    ImageList1.GetBitmap(0, BoutonStayOnTop.Bild_Button) ;
                    ImageList1.GetBitmap(1, BoutonStayOnTop.Bild_MouseOver) ;
                    ImageList1.GetBitmap(2, BoutonStayOnTop.Bild_Down) ;
                    BoutonStayOnTop.Refresh ;
                    BoutonStayOnTop.Hint := 'Ne fixe plus la fen�tre au dessus des autres' ;
                end ;
            end
            else
                StayOnTop.Checked := False ;

            { Chemin }
            if Registre.ValueExists('Disk')
            then
                DisqueCible := Registre.ReadString('Disk')
            else
                MessageDlg('Aucune cible n''a �t� configur�e ! Vous devez commencer par en choisir une dans ''Param�tres''.', mtInformation, [mbOK], 0) ;

            if (OSInfos.dwMajorVersion >= 5)
            then begin
                { Transparence }
                if Registre.ValueExists('Transparence')
                then begin
                    tmp := Registre.ReadInteger('Transparence');

                    if tmp > 0
                    then begin
                        Self.AlphaBlend := True ;
                        Self.AlphaBlendValue := tmp ;
                    end ;
                end ;
            end ;

            { Lit le th�me }
            if Registre.ValueExists('Skin')
            then
                Theme := Registre.ReadString('Skin')
            else
                Theme := 'Default' ;
            end ;

            SetSkin(Theme) ;

            { Afficher en bas � droite }
            if Registre.ValueExists('AfficherEnBasADroite')
            then
                if Registre.ReadBool('AfficherEnBasADroite')
                then begin
                    { Utilisation de SystemParametersInfo pour r�cup�rer la surface (rectangle) de
                      travail de l'�cran disponible }
                    SystemParametersInfo(SPI_GETWORKAREA, 0, @Rectangle, 0) ;

                    Self.Left := Rectangle.Right - Self.Width ;
                    Self.Top := Rectangle.Bottom - Self.Height ;
                end ;

            { Afficher en bas � droite }
            if Registre.ValueExists('SaveWindowPos')
            then
                SaveWindowPos := Registre.ReadBool('SaveWindowPos') ;

                if SaveWindowPos
                then begin
                    { Afficher en bas � droite }
                    if Registre.ValueExists('PosX')
                    then begin
                        tmp := Registre.ReadInteger('PosX') ;

                        { Si on sort de l'�cran }
                        if tmp > Rectangle.Right
                        then begin
                            Left := Rectangle.Right - Width ;
                        end
                        else
                            Left := tmp ;

                    end ;

                    { Afficher en bas � droite }
                    if Registre.ValueExists('PosY')
                    then begin
                        tmp := Registre.ReadInteger('PosY') ;

                        { Si on sort de l'�cran }
                        if tmp > Rectangle.Right
                        then begin
                            Top := Rectangle.Bottom - Height ;
                        end
                        else
                            Top := tmp ;
                    end ;
                end ;

            { AjoutAutomatique d'une icone si appareil mis }
            if Registre.ValueExists('Timer')
            then begin
                 TimerIntervale := Registre.ReadInteger('Timer') * 1000 ;
                 TimerPresenceDisque.Interval := TimerIntervale ;
            end ;

            if Registre.ValueExists('AutoAddIconWhenCibleIsOk')
            then begin
                AutoAddIconWhenCibleIsOk := Registre.ReadBool('AutoAddIconWhenCibleIsOk');
                TimerPresenceDisque.Enabled := AutoAddIconWhenCibleIsOk ;
            end ;

            if Registre.ValueExists('ShowInSeparetedWindow')
            then begin
                ShowInSeparetedWindow := Registre.ReadBool('ShowInSeparetedWindow');
            end
            else
                ShowInSeparetedWindow := True ;

            { Copie les attributs des fichiers }
            if Registre.ValueExists('CopyAttributs')
            then begin
                CopyAttributs := Registre.ReadBool('CopyAttributs');
            end
            else
                CopyAttributs := True ;

            { Taille du tampon pour la copie }
            if Registre.ValueExists('TailleTamponCopie')
            then begin
                TailleTamponCopie := Registre.ReadInteger('TailleTamponCopie') ;
            end
            else
                TailleTamponCopie := 4096 ;

        Registre.CloseKey;
    finally
        Registre.Free;
    end;

end ;

{******************************************************************************
 * Met la feuille au primer plan
 ******************************************************************************}
procedure TForm1.BoutonStayOnTopClick(Sender: TObject);
begin
    SetStayOnTop ;
end;

{******************************************************************************}
{* Cr�er la transparence
 *
 * Source original de Marchioni Val�rian
 * loub1@caramail.com
 * icq: 30687888
 *
{******************************************************************************}
procedure Tform1.former(Obj : tform; img : tbitmap; couleur : tcolor);
var
    x, y, regtemp, debut, fin : integer ;
    etaitblanc, first : boolean ;
    Transparancy : Boolean ;
    reg : Integer ;
begin
     obj.height := img.height ;   // on adapte les
     obj.width := img.width ;     // dimensions de la fiche

     { Indique qu'il y eu une transparance de cr�� }
     Transparancy := False ;

     first := true ;              // c'est pour savoir si on a deja cr�� une
                                  // r�gion : voir CombineRgn (n�cessite une region non vide)
     reg := 0 ;

     for y := 1 to img.height - 1 do
     begin
         debut := 1 ;             // debut = debut de la zone non-traansparente
         //fin := 1 ;               // fin  =fin   """"""""""""""""""""""""""""
         etaitblanc := true ;     //etaitblanc, c'est pour savoir si le pixel examin� pr�c�demment �tait
                                  //transparent ou pas (ben oui j'avais d'abord commenc� par le blanc, ce serait
                                  //plus logique d'appeler cette variable etaittraansparente, mais c'est trop long a ecrire
         for x := 1 to img.width do
         begin

             // si le pixel est transparent
             if img.Canvas.Pixels[x, y] = couleur
             then begin
                 Transparancy := True ;

                 // et que le pr�c�dent ne l'etait pas
                 if etaitblanc = false
                 then begin
                     fin := x - 1 ;   // le dernier pixel non transparent etait le precedent

                     // si c'est la 1�region qu'on cr�e:
                     if first = true
                     then begin
                         reg := CreateRectRgn(debut, y, fin + 1, y + 1) ; // on la cr�e
                         first := false ;                                 // la prochaine ne sera plus la premiere
                     end
                     else begin
                         // si c'est pas la premiere region
                         regtemp := createrectrgn(debut, y, fin + 1, y + 1) ; // on en cr�e une temporaire
                         CombineRgn(reg, reg, regtemp, rgn_or) ;              // on l'ajoute � reg qui sera la region finale avec rgn_or (voir autres possibilit�s dans l'aide)
                         deleteobject(regtemp) ;                              // on supprime la region temporaire pour rester propres (si on ne le fait pas, ca se fait autom. qd on ferme l'application)
                     end ;
                 end ;

                 etaitblanc := true ;
             end
             else begin
                 // le pixel n'est pas transparent
                 if etaitblanc = true
                 then
                     debut := x ; //ben oui rien que ca

                 etaitblanc := false ;

                 // on arrive au dernier point de la ligne
                 if x = img.width - 1
                 then
                     // si c'est la 1�region qu'on cr�e:
                     if first = true
                     then begin
                         reg := CreateRectRgn(debut, y, x, y + 1) ; // on la cr�e
                         first := false ;                           // la prochaine ne sera plus la premiere
                     end
                     else begin
                         // si c'est pas la premiere region
                         regtemp := createrectrgn(debut, y, x, y + 1) ; //on en cr�e une temporaire
                         CombineRgn(reg, reg, regtemp, rgn_or) ; //on l'ajoute � reg qui sera la region finale avec rgn_or (voir autres possibilit�s dans l'aide)
                         deleteobject(regtemp) ; // on supprime la region temporaire pour rester propres (si on ne le fait pas, ca se fait autom. qd on ferme l'application)
                     end ;
             end ;
         end ;
     end ;

     { S'il y a eu une transparence de cr��, alors on l'affiche }
     if Transparancy
     then
         SetWindowRgn(Obj.handle, reg, true); // on applique la region
end ;

{******************************************************************************
 * D�place la feuille
 ******************************************************************************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    ReleaseCapture;
    Form1.Perform(WM_SYSCOMMAND, $F012, 0);
end;

{******************************************************************************
 * Ferme l'application
 ******************************************************************************}
procedure TForm1.BoutonCloseClick(Sender: TObject);
begin
    Close ;
end;

{******************************************************************************
 * Cahce la feuille
 ******************************************************************************}
procedure TForm1.BoutonMinimiserClick(Sender: TObject);
begin
    CacherFeuille ;
end;

{******************************************************************************
 * Cahce la feuille
 ******************************************************************************}
procedure TForm1.CacherFeuille ;
begin
    Hide ;

    if not ShowInTaskBar.Checked
    then
        AjouteIcone ;
end ;

{******************************************************************************
 * Affiche le menu
 ******************************************************************************}
procedure TForm1.BoutonMenuClick(Sender: TObject);
begin
    Form1.PopUpDroit.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y) ;
end;

{******************************************************************************
 * A propos de
 ******************************************************************************}
procedure TForm1.BoutonAproposClick(Sender: TObject);
Var FAproposde : TFormAproposde ;
begin
    FAproposde := TFormAproposde.Create(Self) ;
    FAproposde.ShowModal ;
    FAproposde.Free ;

    LireConfiguration ;    
end;

{******************************************************************************
 * A propos de
 ******************************************************************************}
procedure TForm1.Aproposde1Click(Sender: TObject);
Var FAproposde : TFormAproposde ;
begin
    FAproposde := TFormAproposde.Create(Self) ;
    FAproposde.ShowModal ;
    FAproposde.Free ;
end;

{******************************************************************************
 * Affiche la fiche param�tres
 ******************************************************************************}
procedure TForm1.Parametres1Click(Sender: TObject);
Var FP : TFormParametres ;
begin
    FP := TFormParametres.Create(Self);
    FP.ShowModal ;
    FP.Free ;

    LireConfiguration ;
end;

{******************************************************************************
 * V�rifie la pr�sence du support
 ******************************************************************************}
procedure TForm1.TimerPresenceDisqueTimer(Sender: TObject);
begin
    DiskIsPresent ;
end;

{******************************************************************************
 * Proc�dure appel� quand on dessine la feuille
 ******************************************************************************}
procedure TForm1.FormPaint(Sender: TObject);
begin
    { Cache l'�l�ment de la barre des t�ches
      One peut pas mettre ce code dans FormCreate car �a le bouton n'existe pas
      encore. }
    ShowWindow(Application.Handle, SW_Hide) ;
end;

{******************************************************************************
 * Test si le lecteur est pr�sent
 ******************************************************************************}
function TForm1.DiskIsPresent : Boolean;
var
    ErrorMode: Word;
    tmp : String ;
begin
    Result := False ;

    { D�sactive la gestion des erreurs }
    ErrorMode:= SetErrorMode(SEM_FAILCRITICALERRORS);

    try
        if DisqueCible <> ''
        then begin
            { Si le lecteur est pr�sent }
            tmp := ExtractFileDrive(DisqueCible) ;
            tmp := UpperCase(tmp) ;

            { DiskSize(0)= unit� en cours, 1= A, 2= B }
            Result := DiskSize(Ord(tmp[1]) - Ord('A') + 1) <> -1 ;

            { Si le chemin contient plus de trois caract�re alors c'est un r�pertoire }
            if Length(DisqueCible) > 3
            then
                Result := DirectoryExists(DisqueCible) ;
        end ;

        if Result
        then
            IconeEnCours := 0
        else
            IconeEnCours := 2 ;

        { Si on a l'icone dans la barre des t�ches, on l'a modifie }
        if ShowInTaskBar.Checked
        then
            ModifieIcone('')
        else begin
            { Sinon, doit-on l'ajouter ? }
            if AutoAddIconWhenCibleIsOk and Result
            then
                AjouteIcone ;
        end ;

    finally
        { R�active la gestion des erreurs }
        SetErrorMode(ErrorMode);
    end;
end;

{******************************************************************************
 * Se d�clanche quand le th�me de Windows XP change
 * Dans certain cas, la fen�tre apparait dans la barre des t�ches
 ******************************************************************************}
procedure TForm1.StyleChanged( var msg:TMessage);
begin
  ShowWindow(Application.handle,Sw_hide);

  { Continue � propager le message }
  inherited;
end;

{******************************************************************************
 * Affiche le contenu du lecteur
 ******************************************************************************}
procedure TForm1.BoutonDossierClick(Sender: TObject);
var operation : String ;
begin
    if DiskIsPresent
    then begin
        if ShowInSeparetedWindow
        then
            operation := 'OPEN'
        else
            operation := 'EXPLORE' ;

        ShellExecute(Handle, Pchar(operation), PChar(DisqueCible), '', PChar(DisqueCible), SW_SHOWNORMAL) ;
    end
    else
        MessageDlg('Aucun disque pr�sent !', mtWarning, [mbOK], 0) ;
end;

{******************************************************************************
 * Affiche le contenu du lecteur
 ******************************************************************************}
procedure TForm1.Image1DblClick(Sender: TObject);
begin
    BoutonDossierClick(BoutonDossier) ;
end;

{******************************************************************************
 * Affiche les propri�t�s du disque
 ******************************************************************************}
procedure TForm1.Propritdudisque1Click(Sender: TObject);
begin
    if DiskIsPresent
    then
        OuvreProprieteFichier(DisqueCible)
    else
        MessageDlg('Aucun disque pr�sent !', mtWarning, [mbOK], 0) ;
end ;

{******************************************************************************
 * Affiche les propri�t�s du disque
 ******************************************************************************}
procedure TForm1.OuvreProprieteFichier(NomFichier:string);
var ShellExecuteInfo:TShellExecuteInfo;
begin
    Self.Cursor := crHourGlass ;

    FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
    ShellExecuteInfo.cbSize := SizeOf(ShellExecuteInfo);
    ShellExecuteInfo.fMask := SEE_MASK_INVOKEIDLIST;
    ShellExecuteInfo.lpVerb := 'properties';
    ShellExecuteInfo.lpFile := PChar(NomFichier);
    ShellExecuteEx(@ShellExecuteInfo);

    Self.Cursor := crDefault ;    
end;

{******************************************************************************
 * R�initilise la configuration
 ******************************************************************************}
procedure TForm1.ResetConfig ;
Var Registre : TRegistry ;
begin
    Registre := TRegistry.Create;

    try
        Registre.RootKey := HKEY_CURRENT_USER ;

        if Registre.OpenKey(CHEMIN_REGISTRE, True)
        then begin
            Registre.DeleteValue('AfficherEnBasADroite') ;
            Registre.DeleteValue('AutoAddIconWhenCibleIsOk') ;
            Registre.DeleteValue('Disk') ;
            Registre.DeleteValue('PosX') ;
            Registre.DeleteValue('PosY') ;
            Registre.DeleteValue('SaveWindowPos') ;
            Registre.DeleteValue('ShowInSeparetedWindow') ;
            Registre.DeleteValue('ShowInTaskBar') ;
            Registre.DeleteValue('StayOnTop') ;
            Registre.DeleteValue('Timer') ;
            Registre.DeleteValue('Transparence') ;
        end ;

        MessageDlg('Configuration r�initialis�e', mtInformation, [mbOK], 0) ;

        Registre.CloseKey;
    finally
        Registre.Free;
    end;
end ;

{******************************************************************************
 * Proc�dure appel�e quand on drop quelque chose
 ******************************************************************************}
procedure TForm1.WMDropFiles(var Msg: TWMDropFiles);
var
  NombreDeFichiers,i:integer;
  NomDuFichier : array[0..MAX_PATH] of char;
  Msg_SysTray : TMSG ;
  tmp : String ;
begin
    { Initialise � mrNo. Si c'est � mrNo, �a veux dire qu'on n'a pas r�pondu
      � la question et qu'il faut donc la poser }
    ReponseRemplacement := mrNo ;

    { Indique si on doit annuler la copie }
    AnnulerCopie := False ;

    { Initialise le buffer de copie }
    GetMem(Buf, TailleTamponCopie);

    { Indique qu'on est en cours de copie }
    CopieEnCours := True ;

    try
        { Cr�er la fen�tre de copie }
        FCopier := TFormCopier.Create(Self);
        { Mesque la feuille }
        CacherFeuille ;
        FCopier.Show ;
        SetForegroundWindow(Handle) ;

        try
            { r�cup�ration du nombre de fichiers }
            NombreDeFichiers := DragQueryFile(Msg.Drop, $FFFFFFFF, NomDuFichier,
                                              sizeof(NomDuFichier));

            { Active le timer pour le changement d'icone }
            TimerCopie.Enabled := True ;

            { Lance une nouvelle session pour chaque fichier }
            for i := 0 to NombreDeFichiers - 1 do
            begin
              { r�cup�ration du nom du fichier }
              if DragQueryFile(Msg.Drop, i, NomDuFichier, sizeof(NomDuFichier)) > 0
              then begin
                  { Mettre � jour le texte du systray avec 'Quick Drag&Drop - Copie en cours XXX% (X fichiers sur Y)' }
                  MessageEncoursSysTray := 'QDD - Copie en cours ' + IntToStr((i + 1) * 100 div NombreDeFichiers) + '% (' + IntToStr(i + 1) + '/' + IntToStr(NombreDeFichiers) + ')' ;

                  { Avec le Timer, il est inutile de modifier l'icone ici, d'autant
                    plus que le probl�me c'est au moment o� on change de fichier,
                    l'icone change pr�mattur�ment.
                  ModifieIcone(MessageEncoursSysTray);
                  }
                  
                  { Copier le fichier }
                  { Est-ce un r�pertoire }
                  if DirectoryExists(NomDuFichier)
                  then begin
                      tmp := DisqueCible + ExtractFileName(NomDuFichier) ;

                      { Si on n'a pas dit oui � tout, on v�rifie que le r�pertoire
                        existe }
                      if ReponseRemplacement <> mrYesToAll
                      then begin
                          if DirectoryExists(tmp)
                          then begin
                              if ReponseRemplacement <> mrNoToAll
                              then begin
                                  SetForegroundWindow(Handle) ;
                                  ReponseRemplacement := MessageDlg('Le r�pertoire ''' + ExtractFileName(NomDuFichier) + ''' existe d�j�, souhaitez-vous le remplacer ?', mtConfirmation, [mbYes, mbNo, mbNoToAll, mbYesToAll, mbCancel], 0) ;

                                  { Si on a cliqu� sur Annuler, on annule la copie }
                                  if ReponseRemplacement = mrCancel
                                  then begin
                                      AnnulerCopie := True ;
                                  end
                                  else begin
                                      if ReponseRemplacement = mrYes
                                      then
                                          CopierRepertoire(String(NomDuFichier), tmp) ;
                                  end ;
                              end ;
                          end
                          else begin
                              CopierRepertoire(String(NomDuFichier), tmp) ;
                          end ;
                      end
                      else begin
                          CopierRepertoire(String(NomDuFichier), tmp) ;
                      end ;
                  end
                  else begin
                      { Copie un fichier }
                      CopieFichier(String(NomDuFichier), DisqueCible + ExtractFileName(String(NomDuFichier)));
                  end ;

                  { On a cliqu� sur le bouton annuler la copie ou annuler de la
                    boite de dialogue }
                  if (AnnulerCopie) or (ReponseRemplacement = mrCancel)
                  then
                      break ;
              end ;
            end;
        finally
            { Indique la fin du drag&Drop }
            DragFinish(Msg.Drop);

            { Restaure l'icone dans la barre des t�ches }
            IconeEnCours := 0 ;
            ModifieIcone('') ;

            { D�truit la fen�tre de copie }
            FCopier.Free ;

            { Indique la fin de la copie }
            CopieEnCours := False ;

            { R�affiche la fen�tre m�re }
            Msg_SysTray.wParam := WM_LBUTTONDOWN ;
            MessageIcone(Msg_SysTray) ;

            { D�sactive le timer }
            TimerCopie.Enabled := False ;

            { Efface le message temporaire }
            MessageEncoursSysTray := '' ;
        end;

    finally
        { Lib�re la m�moire }
        FreeMem(Buf) ;

        { Indique la fin de la copie. On le mais aussi ici en cas de probl�me }
        CopieEnCours := False ;
    end ;
end;

{******************************************************************************
 * Cette proc�dure copie le fichier NomFicSource vers NomFicCible
 ******************************************************************************}
procedure TForm1.CopieFichier(NomFicSource : string; NomFicCible: string);

var
    FromF, ToF : file ;
    NumRead, NumWritten, TailleEcritAvecActualisation : integer ;
    TailleFichierSource, TailleFichierDestination : Integer ;
    tmp : Int64 ;
    CurTime: Cardinal;
    Temps: Integer;
    Attributs : Integer ;
begin
    FCopier.NomDuFichierEnCours.Caption := ExtractFileName(NomFicSource) ;

    CurTime := TimeGetTime;
    TailleEcritAvecActualisation := 0 ;

    { si on ne cherche pas � copier sur lui m�me }
    if AnsiUpperCase(NomFicSource) <> AnsiUpperCase(NomFicCible)
    then begin
        if FileExists(NomFicCible)
        then begin
            { On v�rifie que le fichier destination n'existe pas }
            if (ReponseRemplacement <> mrYesToAll) and (ReponseRemplacement <> mrNoToAll)
            then begin
                SetForegroundWindow(Handle) ;
                ReponseRemplacement := MessageDlg('Le fichier ''' + ExtractFileName(NomFicCible) + ''' existe d�j�, souhaitez-vous le remplacer ?', mtConfirmation, [mbYes, mbNo, mbNoToAll, mbYesToAll, mbCancel], 0) ;

                { Si on a cliqu� sur Annuler, on annule la copie }
                if ReponseRemplacement = mrCancel
                then begin
                    AnnulerCopie := True ;
                    Exit ;
                end ;
            end ;
        end
        else begin
            ReponseRemplacement := mrYes ;
        end ;


        if (ReponseRemplacement = mrYes) or (ReponseRemplacement = mrYesToAll)
        then begin
            { Ouvre le fichier source en lecture seule }
            FileMode := fmOpenRead ;
            { ouverture du fichier source }
            AssignFile(FromF, NomFicSource);
            { Taille d'enregistrement = 1 }
            Reset(FromF, 1);
            { Taille du fichier source }
            TailleFichierSource := FileSize(FromF);

            { V�rification de la taille disponible sur le support }
            if FileExists(NomFicCible)
            then begin
                { ouverture du fichier destination }
                AssignFile(ToF, NomFicCible);
                { Taille d'enregistrement = 1 }
                Reset(ToF, 1);
                { Taille du fichier destination }
                TailleFichierDestination := FileSize(ToF);
                { Ferme le fichier }
                CloseFile(ToF) ;

                { Si le fichier qu'on veut copier est plus grand que le fichier
                  pr�sent sur le disque }
                if TailleFichierSource > TailleFichierDestination
                then begin
                    if GetDiskSize(ExtractFileDrive(NomFicCible)) < (TailleFichierSource - TailleFichierDestination)
                    then begin
                        MessageDlg('Espace disque insuffisant. copie annul�e.', mtError, [mbOK], 0) ;
                        AnnulerCopie := True ;
                        Exit ;
                    end ;
                end ;

            end
            else begin
                { Si on n'a pas assez de place, on annule la copie }
                if GetDiskSize(ExtractFileDrive(NomFicCible)) < TailleFichierSource
                then begin
                    MessageDlg('Espace disque insuffisant. copie annul�e.', mtError, [mbOK], 0) ;
                    AnnulerCopie := True ;
                    Exit ;
                end ;
            end ;

            TailleFichierDestination := 0 ;
                        
            { Ouvre le fichier destination en �criture seule }
            FileMode := fmOpenWrite ;
            { Ouverture du fichier de sortie }
            AssignFile(ToF, NomFicCible);
            { Taille d'enregistrement = 1 }
            Rewrite(ToF, 1);

            try
                repeat
                    BlockRead(FromF, Buf^, TailleTamponCopie, NumRead);
                    BlockWrite(ToF, Buf^, NumRead, NumWritten);

                    Application.ProcessMessages ;

                    { Incr�ment la taille du fichier }
                    TailleFichierDestination := TailleFichierDestination + NumWritten ;

                    { Calcule le % de progression }
                    if TailleFichierSource <> 0  { Evite la division par z�ro }
                    then begin
                        tmp := TailleFichierDestination ;
                        tmp := tmp * 100 ;
                        tmp := tmp div TailleFichierSource ;
                        FCopier.ProgressBar1.Position := tmp ;
                    end ;

                    { Permet le traitement des message Windows et �vite le blocage
                      de l'application }
                    Application.ProcessMessages ;

                    { Affichage du temps restant toutes les secondes }
                    TailleEcritAvecActualisation := TailleEcritAvecActualisation + NumRead ;

                    if (TimeGetTime - CurTime >= 1000) and (TailleFichierSource <> 0) { Evite la division par z�ro }
                    then begin
                        Temps := Round((((TimeGetTime - CurTime) / TailleEcritAvecActualisation) * (TailleFichierSource - TailleFichierDestination)) / 1000);
                        TailleEcritAvecActualisation := 0;
                        CurTime := TimeGetTime;
                        FCopier.ElapsedTime.Caption := AffTime(Temps);

                        Application.ProcessMessages ;
                    end ;
                until (NumRead = 0) or (NumWritten <> NumRead) or (AnnulerCopie = True) ;

            finally
                CloseFile(FromF);
                CloseFile(ToF);
            end ;
                
            { Si on a annul� la copie, on supprime le fichier en cours s'il n'est
              pas termin� de copi� }
            if (AnnulerCopie = True) and (TailleFichierDestination <> TailleFichierSource)
            then begin
                DeleteFile(NomFicCible) ;
            end
            else begin
                { Copie termin� mais pas pour annulation }
                if CopyAttributs
                then begin
                    Attributs := FileGetAttr(NomFicSource) ;
                    FileSetAttr(NomFicCible, Attributs) ;
                end ;
            end ;

        end ;
    end
    else begin
        MessageDlg('Vous tentez de copier des fichiers sur eux m�me. Copie annul�e.', mtError, [mbOK], 0) ;
        AnnulerCopie := True ;
    end ;
end;

{******************************************************************************
 * Conversion "hh:mm:ss" d'un entier rep�sentant des secondes
 ******************************************************************************}
function TForm1.AffTime(ts: Integer): String;
var
    th: TTimeStamp;
begin
    th.Time := ts * 1000;
    th.Date := 1;
    DateTimeToString(Result, 'hh:nn:ss', TimeStampToDateTime(th));
end;

{******************************************************************************
 * Proc�dure qui change l'icone dans la barre de t�che lors de la copie de fichiers
 ******************************************************************************}
procedure TForm1.TimerCopieTimer(Sender: TObject);
begin
    TTimer(Sender).Interval := 600 ;

    if IconeEnCours = 0
    then
        IconeEnCours := 1
    else
        IconeEnCours := 0 ;

    ModifieIcone(MessageEncoursSysTray) ;
end;

{******************************************************************************
 * Retourne l'espace disponible d'un lecteur
 ******************************************************************************}
function TForm1.GetDiskSize(lecteur : String): int64 ;
Var
    Drive : array[0..255] of char ;
    TailleDisque : int64 ;
begin
    try
        TailleDisque := 0 ;
        strPCopy(Drive, lecteur) ;
        GetDiskFreeSpaceEx(Drive, Result, TailleDisque, nil) ;
    except
        Result := 0 ;
    end ;
end ;

{******************************************************************************
 * Procedure qui copie un r�pertoire
 ******************************************************************************}
procedure TForm1.CopierRepertoire(Chemin : String; CheminCible : String) ;
var
    S : TSearchRec ;
    Attributs : Integer ;
begin
    { Cr�er le r�pertoire}
    CheminCible := IncludeTrailingPathDelimiter(CheminCible) ;

    if not DirectoryExists(CheminCible)
    then begin
        MkDir(CheminCible) ;

        if CopyAttributs
        then begin
            Attributs := FileGetAttr(Chemin) ;
            FileSetAttr(CheminCible, Attributs) ;
        end ;
    end ;

    Chemin := IncludeTrailingPathDelimiter(Chemin) ;

    { Recherche de la premi�re entr�e du r�pertoire }
    if FindFirst(Chemin + '*.*', faAnyFile, S) = 0
    then begin
        repeat
            { Il faut absolument dans le cas d'une proc�dure r�cursive ignorer
              les . et .. qui sont toujours plac�s en d�but de r�pertoire
              Sinon la proc�dure va boucler sur elle-m�me. }
            if (S.Name <> '.') and (S.Name <> '..')
            then begin
                Application.ProcessMessages ;

                {  Dans le cas d'un sous-repertoire on appelle la m�me proc�dure }
                if ((S.Attr and faDirectory) <> 0) and (AnnulerCopie <> True)
                then
                    CopierRepertoire(Chemin + S.FindData.cFileName, CheminCible + S.FindData.cFileName)
                else
                    { Copie le fichier }
                    CopieFichier(Chemin + S.FindData.cFileName, CheminCible + S.FindData.cFileName);
            end;
        { Recherche du suivant }
        until ((FindNext(S)) <> 0) or (AnnulerCopie = True);

        FindClose(S);
    end;
end;

{******************************************************************************
 * Procedure qui applique le th�me
 ******************************************************************************}
procedure TForm1.SetSkin(ThemeLocal : String) ;
Var 
    ThemeDir : String ;
    SkinIni: TIniFile;
    Section, Value : String ;
    Tmp : String ;

    procedure SetUpButton(Bouton : TGlyphButton; SkinIni: TIniFile; Section : String) ;
    Var Value : String ;
    begin
        Value := 'image' ;
        { Bouton close }
        if SkinIni.ValueExists(Section, Value)
        then begin
            Tmp := SkinIni.ReadString(Section, Value , '') ;
            Tmp := ThemeDir + Tmp ;
            Bouton.Bild_Button.LoadFromFile(Tmp);
        end ;

        Value := 'imageOver' ;
        if SkinIni.ValueExists(Section, Value)
        then begin
            Tmp := SkinIni.ReadString(Section, Value , '') ;
            Tmp := ThemeDir + Tmp ;
            Bouton.Bild_MouseOver.LoadFromFile(Tmp);
        end ;

        Value := 'imageClick' ;
        if SkinIni.ValueExists(Section, Value)
        then begin
            Tmp := SkinIni.ReadString(Section, Value , '') ;
            Tmp := ThemeDir + Tmp ;
            Bouton.Bild_Down.LoadFromFile(Tmp);
        end ;

        Value := 'Left' ;
        if SkinIni.ValueExists(Section, Value)
        then begin
            Bouton.Left := SkinIni.ReadInteger(Section, Value , 0) ;
        end ;

        Value := 'Top' ;
        if SkinIni.ValueExists(Section, Value)
        then begin
            Bouton.Top := SkinIni.ReadInteger(Section, Value , 0) ;
        end ;

        Bouton.Transparenzfarbe := clFuchsia ;
        Bouton.Transparent := True ;
        Bouton.AutoSize := True ;
    end ;

    procedure SetUpButtonStayOnTop(Bouton : TGlyphButton; SkinIni: TIniFile; Section : String) ;
    Var Value : String ;
        Bmp : TBitmap ;
    begin
        Bmp := TBitmap.Create ;

        try
            ImageList1.Clear ;
            ImageList1.Width := Bouton.Width ;
            ImageList1.Height := Bouton.Height ;            

            Value := 'imageSOT' ;
            { Bouton close }
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Bmp.LoadFromFile(Tmp);
                ImageList1.Add(Bmp, nil)
            end ;

            Value := 'imageOverSOT' ;
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Bmp.LoadFromFile(Tmp);
                ImageList1.Add(Bmp, nil)
            end ;

            Value := 'imageClickSOT' ;
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Bmp.LoadFromFile(Tmp);
                ImageList1.Add(Bmp, nil)
            end ;

            Value := 'image' ;
            { Bouton close }
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Bmp.LoadFromFile(Tmp);
                ImageList1.Add(Bmp, nil)
            end ;

            Value := 'imageOver' ;
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Bmp.LoadFromFile(Tmp);
                ImageList1.Add(Bmp, nil)
            end ;

            Value := 'imageClick' ;
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Bmp.LoadFromFile(Tmp);
                ImageList1.Add(Bmp, nil)
            end ;
        finally
            Bmp.Free ;
        end ;
    end ;

begin
    ThemeDir := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) + 'skins\' + ThemeLocal + '\' ;

    if (ThemeLocal <> '') and DirectoryExists(ThemeDir)
    then begin
        // Cr�er le fichier d'export
        Tmp := ThemeDir + 'skin.ini' ;
        SkinIni := TIniFile.Create(Tmp);

        { Cache la feuille }
        Self.Hide ;
        Self.Color := clFuchsia ;

        { Reinitialise la transparence }
        SupprimerTransparence(form1, Image1.Picture.Bitmap, clFuchsia);
        //Former(form1, Image1.Picture.Bitmap, clNone);

        try
            Section := 'Skin' ;
            Value := 'BackGround' ;

            { Image de fond }
            if SkinIni.ValueExists(Section, Value)
            then begin
                Tmp := SkinIni.ReadString(Section, Value , '') ;
                Tmp := ThemeDir + Tmp ;
                Image1.Picture.LoadFromFile(Tmp);
            end ;

            Section := 'Button_Close' ;
            SetUpButton(BoutonClose, SkinIni, Section) ;

            Section := 'Button_StayOnTop' ;
            SetUpButton(BoutonStayOnTop, SkinIni, Section) ;
            SetUpButtonStayOnTop(BoutonStayOnTop, SkinIni, Section) ;

            if StayOnTop.Checked
            then begin
                ImageList1.GetBitmap(0, BoutonStayOnTop.Bild_Button) ;
                ImageList1.GetBitmap(1, BoutonStayOnTop.Bild_MouseOver) ;
                ImageList1.GetBitmap(2, BoutonStayOnTop.Bild_Down) ;
            end ;

            Section := 'Button_Minimize' ;
            SetUpButton(BoutonMinimiser, SkinIni, Section) ;

            Section := 'Button_Menu' ;
            SetUpButton(BoutonMenu, SkinIni, Section) ;

            Section := 'Button_Dir' ;
            SetUpButton(BoutonDossier, SkinIni, Section) ;

            Section := 'Button_About' ;
            SetUpButton(BoutonApropos, SkinIni, Section) ;

        finally
            SkinIni.Free ;
        end ;
    end ;

    { modifie la form en fonction de bmp et de la couleur du premier pixel en haut a gauche }
    //clFuchsia � la place de Image1.Picture.Bitmap.Canvas.Pixels[0,0]
    former(form1, Image1.Picture.Bitmap, clFuchsia);
    Self.Color := clNone ;
    Self.Show ;
end ;

{******************************************************************************
 * Affiche la fen�tre de th�me
 ******************************************************************************}
procedure TForm1.SkinMenuClick(Sender: TObject);
Var FSkin : TFormSkin ;
begin
    FSkin := TFormSkin.Create(Self);
    FSkin.ShowModal ;
    FSkin.Free ;
end;

{******************************************************************************
 * Enregistre le th�me
 ******************************************************************************}
procedure TForm1.SaveSkin(ThemeLocal : String) ;
Var Registre : TRegistry ;
begin
    Registre := TRegistry.Create ;

    try
        { Lancer au d�marrage de la session }
        Registre.RootKey := HKEY_CURRENT_USER ;
        Registre.OpenKey(CHEMIN_REGISTRE, True) ;

        Registre.WriteString('Skin', ThemeLocal);

    finally
        Registre.Free ;
    end ;
end ;

{******************************************************************************}
{* Cr�er la transparence
 *
 * Source original de Marchioni Val�rian
 * loub1@caramail.com
 * icq: 30687888
 *
{******************************************************************************}
procedure Tform1.SupprimerTransparence(Obj : tform; img : tbitmap; couleur : tcolor);
var
    x, y, regtemp, debut, fin : integer ;
    etaitblanc, first : boolean ;
    Transparancy : Boolean ;
    reg, reg2 : Integer ;
begin
     obj.height := img.height ;   // on adapte les
     obj.width := img.width ;     // dimensions de la fiche

     { Indique qu'il y eu une transparance de cr�� }
     Transparancy := False ;

     first := true ;              // c'est pour savoir si on a deja cr�� une
                                  // r�gion : voir CombineRgn (n�cessite une region non vide)
     reg := 0 ;

     for y := 1 to img.height - 1 do
     begin
         debut := 1 ;             // debut = debut de la zone non-traansparente
         //fin := 1 ;               // fin  =fin   """"""""""""""""""""""""""""
         etaitblanc := true ;     //etaitblanc, c'est pour savoir si le pixel examin� pr�c�demment �tait
                                  //transparent ou pas (ben oui j'avais d'abord commenc� par le blanc, ce serait
                                  //plus logique d'appeler cette variable etaittraansparente, mais c'est trop long a ecrire
         for x := 1 to img.width do
         begin

             // si le pixel est transparent
             if img.Canvas.Pixels[x, y] = couleur
             then begin
                 Transparancy := True ;

                 // et que le pr�c�dent ne l'etait pas
                 if etaitblanc = false
                 then begin
                     fin := x - 1 ;   // le dernier pixel non transparent etait le precedent

                     // si c'est la 1�region qu'on cr�e:
                     if first = true
                     then begin
                         reg := CreateRectRgn(debut, y, fin + 1, y + 1) ; // on la cr�e
                         first := false ;                                 // la prochaine ne sera plus la premiere
                     end
                     else begin
                         // si c'est pas la premiere region
                         regtemp := createrectrgn(debut, y, fin + 1, y + 1) ; // on en cr�e une temporaire
                         CombineRgn(reg, reg, regtemp, rgn_or) ;              // on l'ajoute � reg qui sera la region finale avec rgn_or (voir autres possibilit�s dans l'aide)
                         deleteobject(regtemp) ;                              // on supprime la region temporaire pour rester propres (si on ne le fait pas, ca se fait autom. qd on ferme l'application)
                     end ;
                 end ;

                 etaitblanc := true ;
             end
             else begin
                 // le pixel n'est pas transparent
                 if etaitblanc = true
                 then
                     debut := x ; //ben oui rien que ca

                 etaitblanc := false ;

                 // on arrive au dernier point de la ligne
                 if x = img.width - 1
                 then
                     // si c'est la 1�region qu'on cr�e:
                     if first = true
                     then begin
                         reg := CreateRectRgn(debut, y, x, y + 1) ; // on la cr�e
                         first := false ;                           // la prochaine ne sera plus la premiere
                     end
                     else begin
                         // si c'est pas la premiere region
                         regtemp := createrectrgn(debut, y, x, y + 1) ; //on en cr�e une temporaire
                         CombineRgn(reg, reg, regtemp, rgn_or) ; //on l'ajoute � reg qui sera la region finale avec rgn_or (voir autres possibilit�s dans l'aide)
                         deleteobject(regtemp) ; // on supprime la region temporaire pour rester propres (si on ne le fait pas, ca se fait autom. qd on ferme l'application)
                     end ;
             end ;
         end ;
     end ;

     reg2 := CreateRectRgn(0, 0, Self.Width, Self.Height) ;
     CombineRgn(reg, reg, reg2, rgn_or) ;

     { S'il y a eu une transparence de cr��, alors on l'affiche }
     if Transparancy
     then
         SetWindowRgn(Obj.handle, reg, true); // on applique la region
end ;

end.
