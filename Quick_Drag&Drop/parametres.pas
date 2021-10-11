{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
unit parametres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask, Registry, FileCtrl, ExtCtrls;

type
  TFormParametres = class(TForm)
    Label1: TLabel;
    Cible: TEdit;
    Button1: TButton;
    Label2: TLabel;
    TransparenceTrackBar: TTrackBar;
    AutoAddIconWhenCibleIsOk: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    TimerVerifEditText: TEdit;
    UpDown1: TUpDown;
    AfficherEnBasADroite: TCheckBox;
    SaveWindowPos: TCheckBox;
    Button2: TButton;
    Annuler: TButton;
    RunAsStartup: TCheckBox;
    TransparenceEditText: TEdit;
    Label3: TLabel;
    ShowInSeparetedWindow: TCheckBox;
    Button3: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    CopyAttributs: TCheckBox;
    Label6: TLabel;
    TailleTamponCopie: TEdit;
    Bevel3: TBevel;
    UpDown2: TUpDown;
    procedure Label4Click(Sender: TObject);
    procedure AutoAddIconWhenCibleIsOkClick(Sender: TObject);
    procedure AfficherEnBasADroiteClick(Sender: TObject);
    procedure SaveWindowPosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TransparenceTrackBarChange(Sender: TObject);
    procedure TransparenceEditTextChange(Sender: TObject);
    procedure TransparenceEditTextKeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormParametres: TFormParametres;

const
    CHEMIN_REGISTRE = 'Software\Quick Drag&Drop' ;

implementation
uses main ;
{$R *.dfm}

procedure TFormParametres.Label4Click(Sender: TObject);
begin
    AutoAddIconWhenCibleIsOk.Checked := not AutoAddIconWhenCibleIsOk.Checked ;
end;

procedure TFormParametres.AutoAddIconWhenCibleIsOkClick(Sender: TObject);
begin
    Label5.Enabled := TCheckBox(Sender).Checked ;
    Label4.Enabled := TCheckBox(Sender).Checked ;
    Label3.Enabled := TCheckBox(Sender).Checked ;    
    TimerVerifEditText.Enabled := TCheckBox(Sender).Checked ;
    UpDown1.Enabled := TCheckBox(Sender).Checked ;
end;

procedure TFormParametres.AfficherEnBasADroiteClick(Sender: TObject);
begin
    if TCheckBox(Sender).Checked
    then
        SaveWindowPos.Checked := False ;
end;

procedure TFormParametres.SaveWindowPosClick(Sender: TObject);
begin
    if TCheckBox(Sender).Checked
    then
        AfficherEnBasADroite.Checked := False ;
end;

procedure TFormParametres.FormCreate(Sender: TObject);
Var Registre : TRegistry ;
begin
    Registre := TRegistry.Create ;

    try
        { Lancer au démarrage de la session }
        Registre.RootKey := HKEY_CURRENT_USER ;
        Registre.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) ;

        RunAsStartup.Checked := Registre.ValueExists('QuickDrag&Drop') ;

        Registre.CloseKey ;

        Registre.OpenKey(CHEMIN_REGISTRE, True) ;

        { Chemin }
        if Registre.ValueExists('Disk')
        then
            Cible.Text := Registre.ReadString('Disk');

        { Transparence }
        if Registre.ValueExists('Transparence')
        then
            TransparenceTrackBar.Position := Registre.ReadInteger('Transparence');

        { Afficher en bas à droite }
        if Registre.ValueExists('AfficherEnBasADroite')
        then
            AfficherEnBasADroite.Checked := Registre.ReadBool('AfficherEnBasADroite');

        { Mémorise position de la fenêtre }
        if Registre.ValueExists('SaveWindowPos')
        then
            SaveWindowPos.Checked := Registre.ReadBool('SaveWindowPos');

        { AjoutAutomatique d'une icone si appareil mis }
        if Registre.ValueExists('AutoAddIconWhenCibleIsOk')
        then
            AutoAddIconWhenCibleIsOk.Checked := Registre.ReadBool('AutoAddIconWhenCibleIsOk');

        if Registre.ValueExists('Timer')
        then
             UpDown1.Position := Registre.ReadInteger('Timer') ;

        { Affiche le lecteur dans une fenêtre séparée }
        if Registre.ValueExists('ShowInSeparetedWindow')
        then
            ShowInSeparetedWindow.Checked := Registre.ReadBool('ShowInSeparetedWindow')
        else
            ShowInSeparetedWindow.Checked := True ;

        { Copie les attributs des fichiers }
        if Registre.ValueExists('CopyAttributs')
        then begin
            CopyAttributs.Checked := Registre.ReadBool('CopyAttributs');
        end
        else
            CopyAttributs.Checked := True ;

        { Taille du tampon pour la copie }
        if Registre.ValueExists('TailleTamponCopie')
        then begin
            UpDown2.Position := Registre.ReadInteger('TailleTamponCopie') ;
        end
        else
            UpDown2.Position := 4096 ;

        Registre.CloseKey ;
    finally
        Registre.Free ;
    end ;

    if (OSInfos.dwMajorVersion < 5)
    then begin
        Label2.Enabled := False ;
        TransparenceTrackBar.Enabled := False ;
        TransparenceEditText.Enabled := False ;
    end ;

    { Met la feuille au premier plan si la feuille ùère est au premier plan }
    if Form1.StayOnTop.Checked
    then begin
        { Met la feuille au premier plan et change les images du boutons }
        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE) ;
    end ;
end;

procedure TFormParametres.Button2Click(Sender: TObject);
Var Registre : TRegistry ;
    Rectangle : TRect ;
begin
    Registre := TRegistry.Create ;

    { Utilisation de SystemParametersInfo pour récupérer la surface (rectangle) de
      travail de l'écran disponible }
    SystemParametersInfo(SPI_GETWORKAREA, 0, @Rectangle, 0) ;

    try
        Registre.RootKey := HKEY_CURRENT_USER ;
        Registre.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) ;

        { Lancement au démarage de l'odinateur }
        if RunAsStartup.Checked = True
        then begin
            Registre.WriteString('QuickDrag&Drop', Application.ExeName) ;
        end
        else begin
            { Si on ne lance pas au démarrage de l'ordi on supprime la clef }
            Registre.DeleteValue('QuickDrag&Drop') ;
        end ;

        Registre.CloseKey ;

        Registre.OpenKey(CHEMIN_REGISTRE, True) ;

        { Chemin }
        Registre.WriteString('Disk', IncludeTrailingPathDelimiter(Cible.Text));
        { Transparence }
        Registre.WriteInteger('Transparence', TransparenceTrackBar.Position);
        { Afficher en bas à droite }
        Registre.WriteBool('AfficherEnBasADroite', AfficherEnBasADroite.Checked);

        if AfficherEnBasADroite.Checked
        then begin
            Form1.Left := Rectangle.Right - Form1.Width ;
            Form1.Top := Rectangle.Bottom - Form1.Height ;
        end ;

        { Mémoriser position fenêtre }
        Registre.WriteBool('SaveWindowPos', SaveWindowPos.Checked);

        { AjoutAutomatique d'une icone si appareil mis }
        Registre.WriteBool('AutoAddIconWhenCibleIsOk', AutoAddIconWhenCibleIsOk.Checked);

        if AutoAddIconWhenCibleIsOk.Checked
        then begin
            Registre.WriteInteger('Timer', StrToInt(TimerVerifEditText.Text));
        end ;

        { Affiche dans une fenêtre séparée }
        Registre.WriteBool('ShowInSeparetedWindow', ShowInSeparetedWindow.Checked);

        { Copier les attributs }
        Registre.WriteBool('CopyAttributs', CopyAttributs.Checked);

        { Taille du tampon pour la copie }
        Registre.WriteInteger('TailleTamponCopie', StrToInt(TailleTamponCopie.Text));

        Registre.CloseKey ;
    finally
        Registre.Free ;
    end ;
end;

procedure TFormParametres.Button1Click(Sender: TObject);
Var S : String ;
begin
    { Affiche la boite de dialogue de répertoire }
    if SelectDirectory('Sélectionnez un répertoire ou un lecteur.', '', S)
    then begin
        Cible.Text := IncludeTrailingPathDelimiter(S) ;
    end ;
end;

procedure TFormParametres.TransparenceTrackBarChange(Sender: TObject);
begin
    TransparenceEditText.Text := IntToStr(TTrackBar(Sender).Position) ;

    if TTrackBar(Sender).Position = 0
    then
        Form1.AlphaBlend := False
    else
        Form1.AlphaBlend := True ;

    Form1.AlphaBlendValue := 255 - TTrackBar(Sender).Position ;
end;

procedure TFormParametres.TransparenceEditTextChange(Sender: TObject);
begin
    if TEdit(Sender).Text <> ''
    then begin
        if StrToInt(TEdit(Sender).Text) > 255
        then
            TEdit(Sender).Text := '255' ;

        TransparenceTrackBar.Position := StrToInt(TEdit(Sender).Text) ;
    end
    else
        TEdit(Sender).Text := '0' ;

end;


procedure TFormParametres.TransparenceEditTextKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key > Char(31)
    then begin
        if (Key >= '0') and (Key <= '9')
        then
        else
            Key := #0 ;
    end ;
end;

procedure TFormParametres.Button3Click(Sender: TObject);
begin
    TransparenceTrackBar.Position := 0 ;
    AutoAddIconWhenCibleIsOk.Checked := False ;
    ShowInSeparetedWindow.Checked := True ;
    AfficherEnBasADroite.Checked := False ;
    SaveWindowPos.Checked := False ;        
    RunAsStartup.Checked := False ;
end;

end.
