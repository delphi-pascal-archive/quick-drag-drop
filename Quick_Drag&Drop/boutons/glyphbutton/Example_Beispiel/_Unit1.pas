unit _Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GlyphButton;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Button3: TButton;
    ColorButton1: TGlyphButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure ColorButton1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  colorbutton1.Enabled := not colorbutton1.Enabled;
end;

procedure TForm1.ColorButton1Click(Sender: TObject);
begin
  colorbutton1.Transparenzfarbe := clWhite;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  colorbutton1.Transparent := not colorbutton1.Transparent;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  colorbutton1.Clipping := not colorbutton1.Clipping;
end;

end.
