unit RTL.Strings;

interface

type
{$REGION 'TString'}
  /// <summary> Utility functions related to strings </summary>
  TString = record
    /// <summary> Returns True if the given string is an Integer </summary>
    class function IsInteger(const Value: string): Boolean; static;
    /// <summary> Returns True if the given string is an Int64 </summary>
    class function IsInt64(const Value: string): Boolean; static;
  end;
{$ENDREGION}

implementation

uses
  System.SysUtils;

{$REGION 'TString'}

class function TString.IsInt64(const Value: string): Boolean;
var
  Dummy: Int64;
begin
  Result := TryStrToInt64(Value, Dummy);
end;

class function TString.IsInteger(const Value: string): Boolean;
var
  Dummy: Integer;
begin
  Result := TryStrToInt(Value, Dummy);
end;

{$ENDREGION}

end.
