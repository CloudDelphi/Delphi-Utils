unit Patterns.Singleton;

interface

uses
  Generics.Collections;

type
  TSingleton<T: class, constructor> = class abstract
  strict private
    /// <summary> A Dictionary storing all the created Singletons </summary>
    class var FInstances: TObjectDictionary<TClass, T>;

    class function GetMetaClass: TClass;

    class constructor Create;
    class destructor Destroy;
  public
    ///<summary> Returns the Singleton instance; will create if necessary </summary>
    class function Instance: T;
  end;

implementation

uses
  Rtti,
  Generics.Defaults;

class constructor TSingleton<T>.Create;
begin
  FInstances := TObjectDictionary<TClass, T>.Create([doOwnsValues]);
end;

class destructor TSingleton<T>.Destroy;
begin
  FInstances.Free;
end;

class function TSingleton<T>.GetMetaClass: TClass;
var
  Ctx: TRttiContext;
begin
  Result := (Ctx.GetType(TypeInfo(T)) as TRttiInstanceType).MetaclassType;
end;

class function TSingleton<T>.Instance: T;
var
  MetaClass: TClass;
begin
  MetaClass := GetMetaClass;
  if not FInstances.TryGetValue(MetaClass, Result) then  
  begin
    Result := T.Create;
    FInstances.Add(MetaClass, Result);
  end;
end;

end.
