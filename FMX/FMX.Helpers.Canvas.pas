unit FMX.Helpers.Canvas;

interface

uses
  System.Types,
  FMX.Types,
  FMX.Graphics;

type
{$REGION 'TFMXCanvasHelper'}
  /// <summary> Simplifica el uso del Canvas FMX </summary>
  TFMXCanvasHelper = class helper for FMX.Graphics.TCanvas
  public
    procedure DrawText(const Bounds: TRectF; const Text: string; const TextAlign: TTextAlign);
    /// <summary> Dibuja el texto centrado dentro del rectangulo indicado </summary>
    procedure DrawCenteredText(const Bounds: TRectF; const Text: string);
     /// <summary> Dibuja el texto en formato "normal" (izquierda a derecha) dentro del rectangulo indicado </summary>
    procedure DrawLeadignText(const Bounds: TRectF; const Text: string);
     /// <summary> Dibuja el texto en formato "justificado" (derecha a izquierda) dentro del rectangulo indicado </summary>
    procedure DrawTrailingText(const Bounds: TRectF; const Text: string);
  end;
{$ENDREGION}

implementation

{$REGION 'TFMXCanvasHelper'}

procedure TFMXCanvasHelper.DrawCenteredText(const Bounds: TRectF; const Text: string);
begin
  DrawText(Bounds, Text, TTextAlign.Center);
end;

procedure TFMXCanvasHelper.DrawLeadignText(const Bounds: TRectF; const Text: string);
begin
  DrawText(Bounds, Text, TTextAlign.Leading);
end;

procedure TFMXCanvasHelper.DrawTrailingText(const Bounds: TRectF; const Text: string);
begin
  DrawText(Bounds, Text, TTextAlign.Trailing);
end;

procedure TFMXCanvasHelper.DrawText(const Bounds: TRectF; const Text: string; const TextAlign: TTextAlign);
begin
  FillText(Bounds, Text, False, 1, [], TextAlign);
end;

{$ENDREGION}

end.
