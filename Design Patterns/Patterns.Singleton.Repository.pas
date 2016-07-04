unit Patterns.Singleton.Repository;

interface

uses
  SysUtils;

type
{$REGION 'ISingletonRepository'}
  /// <summary> A collection holding each singleton instance for a given T type </summary>
  ISingletonRepository = interface
    ['{7E0AC866-2E44-494F-AD5D-3B2531A35D10}']
    /// <summary> Adds a singleton to the repository </summary>
    procedure AddSingleton(Instance: TObject);
    /// <summary> Removes and destroys the singleton from the repository </summary>
    procedure RemoveSingleton(Instance: TObject);
    /// <summary> Returns True if a singleton of the class exists in the repository; False otherwise </summary>
    function ContainsSingleton(&Class: TClass): Boolean;
    /// <summary> Returns the singleton of the class from the repository </summary>
    function GetSingleton(&Class: TClass): TObject;
  end;
{$ENDREGION}

{$REGION 'TSingletonRepository'}
  /// <summary> A record that holds the repository that will store all the singletons instances </summary>
  TSingletonRepository = record
  public
    /// <summary> Use this method to provide a custom implementation for the singleton repository </summary>
    class procedure Initialize(const Repository: ISingletonRepository); static;
  end;
{$ENDREGION}

  ERepositoryCreated = Exception;

function SingletonRepository: ISingletonRepository;

implementation

uses
  Patterns.Singleton.DefaultRepository;

var
  __Respository: ISingletonRepository;

{$REGION 'TSingletonRepository'}

class procedure TSingletonRepository.Initialize(const Repository: ISingletonRepository);
begin
  if not Assigned(Repository) then
    raise EInvalidPointer.Create('The singleton repository is not assigned');

  if Assigned(__Respository) then
    raise ERepositoryCreated.Create('A singleton repository already exists!');

  __Respository := Repository;
end;

{$ENDREGION}

function SingletonRepository: ISingletonRepository;
begin
  if not Assigned(__Respository) then
    __Respository := TNativeSingletonRepository.Create;

  Result := __Respository;
end;

end.
