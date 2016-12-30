unit Data.DataSetMerger.FireDAC;

interface

uses
  Data.DataSetMerger,
  System.SysUtils,
  System.Classes,
  Data.DB;

type
  EDataSetMerger = class(Exception);

{$REGION 'TFDDataSetMerger'}
  TFDDataSetMerger = class(TInterfacedObject, IDataSetMerger)
  strict private
    /// <summary> Devuelve un TDataSet vacio con la misma estructura (campos) que Source </summary>
    /// <param name="Source"> TDataSet del cual se copia la estructura </param>
    /// <param name="Owner"> Componente que se usa como Owner del TDataSet resultante </param>
    function CopyStructure(Source: TDataSet; Owner: TComponent): TDataSet; inline;
    /// <summary> Copia los registros del DataSet Source en el DataSet Destination </summary>
    procedure MergeInto(Source, Destination: TDataSet); inline;

{$REGION 'IDataSetMerger'}
    function Merge(Left, Right: TDataSet; Owner: TComponent): TDataSet; overload;
    function Merge(DataSets: TArray<TDataSet>; Owner: TComponent): TDataSet; overload;
{$ENDREGION}

    /// <summary> Para uso interno. Usar TFDDataSetMerger.Create que devuelve la interface y no la clase </summary>
    /// <remarks> Permite enviar la interface a un metodo que recibe un parametro const sin memory leaks,
    /// evitando workarounds raros como DoWithFoo(TInterfacedObject.Create as IFoo) y el uso de variables temporales </remarks>
    constructor _Create;
  public
    class function Create: IDataSetMerger; static; inline;
  end;
{$ENDREGION}

implementation

uses
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

{$REGION 'TFDDataSetMerger'}

class function TFDDataSetMerger.Create: IDataSetMerger;
begin
  Result := TFDDataSetMerger._Create;
end;

constructor TFDDataSetMerger._Create;
begin
  inherited Create;
end;

function TFDDataSetMerger.Merge(Left, Right: TDataSet; Owner: TComponent): TDataSet;
begin
  Result := Merge([Left, Right], Owner);
end;

function TFDDataSetMerger.Merge(DataSets: TArray<TDataSet>; Owner: TComponent): TDataSet;

  procedure CheckArray;
  begin
    if Length(DataSets) = 0 then
      raise EDataSetMerger.Create('TFDDataSetMerger.Merge :: DataSets array is empty');
  end;

var
  I: Integer;
begin
  CheckArray;
  Result := CopyStructure(DataSets[Low(DataSets)], Owner);

  for I := Low(DataSets) to High(DataSets) do
    MergeInto(DataSets[I], Result);
end;

function TFDDataSetMerger.CopyStructure(Source: TDataSet; Owner: TComponent): TDataSet;
begin
  Result := TFDMemTable.Create(Owner);
end;

procedure TFDDataSetMerger.MergeInto(Source, Destination: TDataSet);
begin
  Source.Open;
  Source.First;
  while not Source.Eof do
  begin
    Destination.Append;
    Destination.CopyFields(Source);
    Destination.Post;
    Source.Next;
  end;
end;

{$ENDREGION}

end.
