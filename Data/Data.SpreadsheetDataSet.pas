unit Data.SpreadsheetDataSet;

interface

uses
  Data.DataSetCloner,
  Spring.Collections,
  System.Classes,
  Data.DB;

type
{$REGION 'ISpreadsheetDataSet'}
  /// <summary> Permite usar una hoja de calculo como un TDataSet </summary>
  ISpreadsheetDataSet = interface
    ['{0CAB1799-A7A1-41E1-8BC9-DFA8D256CE39}']
    function GetOnFileOpen: TNotifyEvent;
    function GetSheets: Spring.Collections.IEnumerable<string>;
    function GetFileName: string;

    procedure SetFileName(const Value: string);
    procedure SetOnFileOpen(const Value: TNotifyEvent);

    /// <summary> Devuelve el TDataSet que representa la hoja indicada </summary>
    /// <param name="SheetName"> El nombre la hoja de la cual se desea obtener el TDataSet </param>
    /// <param name="Cloner"> Interface que realiza copias de TDataSet </param>
    function SheetData(const SheetName: string; const Cloner: IDataSetCloner): TDataSet;

    /// <summary> Ruta completa al archivo que representa la hoja de calculo </summary>
    property FileName: string read GetFileName write SetFileName;
    /// <summary> Coleccion de hojas de las distintas hojas de calculo </summary>
    property Sheets: Spring.Collections.IEnumerable<string> read GetSheets;
    /// <summary> Evento que se dispara cuando se abre el archivo </summary>
    property OnFileOpen: TNotifyEvent read GetOnFileOpen write SetOnFileOpen;
  end;
{$ENDREGION}

implementation

end.
