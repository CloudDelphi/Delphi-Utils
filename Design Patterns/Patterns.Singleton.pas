unit Patterns.Singleton;

interface

uses
  Patterns.Singleton.Repository;

type
  TFactoryMethod<T: class, constructor> = reference to function: T;

  TSingleton<T: class, constructor> = class abstract
  strict private
    /// <summary> Returns the TClass from the actual T type </summary>
    class function GetMetaClass: TClass;
    /// <summary> Method called when the Singleton needs to be created </summary>
    class function CreateInstance: T;
    /// <summary> Executes the Factory Method </summary>
    class function Factory: T;
  strict protected
    /// <summary> Returns wether to use the default, parameterless constructor or the FactoryMethod </summary>
    class function UseDefaultConstructor: Boolean; virtual;
    /// <summary> Returns a Factory Method that creates the object </summary>
    class function GetFactory: TFactoryMethod<T>; virtual; abstract;
  public
    /// <summary> Returns the Singleton instance; will create if necessary </summary>
    class function Instance: T;
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

class function TSingleton<T>.Factory: T;
begin
  // why double () are needed? otherwise i get a compiler error:
  // E2010 Incompatible types: 'T' and 'Patterns.Singleton.TFactoryMethod<Patterns.Singleton.TSingleton<T>.T>'
  Result := GetFactory()();
end;

class function TSingleton<T>.CreateInstance: T;
begin
  if UseDefaultConstructor then
    Result := T.Create
  else
    Result := Factory;
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

class function TSingleton<T>.UseDefaultConstructor: Boolean;
begin
  Result := True;
end;

end.
