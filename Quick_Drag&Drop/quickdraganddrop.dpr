program quickdraganddrop;

uses
  Forms,
  XPTheme in 'XPTheme.pas',
  main in 'main.pas' {Form1},
  aproposde in 'aproposde.pas' {FormAproposde},
  parametres in 'parametres.pas' {FormParametres},
  FenetreCopier in 'FenetreCopier.pas' {FormCopier},
  FenetreTheme in 'FenetreTheme.pas' {FormSkin};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := true ;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
