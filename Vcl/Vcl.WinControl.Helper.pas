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
  end;
{$ENDREGION}

implementation

uses
  System.Classes;

{$REGION 'TWinControlHelper'}

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
