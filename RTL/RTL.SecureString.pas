unit RTL.SecureString;

{****************************************************************************** }
{ *  ISecureString                                                             * }
{ *                                                                            * }
{ *  Created by Stefan van As <dutchdelphidude@gmail.com>                      * }
{ *                                                                            * }
{ *  DISCLAIMER                                                                * }
{ *                                                                            * }
{ *  This software is provided 'as is' with no explicit or implied warranties  * }
{ *  in respect of its properties, including, but not limited to, correctness  * }
{ *  and/or fitness for purpose.                                               * }
{ ****************************************************************************** }

{ Work by @Stefan van As, see his "Creating a SecureString type for Delphi" series:

Article #1: https://medium.com/@svanas/creating-a-securestring-type-for-delphi-part-1-e7e78ed1807c#.4qhm6x2zk
Article #2: https://medium.com/@svanas/creating-a-securestring-type-for-delphi-part-2-42e8a1762c3b#.w804uttap
Article #3: https://medium.com/@svanas/creating-a-securestring-type-for-delphi-part-3-f55bd04bc321#.hqqv8djxf

14-07-2016: Changes by @Agustin Ortu - https://github.com/ortuagustin/Delphi-Utils
  ISecureString: Adding GUID to the interface
  ISecureString: Changed Data function to property. Removed Length function
  ISecureString: Refactoring destructor: removed Windows.Winapi dependency }

interface

type
{$REGION 'ISecureString'}
  /// <summary> A string which its bytes gets zeroed when its deallocated from memory </summary>
  ISecureString = interface
    ['{546FDC48-2927-4C8B-B210-838C9559A8DB}']
    function GetValue: string;
    /// <summary> The actual string hold by the interface </summary>
    property Value: string read GetValue;
  end;
{$ENDREGION}

{$REGION 'SecureString'}
  /// <summary> Factory for ISecureString </summary>
  SecureString = record
  strict private type
{$REGION 'TSecureString'}
    TSecureString = class(TInterfacedObject, ISecureString)
    strict private
      FValue: string;
      function GetValue: string; inline;
    public
      constructor Create(const Value: string);
      destructor Destroy; override;
    end;
{$ENDREGION}
  private
    class procedure ZeroStringBytes(const Value: string); static; inline;
  public
    class function Create(const Value: string): ISecureString; static; inline;
  end;
{$ENDREGION}

implementation

{$REGION 'SecureString'}

class function SecureString.Create(const Value: string): ISecureString;
begin
  Result := SecureString.TSecureString.Create(Value);
  SecureString.ZeroStringBytes(Value);
end;

class procedure SecureString.ZeroStringBytes(const Value: string);
begin
  if (System.Length(Value) > 0) and (System.StringRefCount(Value) in [0, 1]) then
    System.FillChar(Pointer(Value)^, System.Length(Value) * System.SizeOf(Char), 0);
end;

{$ENDREGION}

{$REGION 'TSecureString'}

constructor SecureString.TSecureString.Create(const Value: string);
begin
  inherited Create;
  FValue := Value;
end;

destructor SecureString.TSecureString.Destroy;
begin
  SecureString.ZeroStringBytes(FValue);
  inherited Destroy;
end;

function SecureString.TSecureString.GetValue: string;
begin
  Result := FValue;
end;

{$ENDREGION}

end.
