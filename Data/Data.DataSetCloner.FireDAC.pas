unit Data.DataSetCloner.FireDAC;

interface

uses
  Data.DataSetCloner,
  System.Classes,
  Data.DB;

type
{$REGION 'TFDMemTableDataSetCloner'}
  TFDMemTableDataSetCloner = class(TInterfacedObject, IDataSetCloner)
  strict private
    function Copy(const Source: TDataSet; const Owner: TComponent): TDataSet;
    function CopyRecords(
      const Records: TArray<TBookmark>;
      const Source: TDataSet;
      const Owner: TComponent): TDataSet;
  end;
{$ENDREGION}

implementation

uses
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

{$REGION 'TFDMemTableDataSetCloner'}

function TFDMemTableDataSetCloner.Copy(const Source: TDataSet; const Owner: TComponent): TDataSet;
var
  Copy: TFDMemTable;
begin
  Copy := TFDMemTable.Create(Owner);
  try
    Copy.CopyDataSet(Source, [coStructure, coAppend, coRestart]);
  finally
    Result := Copy;
  end;
end;

function TFDMemTableDataSetCloner.CopyRecords(
  const Records: TArray<TBookmark>;
  const Source: TDataSet;
  const Owner: TComponent): TDataSet;
var
  Copy: TFDMemTable;
  I: Integer;
begin
  Copy := TFDMemTable.Create(Owner);
  try
    Copy.CopyDataSet(Source, [coStructure, coRestart]);
    Source.DisableControls;
    try
      for I := Low(Records) to High(Records) do
      begin
        Source.GotoBookmark(Records[I]);
        Copy.Append;
        Copy.CopyFields(Source);
        Copy.Post;
      end;
    finally
      Source.EnableControls;
    end;
  finally
    Result := Copy;
  end;
end;

{$ENDREGION}

end.
