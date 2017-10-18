unit Data.DataSetCloner;

interface

uses
  System.Classes,
  Data.DB;

type
{$REGION 'IDataSetCloner'}
  /// <summary> Interface que realiza copias de TDataSets </summary>
  IDataSetCloner = interface
    ['{D61E44DC-3DDF-4CEF-B390-8F470B6017FB}']
    /// <summary> Devuelve una copia del DataSet </summary>
    /// <param name="Source"> DataSet a clonar </param>
    /// <param name="Owner"> Componente que se usa como Owner del TDataSet resultante </param>
    function Copy(const Source: TDataSet; const Owner: TComponent): TDataSet;
    /// <summary> Devuelve una copia del DataSet, que incluye unicamente los registros indicados </summary>
    /// <param name="Records"> Array con los registros que se deben copiar </param>
    /// <param name="Source"> DataSet a clonar </param>
    /// <param name="Owner"> Componente que se usa como Owner del TDataSet resultante </param>
    function CopyRecords(
      const Records: TArray<TBookmark>;
      const Source: TDataSet;
      const Owner: TComponent): TDataSet;
  end;
{$ENDREGION}

implementation

end.
