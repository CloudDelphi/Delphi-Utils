unit Data.DataSetMerger;

interface

uses
  System.Classes,
  Data.DB;

type
{$REGION 'IDataSetMerger'}
  /// <summary> Interface que realiza merges entre TDataSets </summary>
  IDataSetMerger = interface
    ['{62A075DA-44EF-4275-B45D-0E2222DB83BA}']
    /// <summary> Devuelve un TDataSet cuyos datos son merge entre los DataSets "Left" y "Right" </summary>
    /// <param name="Left, Right"> DataSets que intervienen en el Merge </param>
    /// <param name="Owner"> Componente que se usa como Owner del TDataSet resultante </param>
    /// <remarks> La estructura de los TDataSet debe ser compatible (nombre y tipo de datos de los campos) </remarks>
    function Merge(Left, Right: TDataSet; Owner: TComponent): TDataSet; overload;
    /// <summary> Devuelve un TDataSet cuyos datos son merge entre los DataSets que estan en el arreglo </summary>
    /// <param name="DataSets"> DataSets que intervienen en el Merge </param>
    /// <param name="Owner"> Componente que se usa como Owner del TDataSet resultante </param>
    /// <remarks> La estructura de los TDataSet debe ser compatible (nombre y tipo de datos de los campos) </remarks>
    function Merge(DataSets: TArray<TDataSet>; Owner: TComponent): TDataSet; overload;
  end;
{$ENDREGION}

implementation

end.
