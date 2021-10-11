unit aproposde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellApi;

type
  TFormAproposde = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Image2: TImage;
    Timer1: TTimer;
    Label4: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormAproposde: TFormAproposde;

implementation

uses main;

{$R *.dfm}

procedure TFormAproposde.Button2Click(Sender: TObject);
begin
    Image2.Visible := not Image2.Visible ;
end;

procedure TFormAproposde.Timer1Timer(Sender: TObject);
begin
    Image2.Visible := not Image2.Visible ;
    TTimer(Sender).Interval := 600 ;
end;

{*******************************************************************************
 * Affiche le site internet
 ******************************************************************************}
procedure TFormAproposde.Label4Click(Sender: TObject);
begin
    ShellExecute(Handle, 'OPEN', PChar(TLabel(Sender).Caption),'','',SW_SHOWNORMAL);
end;

procedure TFormAproposde.FormCreate(Sender: TObject);
begin
    { Met la feuille au premier plan si la feuille ùère est au premier plan }
    if Form1.StayOnTop.Checked
    then begin
        { Met la feuille au premier plan et change les images du boutons }
        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE) ;
    end ;
end;

end.
