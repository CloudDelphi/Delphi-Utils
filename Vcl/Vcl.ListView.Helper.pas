unit Vcl.ListView.Helper;

interface

uses
  Vcl.ComCtrls;

type
{$REGION 'TListViewHelper'}
  TListViewHelper = class helper for TListView
  public
    /// <summary>
    ///   Marca (tilda los checkbox) de todos los items del ListView
    ///  No tiene efecto si TListView.Checkboxes = False
    /// </summary>
    procedure CheckAll;
    /// <summary>
    ///   Desmarca los checkbox de todos los items del ListView
    ///  No tiene efecto si TListView.Checkboxes = False
    /// </summary>
    procedure UncheckAll;
    /// <summary>
    ///   Devuelve la cantidad de items que evaluan TListItem.Checked = True
    ///  No tiene efecto si TListView.Checkboxes = False
    /// </summary>
    function CheckedCount: Integer;
    /// <summary> Necesario invocar para poder usar la propiedad TListColumnHelper.Visible </summary>
    procedure InitializeColumnsVisibility;
    /// <summary> Ajusta el tamaño de las columnas del ListView de modo tal que StrechColum ocupe lo mas posible </summary>
    procedure StretchColumIndex(const StectchColumn: Integer);
  end;
{$ENDREGION}

{$REGION 'TListColumnHelper'}
  TListColumnHelper = class helper for TListColumn
  strict private
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
  public
    property Visible: Boolean read GetVisible write SetVisible;
  end;
{$ENDREGION}

implementation

{$REGION 'TListViewHelper'}

procedure TListViewHelper.CheckAll;
var
  ListItem: TListItem;
begin
  if not Checkboxes then
    Exit;

  Items.BeginUpdate;
  try
    for ListItem in Items do
      ListItem.Checked := True;
  finally
    Items.EndUpdate;
  end;
end;

procedure TListViewHelper.UncheckAll;
var
  ListItem: TListItem;
begin
  if not Checkboxes then
    Exit;

  Items.BeginUpdate;
  try
    for ListItem in Items do
      ListItem.Checked := False;
  finally
    Items.EndUpdate;
  end;
end;

function TListViewHelper.CheckedCount: Integer;
var
  ListItem: TListItem;
begin
  Result := 0;
  for ListItem in Items do
  begin
    if ListItem.Checked then
      Inc(Result);
  end;
end;

procedure TListViewHelper.StretchColumIndex(const StectchColumn: Integer);
var
  AWidth, I: Integer;
begin
  if not Assigned(Parent) then
    Exit;

  AWidth := 0;
  for I := 0 to Columns.Count - 1 do
  begin
    if I <> StectchColumn then
      AWidth := AWidth + Column[I].Width;
  end;

  Column[StectchColumn].Width := Abs(Parent.Width - AWidth - Trunc(AWidth * 0.15));
end;

procedure TListViewHelper.InitializeColumnsVisibility;
var
  I: Integer;
begin
  // me guardo el ancho de la columna en el Tag, para despues usarlo en el class helper en el metodo Visible
  for I := 0 to Columns.Count - 1 do
    Column[I].Tag := Column[I].Width;
end;

{$ENDREGION}

{$REGION 'TListColumnHelper'}

function TListColumnHelper.GetVisible: Boolean;
begin
  Result := Self.Width = 0;
end;

procedure TListColumnHelper.SetVisible(const Value: Boolean);
begin
  if not Value then
  begin
    Self.Tag := Self.Width;
    Self.Width := 0;
  end
  else
    Self.Width := Tag;
end;

{$ENDREGION}

end.
