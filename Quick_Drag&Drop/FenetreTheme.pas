unit FenetreTheme;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, ComCtrls, Registry, IniFiles, ShellApi;

type
  TFormSkin = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Appliquer: TButton;
    Auteur: TLabel;
    Copyright: TLabel;
    DateOfCreation: TLabel;
    DateOfRevision: TLabel;
    Website: TLabel;
    Comment: TLabel;
    Valider: TButton;
    Annuler: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AppliquerClick(Sender: TObject);
    procedure ValiderClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure WebsiteClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure AnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
    OldTheme : String ;
  public
    { Déclarations publiques }
  end;

var
  FormSkin: TFormSkin;

implementation

{$R *.dfm}

uses main ;

procedure TFormSkin.FormCreate(Sender: TObject);
var
    S : TSearchRec ;
    tmp : Integer ;
begin
    OldTheme := Form1.Theme ;
    
    ListBox1.Items.Add('Default') ;
    
    if FindFirst(IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) + 'skins\*.*', faDirectory, S) = 0
    then begin
        repeat
            { Il faut absolument dans le cas d'une procédure récursive ignorer
              les . et .. qui sont toujours placés en début de répertoire
              Sinon la procédure va boucler sur elle-même. }
            if (S.Name <> '.') and (S.Name <> '..')
            then begin
                ListBox1.Items.Add(S.Name);
            end;
        { Recherche du suivant }
        until (FindNext(S) <> 0) ;

        FindClose(S);
    end;

    Tmp := ListBox1.Items.IndexOf(Form1.Theme) ;

    if Tmp <> -1
    then begin
        ListBox1.Selected[Tmp] ;
        ListBox1.ItemIndex := Tmp ;
    end ;

    ListBox1Click(Self) ;    
end;

procedure TFormSkin.AppliquerClick(Sender: TObject);
Var tmp : String ;
begin
    tmp := ListBox1.Items.Strings[ListBox1.ItemIndex] ;

    if tmp = 'Default'
    then
        MessageDlg('L''application du thème par défaut nécessite un redémarrage de l''application.', mtWarning, [mbOK], 0)
    else
        Form1.SetSkin(tmp) ;
end;

procedure TFormSkin.ValiderClick(Sender: TObject);
Var tmp : String ;
begin
    tmp := ListBox1.Items.Strings[ListBox1.ItemIndex] ;

    if tmp = 'Default'
    then
        tmp := '' ;
        
    Form1.SaveSkin(tmp);

    AppliquerClick(Sender) ;

    Close ;
end;

procedure TFormSkin.ListBox1Click(Sender: TObject);
Var SkinIni : TIniFile ;
    Section : String ;
    tmp : String ;
begin
    if ListBox1.ItemIndex <> -1
    then begin
        tmp := ListBox1.Items.Strings[ListBox1.ItemIndex] ;

        if tmp <> 'Default'
        then begin
            if ListBox1.ItemIndex <> -1
            then begin
                SkinIni := TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) + 'skins\' + tmp + '\skin.ini');

                try
                    Section := 'AboutSkin' ;

                    Auteur.Caption := SkinIni.ReadString(Section, 'Author' , '') ;
                    Copyright.Caption := SkinIni.ReadString(Section, 'Copyright' , '') ;
                    DateOfCreation.Caption := 'Date de création : ' + SkinIni.ReadString(Section, 'DateOfCreation' , '') ;
                    DateOfRevision.Caption := 'Date de révision :' + SkinIni.ReadString(Section, 'DateOfRevision' , '') ;
                    WebSite.Caption := SkinIni.ReadString(Section, 'WebSite' , '') ;
                    Comment.Caption := SkinIni.ReadString(Section, 'Comment' , '') ;
                finally
                    SkinIni.Free ;
                end ;
            end ;
        end
        else begin
            Auteur.Caption := 'MARTINEAU Emeric' ;
            Copyright.Caption := '2005 (C) MARTINEAU Emeric' ;
            DateOfCreation.Caption := 'Date de création : 04/10/2005' ;
            DateOfRevision.Caption := 'Date de révision :' ;
            WebSite.Caption := 'http://php4php.free.fr/quickdraganddrop' ;
            Comment.Caption := '' ;
        end ;
    end ;
end;

procedure TFormSkin.WebsiteClick(Sender: TObject);
begin
    ShellExecute(Handle, 'OPEN', PChar(TLabel(Sender).Caption),'','',SW_SHOWNORMAL);
end;

procedure TFormSkin.ListBox1DblClick(Sender: TObject);
begin
    AppliquerClick(Appliquer) ;
end;

procedure TFormSkin.AnnulerClick(Sender: TObject);
begin
    Form1.SetSkin(OldTheme) ;
end;

end.
