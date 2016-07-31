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

{$ENDREGION}

end.
