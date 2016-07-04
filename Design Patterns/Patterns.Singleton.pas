unit Patterns.Singleton;

interface

uses
  Patterns.Singleton.Repository;

type
  TSingleton<T: class, constructor> = class abstract
  strict private
    /// <summary> Returns the TClass from the actual T type </summary>
    class function GetMetaClass: TClass; static;
  strict protected
    /// <summary> Method called when the Singleton needs to be created </summary>
    class function CreateInstance: T; virtual;
  public
    /// <summary> Returns the Singleton instance; will create if necessary </summary>
    class function Instance: T; static;
  end;

implementation

uses
  Rtti;

class function TSingleton<T>.GetMetaClass: TClass;
var
  Ctx: TRttiContext;
begin
  Result := (Ctx.GetType(TypeInfo(T)) as TRttiInstanceType).MetaclassType;
end;

class function TSingleton<T>.CreateInstance: T;
begin
  Result := T.Create;
end;

class function TSingleton<T>.Instance: T;
var
  MetaClass: TClass;
begin
  MetaClass := GetMetaClass;

  if not SingletonRepository.ContainsSingleton(MetaClass) then
  begin
    Result := CreateInstance;
    SingletonRepository.AddSingleton(Result);
  end
  else
    Result := T(SingletonRepository.GetSingleton(MetaClass));
end;

end.
