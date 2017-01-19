unit Vcl.WinControl.Helper;

interface

uses
  Vcl.Controls;

type
{$REGION 'TWinControlHelper'}
  TWinControlHelper = class helper for TWinControl
  public
    /// <summary> Intenta darle foco al control; devuelve True si tuvo exito, False en caso contrario </summary>
    /// <remarks> Este metodo captura y controla excepciones de tipo System.Classes.EInvalidOperation </remarks>
    function TrySetFocus: Boolean;
    /// <summary> Devuelve True si alguno de los controles del arreglo tiene foco; False en caso contrario </summary>
    class function AnyFocused(const Controls: TArray<TWinControl>): Boolean; overload;
    /// <summary> Devuelve True si alguno de los controles del arreglo tiene foco; False en caso contrario
    /// En caso de devolver True, el parametro de salida FocusedControl es asignado al primer control del arreglo
    /// que tiene foco </summary>
    class function AnyFocused(const Controls: TArray<TWinControl>; out FocusedControl: TWinControl): Boolean; overload;
  end;
{$ENDREGION}

implementation

uses
  System.Classes;

{$REGION 'TWinControlHelper'}

class function TWinControlHelper.AnyFocused(const Controls: TArray<TWinControl>): Boolean;
var
  Dummy: TWinControl;
begin
  Result := TWinControl.AnyFocused(Controls, Dummy);
end;

class function TWinControlHelper.AnyFocused(const Controls: TArray<TWinControl>;
  out FocusedControl: TWinControl): Boolean;
var
  Each: TWinControl;
begin
  for Each in Controls do
  begin
    if Each.Focused then
    begin
      FocusedControl := Each;
      Exit(True);
    end;
  end;

  FocusedControl := nil;
  Result := False;
end;

function TWinControlHelper.TrySetFocus: Boolean;
begin
  try
    Self.SetFocus;
    Result := True;
  except
    on E: EInvalidOperation do
    begin
      Result := False;
    end
    else
      raise;
  end;
end;

{$ENDREGION}

end.
