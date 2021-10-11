unit UGrid;

interface

uses
  Classes, Contnrs, SysUtils, Math, UCell;

type
  TDirection = (dLeft, dRight, dUp, dDown);

  TGrid = class
  private
    FCells: TObjectList;
    FRowCount: Integer;
    FColCount: Integer;
    FScore: Integer;
    function ToString: String;  
    procedure AlignLeft;
    procedure AlignRight;
    procedure AlignUp;
    procedure AlignDown;
    procedure IncScore(const aScore: Integer);
    function GetEmptyCellsCount: Integer;
    function GetIndexRandomEmptyCell: Integer;
    function GetCell(aRow: Integer; aCol: Integer): TCell;
    function GetRowCount: Integer;
    function GetColCount: Integer; 
    function GetCellsCount: Integer;
    function GetScore: Integer;
  protected
  public
    constructor Create(const aRowCount: Integer; const aColCount: Integer);
    destructor Destroy; override;
    function Swap(const aDirection: TDirection): Boolean;
    procedure FillRandomEmptyCell;
    function HasWon: Boolean;
    function HasLost: Boolean;
    property Cell[aRow: Integer; aCol: Integer]: TCell read GetCell; default;
    property RowCount: Integer read GetRowCount;
    property ColCount: Integer read GetColCount; 
    property CellsCount: Integer read GetCellsCount;
    property Score: Integer read GetScore;
  published
  end;

implementation

const
  DEFAULT_INDEX: Integer = -1;

constructor TGrid.Create(const aRowCount: Integer; const aColCount: Integer);
var
  iRow: Integer;
  iCol: Integer;
begin
  FScore := 0;
  FRowCount := aRowCount;
  FColCount := aColCount;
  if CellsCount > 0 then
  begin
    // create the list of cells
    FCells := TObjectList.Create(True);
    for iRow := 1 to FRowCount do
    begin
      for iCol := 1 to FColCount do
      begin
        (FCells.Items[FCells.Add(TCell.Create(iRow, iCol))] as TCell).OnIncScore := IncScore;
      end;
    end;
    // connect the related cells
    for iRow := 1 to FRowCount do
    begin
      for iCol := 1 to FColCount do
      begin
        if (FRowCount > 1) then
        begin
          if iRow > 1 then
            Cell[iRow, iCol].UpCell := Cell[iRow - 1, iCol];
          if iRow < FRowCount then
            Cell[iRow, iCol].DownCell := Cell[iRow + 1, iCol];
        end;
        if (FColCount > 1) then
        begin
          if iCol > 1 then
            Cell[iRow, iCol].LeftCell := Cell[iRow, iCol - 1];
          if iCol < FColCount then
            Cell[iRow, iCol].RightCell := Cell[iRow, iCol + 1];
        end;
      end;
    end;
  end;
end;

destructor TGrid.Destroy;
begin
  FCells.Free;
  inherited;
end;

function TGrid.Swap(const aDirection: TDirection): Boolean;
var
  sInitialGrid: String;
begin
  Result := False;
  if CellsCount > 0 then
  begin
    sInitialGrid := ToString;
    case aDirection of
      dLeft: AlignLeft;
      dRight: AlignRight;
      dUp: AlignUp;
      dDown: AlignDown;
    end;
    // return true if grid has changed after swaping
    Result := not SameText(sInitialGrid, ToString);
  end;
end;

procedure TGrid.FillRandomEmptyCell;
var
  iIndex: Integer;
begin
  iIndex := GetIndexRandomEmptyCell;
  if iIndex <> DEFAULT_INDEX then
    (FCells.Items[iIndex] as TCell).Fill;
end;

function TGrid.HasWon: Boolean;
var
  iCell: Integer;
begin
  Result := False;
  for iCell := 0 to FCells.Count - 1 do
    if (FCells.Items[iCell] as TCell).IsMax then
      Result := True;
end;

function TGrid.HasLost: Boolean;
var
  iCell: Integer;
begin
  Result := (GetEmptyCellsCount = 0);
  iCell := 0;
  while Result and (iCell < FCells.Count) do
  begin
    Result := not (FCells.Items[iCell] as TCell).CanMerge;
    Inc(iCell);
  end;
end;

function TGrid.ToString: String;
var
  iCell: Integer;
  oCell: TCell;
begin
  Result := '';
  for iCell := 0 to FCells.Count - 1 do
  begin
    oCell := FCells.Items[iCell] as TCell;
    if oCell.HasRightCell then
      Result := Result + IntToStr(oCell.CellPower) + #9
    else if oCell.HasDownCell then
      Result := Result + IntToStr(oCell.CellPower) + #13
    else
      Result := Result + IntToStr(oCell.CellPower);
  end;
end;

procedure TGrid.AlignLeft;
var
  iCell: Integer;
begin
  for iCell := 0 to FCells.Count - 1 do
    with (FCells.Items[iCell] as TCell) do
      if IsLeftCell then
        AlignLeft;
end;

procedure TGrid.AlignRight;
var
  iCell: Integer;
begin
  for iCell := 0 to FCells.Count - 1 do
    with (FCells.Items[iCell] as TCell) do
      if IsRightCell then
        AlignRight;
end;

procedure TGrid.AlignUp;
var
  iCell: Integer;
begin
  for iCell := 0 to FCells.Count - 1 do
    with (FCells.Items[iCell] as TCell) do
      if IsUpCell then
        AlignUp;
end;

procedure TGrid.AlignDown;
var
  iCell: Integer;
begin
  for iCell := 0 to FCells.Count - 1 do
    with (FCells.Items[iCell] as TCell) do
      if IsDownCell then
        AlignDown;
end;

procedure TGrid.IncScore(const aScore: Integer);
begin
  Inc(FScore, aScore);
end;

function TGrid.GetEmptyCellsCount: Integer;
var
  iCell: Integer;
begin
  Result := 0;
  for iCell := 0 to FCells.Count - 1 do
    if (FCells.Items[iCell] as TCell).IsEmpty then
      Inc(Result);
end;

function TGrid.GetIndexRandomEmptyCell: Integer;
var
  iCell: Integer;
  iEmptyCell: Integer;
  iEmptyCellsCount: Integer;
  aEmptyCells: array of Integer;
begin
  Result := DEFAULT_INDEX;
  iEmptyCellsCount := GetEmptyCellsCount;
  if iEmptyCellsCount > 0 then
  begin
    SetLength(aEmptyCells, iEmptyCellsCount);
    iEmptyCell := 0;
    for iCell := 0 to FCells.Count - 1 do
    begin
      if (FCells.Items[iCell] as TCell).IsEmpty then
      begin
        aEmptyCells[iEmptyCell] := iCell;
        Inc(iEmptyCell);
      end;
    end;
    Randomize;
    Result := aEmptyCells[Floor(Random(iEmptyCellsCount))];
    Finalize(aEmptyCells);
  end;
end;

function TGrid.GetCell(aRow: Integer; aCol: Integer): TCell;
begin
  if (aRow <= FRowCount) and (aCol <= FColCount) then
    Result := FCells.Items[(aCol - 1) + ((aRow - 1) * FColCount)] as TCell
  else
    Result := nil;
end;

function TGrid.GetRowCount: Integer;
begin
  Result := FRowCount;
end;

function TGrid.GetColCount: Integer;
begin
  Result := FColCount;
end;    

function TGrid.GetCellsCount: Integer;
begin
  Result := FRowCount * FColCount;
end;

function TGrid.GetScore: Integer;
begin
  Result := FScore;
end;

end.
