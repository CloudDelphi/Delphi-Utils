unit Data.SpreadsheetDataSet.ADO;

interface

uses
  Data.SpreadsheetDataSet,
  Data.DataSetCloner,
  Spring.Collections,
  System.Classes,
  Data.DB,
  Data.Win.ADODB;

type
{$REGION 'TADOSpreadsheetDataSet'}
  TADOSpreadsheetDataSet = class(TInterfacedObject, ISpreadsheetDataSet)
  strict private
    FConnection: TADOConnection;
    FFileName: string;
    FOnFileOpen: TNotifyEvent;
    function CreateQuery(Owner: TComponent): TADOQuery;
    procedure OpenFile(const FileName: string);
  strict protected
    procedure DoFileOpened; virtual;
    /// <summary> ConnectionString usado por el componente TADOConnection para abrir el archivo </summary>
    function GetConnectionString(const FileName: string): string; virtual;
    /// <summary> Provider usado por el componente TADOConnection </summary>
    function GetConnectionProvider: string; virtual;

{$REGION 'ISpreadsheetDataSet'}
    function GetOnFileOpen: TNotifyEvent;
    function GetSheets: Spring.Collections.IEnumerable<string>;
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    procedure SetOnFileOpen(const Value: TNotifyEvent);
    function SheetData(const SheetName: string; const Cloner: IDataSetCloner): TDataSet;
{$ENDREGION}
  public
    constructor Create; overload;
    constructor Create(const FileName: string); overload;
    destructor Destroy; override;
  end;
{$ENDREGION}

implementation

uses
  System.SysUtils;

{$REGION 'TADOSpreadsheetDataSet'}

constructor TADOSpreadsheetDataSet.Create;
begin
  inherited Create;
  FFileName := EmptyStr;
  FConnection := TADOConnection.Create(nil);
  FConnection.Provider := GetConnectionProvider;
  FConnection.LoginPrompt := False;
end;

constructor TADOSpreadsheetDataSet.Create(const FileName: string);
begin
  Create;
  SetFileName(FileName);
end;

destructor TADOSpreadsheetDataSet.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;

function TADOSpreadsheetDataSet.SheetData(const SheetName: string; const Cloner: IDataSetCloner): TDataSet;
var
  qry: TADOQuery;
begin
  if not Assigned(Cloner) then
    raise Exception.CreateFmt('%s.SheetData :: Cloner is not assigned', [ClassName]);

  if SheetName.IsEmpty then
    raise Exception.CreateFmt('%s.SheetData :: SheetName is Empty', [ClassName]);

  qry := CreateQuery(nil);
  try
    qry.SQL.Text := Format(' SELECT * FROM [%s] ', [SheetName]);
    qry.Open;
    Result := Cloner.Copy(qry, nil);
  finally
    qry.Free;
  end;
end;

procedure TADOSpreadsheetDataSet.OpenFile(const FileName: string);
begin
  if not FileName.IsEmpty then
  begin
    FFileName := FileName;
    FConnection.Close;
    FConnection.ConnectionString := GetConnectionString(FFileName);
    FConnection.Open;
    DoFileOpened;
  end;
end;

function TADOSpreadsheetDataSet.GetSheets: Spring.Collections.IEnumerable<string>;
var
  Sheets: IList<string>;
  Tables: TStrings;
  Each: string;
begin
  Sheets := TCollections.CreateList<string>;

  if not FConnection.Connected then
    Exit(Sheets);

  Tables := TStringList.Create;
  try
    FConnection.GetTableNames(Tables);
    for Each in Tables do
      Sheets.Add(Each);
  finally
    Tables.Free;
  end;

  Result := Sheets;
end;

function TADOSpreadsheetDataSet.CreateQuery(Owner: TComponent): TADOQuery;
begin
  Result := TADOQuery.Create(Owner);
  Result.Connection := FConnection;
end;

function TADOSpreadsheetDataSet.GetConnectionProvider: string;
begin
  Result := 'Microsoft.Jet.OLEDB.4.0';
end;

function TADOSpreadsheetDataSet.GetConnectionString(const FileName: string): string;
begin
  Result := 'Provider=Microsoft.JET.OLEDB.4.0;Data Source=' + FileName +';Extended Properties="Excel 8.0;HDR=No";';
end;

function TADOSpreadsheetDataSet.GetFileName: string;
begin
  Result := FFileName;
end;

function TADOSpreadsheetDataSet.GetOnFileOpen: TNotifyEvent;
begin
  Result := FOnFileOpen;
end;

procedure TADOSpreadsheetDataSet.DoFileOpened;
begin
  if Assigned(FOnFileOpen) then
    FOnFileOpen(Self);
end;

procedure TADOSpreadsheetDataSet.SetFileName(const Value: string);
begin
  OpenFile(Value);
end;

procedure TADOSpreadsheetDataSet.SetOnFileOpen(const Value: TNotifyEvent);
begin
  FOnFileOpen := Value;
end;

{$ENDREGION}

end.
