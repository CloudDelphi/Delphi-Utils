unit Patterns.Singleton.SpringRepository;

interface

uses
  Patterns.Singleton.Repository,
  Spring.Collections;

type
{$REGION 'TSpringSingletonRepository'}
  /// <summary> Implements ISingletonRepository by using Spring4D IDictionary </summary>
  TSpringSingletonRepository = class(TInterfacedObject, ISingletonRepository)
  strict private
    FDictionary: IDictionary<TClass, TObject>;
  strict protected
{$REGION 'ISingletonRepository'}
    procedure AddSingleton(Instance: TObject);
    procedure RemoveSingleton(Instance: TObject);
    function ContainsSingleton(&Class: TClass): Boolean;
    function GetSingleton(&Class: TClass): TObject;
{$ENDREGION}
    property Dictionary: IDictionary<TClass, TObject>read FDictionary;
  public
    constructor Create;
  end;
{$ENDREGION}

implementation

{$REGION 'TSpringSingletonRepository'}

constructor TSpringSingletonRepository.Create;
begin
  inherited Create;
  FDictionary := TCollections.CreateDictionary<TClass, TObject>([doOwnsValues]);
end;

procedure TSpringSingletonRepository.AddSingleton(Instance: TObject);
begin
  FDictionary.Add(Instance.ClassType, Instance);
end;

function TSpringSingletonRepository.ContainsSingleton(&Class: TClass): Boolean;
begin
  Result := FDictionary.ContainsKey(&Class);
end;

function TSpringSingletonRepository.GetSingleton(&Class: TClass): TObject;
begin
  Result := FDictionary[&Class];
end;

procedure TSpringSingletonRepository.RemoveSingleton(Instance: TObject);
begin
  FDictionary.Remove(Instance.ClassType);
end;

{$ENDREGION}

end.
