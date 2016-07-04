unit Patterns.Singleton.DefaultRepository;

interface

uses
  Patterns.Singleton.Repository,
  Generics.Collections;

type
{$REGION 'TNativeSingletonRepository'}
  /// <summary> Implements ISingletonRepository by using Delphi RTL TDictionary </summary>
  TNativeSingletonRepository = class(TInterfacedObject, ISingletonRepository)
  strict private
    FDictionary: TDictionary<TClass, TObject>;
  strict protected
{$REGION 'ISingletonRepository'}
    procedure AddSingleton(Instance: TObject);
    procedure RemoveSingleton(Instance: TObject);
    function ContainsSingleton(&Class: TClass): Boolean;
    function GetSingleton(&Class: TClass): TObject;
{$ENDREGION}

    property Dictionary: TDictionary<TClass, TObject> read FDictionary;
  public
    constructor Create;
    destructor Destroy; override;
  end;
{$ENDREGION}

implementation

{$REGION 'TNativeSingletonRepository'}

constructor TNativeSingletonRepository.Create;
begin
  inherited Create;
  FDictionary := TObjectDictionary<TClass, TObject>.Create([doOwnsValues]);
end;

destructor TNativeSingletonRepository.Destroy;
begin
  FDictionary.Free;
  inherited Destroy;
end;

procedure TNativeSingletonRepository.AddSingleton(Instance: TObject);
begin
  FDictionary.Add(Instance.ClassType, Instance);
end;

function TNativeSingletonRepository.ContainsSingleton(&Class: TClass): Boolean;
begin
  Result := FDictionary.ContainsKey(&Class);
end;

function TNativeSingletonRepository.GetSingleton(&Class: TClass): TObject;
begin
  Result := FDictionary[&Class];
end;

procedure TNativeSingletonRepository.RemoveSingleton(Instance: TObject);
begin
  FDictionary.Remove(Instance.ClassType);
end;

{$ENDREGION}

end.
