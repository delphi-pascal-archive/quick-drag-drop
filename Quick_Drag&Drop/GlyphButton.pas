{*******************************    ENGLISH   **********************************}
{*******************************************************************************}
{**                                                                           **}
{**  TGlyphButton is a fully customizable "Bitmap"-Button.                    **}
{**  It allows you to define Bitmaps for the states "normal", "mouseover",    **}
{**  "disabled" and "down". It also supports transparency definde by a Color. **}
{**  If you design round buttons, you also can create a clipping plane,       **}
{**  so that the button only then changes the style if the mouse is inside    **}
{**  this plane. Additional: Autosize-Feature                                 **}
{**                                                                           **}
{**  Author:    WebCheck                                                      **}
{**  E-Mail:    webcheck@arcor.de                                             **}
{**  Home Page: http://webcheck.we.ohost.de                                   **}
{**  Copyright © 2005 by WebCheck.                                            **}
{**                                                                           **}
{*******************************************************************************}
{*******************************    DEUTSCH   **********************************}
{*******************************************************************************}
{**                                                                           **}
{**  TGlyphButton ist ein vollständig selbst designbarer "Bitmap"-Button.     **}
{**  Sie können für folgende Events eigene Bilder hinterlegen:                **}
{**  "normal" -> Der Originalzustand                                          **}
{**  "mouseover" -> Maus befindet sich über dem Button                        **}
{**  "disabled" -> Button wurde Disabled / Deaktiviert                        **}
{**  "down" -> Button wird gedrückt gehalten                                  **}
{**  Sie können eine Farbe für die Transparenz definieren.                    **}
{**  Ausserdem unterstützt der Button Clipping-Planes, also noch ein weiteres **}
{**  Bild, in dem sie festlegen können wo der button sich genau befindet,     **}
{**  und sich das design nur ändert, wenn die maus sich über dieser           **}
{**  Stelle befindet. Das AutoSize-Feature sorgt automatisch für die richtige **}
{**  Anppassung der Größe des Buttons.                                        **}
{**                                                                           **}
{**  Author:    WebCheck                                                      **}
{**  E-Mail:    webcheck@arcor.de                                             **}
{**  Home Page: http://webcheck.we.ohost.de                                   **}
{**  Copyright © 2005 by WebCheck.                                            **}
{**                                                                           **}
{*******************************************************************************}
{** History:
  10 feb 2005 - 1.0 First release.
********************************************************************************}

unit GlyphButton;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Messages, Types;

type TStatus = (normal, disabled, over, down);

type
  TGlyphButton = class(TGraphicControl)
  private
    { Private-Deklarationen }
    myTransparenzfarbe: TColor;
    myTransparent: Boolean;
    myClippingfarbe: TColor;
    myBild_Button: TBitmap;
    myBild_Disabled: TBitmap;
    myBild_MouseOver: TBitmap;
    myBild_Down: TBitmap;
    myBild_Clipping: TBitmap;
    myStatus: TStatus;
    myEnabled: Boolean;
    myAutoSize: Boolean;
    myClipping: Boolean;
    procedure myTransparenzfarbe_Update(NewColor: TColor);
    procedure myTransparent_Update(Transparent: Boolean);
    procedure myBild_Button_Update(NewBitmap: TBitmap);
    procedure myBild_Disabled_Update(NewBitmap: TBitmap);
    procedure myBild_MouseOver_Update(NewBitmap: TBitmap);
    procedure myBild_Down_Update(NewBitmap: TBitmap);
    procedure myBild_Clipping_Update(NewBitmap: TBitmap);
    procedure myClippingFarbe_Update(neu: TColor);
    procedure myEnabled_Update(neu: Boolean);
    procedure myAutoSize_Update(neu: Boolean);
    procedure myClipping_Update(neu: Boolean);
  protected
    { Protected-Deklarationen }
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    { Public-Deklarationen }
    constructor Create(Component: TComponent); override;
    destructor Destroy; override;
  published
    { Published-Deklarationen }
    property Transparenzfarbe: TColor read myTransparenzfarbe write myTransparenzfarbe_Update default clLime;
    property Transparent: Boolean read myTransparent write myTransparent_Update default FALSE;
    property Clippingfarbe: TColor read myClippingfarbe write myClippingfarbe_Update;
    property Bild_Button: TBitmap read myBild_Button write myBild_Button_Update;
    property Bild_Disabled: TBitmap read myBild_Disabled write myBild_Disabled_Update;
    property Bild_MouseOver: TBitmap read myBild_MouseOver write myBild_MouseOver_Update;
    property Bild_Down: TBitmap read myBild_Down write myBild_Down_Update;
    property Bild_Clipping: TBitmap read myBild_Clipping write myBild_Clipping_Update;
    property Enabled: Boolean read myEnabled write myEnabled_Update default TRUE;
    property AutoSize: Boolean read myAutoSize write myAutoSize_Update default TRUE;
    property Clipping: Boolean read myClipping write myClipping_Update default FALSE;
    property Visible;
    property OnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('meine', [TGlyphButton]);
end;

constructor TGlyphButton.Create(Component: TComponent);
begin
  inherited Create(Component);
  myTransparenzfarbe := clLime;
  Width := 150;
  Height := 25;
  myStatus := normal;
  myEnabled := TRUE;
  myAutoSize := TRUE;
  myClipping := FALSE;
  myBild_Button := TBitmap.Create;
  myBild_Disabled := TBitmap.Create;
  myBild_MouseOver := TBitmap.Create;
  myBild_Down := TBitmap.Create;
  myBild_Clipping := TBitmap.Create;
end;

destructor TGlyphButton.Destroy;
begin
  myBild_Button.Free;
  myBild_Disabled.Free;
  myBild_MouseOver.Free;
  myBild_Down.Free;
  myBild_Clipping.Free;
  inherited Destroy;
end;

procedure TGlyphButton.Paint;
var
  Source: TBitmap;
begin
  Source := TBitmap.Create;
  if Enabled = FALSE then myStatus := disabled;
  if (myStatus = normal) and (myBild_Button <> nil) then Source.Assign(myBild_Button);
  if (myStatus = disabled) and (myBild_Disabled <> nil) then Source.Assign(myBild_Disabled);
  if (myStatus = over) and (myBild_MouseOver <> nil) then Source.Assign(myBild_MouseOver);
  if (myStatus = down) and (myBild_Down <> nil) then Source.Assign(myBild_Down);

  if myTransparent = TRUE then begin
    Source.TransparentMode := tmFixed;
    Source.TransparentColor := myTransparenzfarbe;
    Source.Transparent := myTransparent;
  end;

  Canvas.Draw(0, 0, Source);

  Source.Free;
end;

procedure TGlyphButton.myAutoSize_Update(neu: Boolean);
begin
  myAutoSize := neu;
  if (myAutoSize = TRUE) and (myBild_Button <> nil) then begin
    Width := myBild_Button.Width;
    Height := myBild_Button.Height;
  end;
  Invalidate;
end;

procedure TGlyphButton.myTransparenzfarbe_Update(NewColor: TColor);
begin
  myTransparenzfarbe := NewColor;
  Invalidate;
end;

procedure TGlyphButton.myClippingFarbe_Update(neu: TColor);
begin
  myClippingFarbe := neu;
  Invalidate;
end;

procedure TGlyphButton.myEnabled_Update(neu: Boolean);
begin
  myEnabled := neu;
  if Enabled = TRUE then myStatus := normal
                    else myStatus := disabled;
  Invalidate;
end;

procedure TGlyphButton.myClipping_Update(neu: Boolean);
begin
  myClipping := neu;
  Invalidate;
end;

procedure TGlyphButton.myTransparent_Update(Transparent: Boolean);
begin
  myTransparent := Transparent;
  Invalidate;
end;


procedure TGlyphButton.myBild_Button_Update(NewBitmap: TBitmap);
begin
  myBild_Button.Assign(NewBitmap);
  myAutoSize_Update(myAutoSize);
  Invalidate;
end;

procedure TGlyphButton.myBild_Disabled_Update(NewBitmap: TBitmap);
begin
  myBild_Disabled.Assign(NewBitmap);
  Invalidate;
end;

procedure TGlyphButton.myBild_MouseOver_Update(NewBitmap: TBitmap);
begin
  myBild_MouseOver.Assign(NewBitmap);
  Invalidate;
end;

procedure TGlyphButton.myBild_Down_Update(NewBitmap: TBitmap);
begin
  myBild_Down.Assign(NewBitmap);
  Invalidate;
end;

procedure TGlyphButton.myBild_Clipping_Update(NewBitmap: TBitmap);
begin
  myBild_Clipping.Assign(NewBitmap);
  Invalidate;
end;

procedure TGlyphButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldStatus: TStatus;
begin
  if myStatus = disabled then abort;  // falls deaktiviert gibts nichts zu tun

  OldStatus := myStatus;
  if PtInRect(Rect(0, 0, width, height), Point(x, y)) then begin
    // Die Clipping-Planbe prüfen :)
    if myClipping = TRUE then begin
      if myBild_Clipping.Canvas.Pixels[x, y] = myClippingFarbe then begin
        myStatus := over;
        MouseCapture := TRUE;  // Mausereignisse abfangen
      end else begin
        myStatus := normal;
        MouseCapture := FALSE;
      end;
    end else begin  // keine Clippingplane definiert
      myStatus := over;
      MouseCapture := TRUE;  // Mausereignisse abfangen
    end;
  end else begin
    myStatus := normal;
    MouseCapture := FALSE;
  end;

  // nur aktualisieren wenn Status geändert
  if OldStatus <> myStatus then begin
    Invalidate;
  end;

  inherited MouseMove(Shift, X, Y);  // Standardereigniss für weiterverarbeitung
end;

procedure TGlyphButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OldStatus: TStatus;
begin
  if myStatus = disabled then abort;  // falls deaktiviert gibts nichts zu tun

  OldStatus := myStatus;

  if Button = mbLeft then begin
    myStatus := down;
  end;

  // nur aktualisieren wenn Status geändert
  if OldStatus <> myStatus then begin
    Invalidate;
  end;

  inherited MouseDown(Button, Shift, X, Y);  // Standardereigniss für weiterverarbeitung
end;

procedure TGlyphButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OldStatus: TStatus;
begin
  if myStatus = disabled then abort;  // falls deaktiviert gibts nichts zu tun

  OldStatus := myStatus;

  if Button = mbLeft then begin
    myStatus := normal;
  end;

  // nur aktualisieren wenn Status geändert
  if OldStatus <> myStatus then begin
    Invalidate;
  end;

  inherited MouseUp(Button, Shift, X, Y);  // Standardereigniss für weiterverarbeitung
end;

end.
