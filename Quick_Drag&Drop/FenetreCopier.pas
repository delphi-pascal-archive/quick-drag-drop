unit FenetreCopier;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormCopier = class(TForm)
    Label1: TLabel;
    NomDuFichierEnCours: TLabel;
    ProgressBar1: TProgressBar;
    Annuler: TButton;
    Label2: TLabel;
    ElapsedTime: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure AnnulerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormCopier: TFormCopier;

implementation

uses main;

{$R *.dfm}

procedure TFormCopier.FormCreate(Sender: TObject);
Var     Rectangle : TRect ;
begin
    { Utilisation de SystemParametersInfo pour récupérer la surface (rectangle) de
      travail de l'écran disponible }
    SystemParametersInfo(SPI_GETWORKAREA, 0, @Rectangle, 0) ;

    { Permet de ne pas afficher la feuille en dehors de la zone }
    if (Form1.Top + Self.Height) < Rectangle.Bottom
    then begin
        if Form1.Top < 0
        then
            Self.Top := 0
        else
            Self.Top := Form1.Top ;
    end
    else
        Self.Top := Rectangle.Bottom - Self.Height ;

    if (Form1.Left + Self.Width) < Rectangle.Right
    then begin
        if Form1.Left < 0
        then
            Self.Left := 0
        else
            Self.Left := Form1.Left ;
    end
    else
        Self.Left := Rectangle.Right - Self.Width ;

    AlphaBlend := Form1.AlphaBlend ;
    AlphaBlendValue := Form1.AlphaBlendValue ;
end;

procedure TFormCopier.AnnulerClick(Sender: TObject);
begin
 Form1.AnnulerCopie := True ;
end;

procedure TFormCopier.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Form1.AnnulerCopie := True ;
end;

end.
