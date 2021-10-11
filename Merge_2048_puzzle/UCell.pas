unit UCell;

interface

uses
  Math;

type
  TIncScoreEvent = procedure(const aScore: Integer) of object;

  TCell = class
  private
    FPower: Integer;
    FRow: Integer;
    FCol: Integer;
    FLeftCell: TCell;
    FRightCell: TCell;
    FUpCell: TCell;
    FDownCell: TCell;
    FOnIncScore: TIncScoreEvent;
    procedure Clear;      
    procedure IncPower;
    function HasSamePower(const aCell: TCell): Boolean;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveUp;
    procedure MoveDown;
    procedure RecursiveMoveLeft;
    procedure RecursiveMoveRight;
    procedure RecursiveMoveUp;
    procedure RecursiveMoveDown;
    procedure MergeLeft;
    procedure MergeRight;
    procedure MergeUp;
    procedure MergeDown;
    procedure RecursiveMergeLeft;
    procedure RecursiveMergeRight;
    procedure RecursiveMergeUp;
    procedure RecursiveMergeDown;
    function GetCanMerge: Boolean;
    procedure DoOnIncScore(const aScore: Integer);
    function GetCellValue: Integer;
    function GetCellPower: Integer;
    procedure SetCellPower(const aPower: Integer);
    function GetRow: Integer;
    procedure SetRow(const aIndex: Integer);
    function GetCol: Integer;
    procedure SetCol(const aIndex: Integer);
    function GetLeftCell: TCell;
    procedure SetLeftCell(const aCell: TCell);
    function GetRightCell: TCell;
    procedure SetRightCell(const aCell: TCell);
    function GetUpCell: TCell;
    procedure SetUpCell(const aCell: TCell);
    function GetDownCell: TCell;
    procedure SetDownCell(const aCell: TCell);
    function GetOnIncScore: TIncScoreEvent;
    procedure SetOnIncScore(const aEvent: TIncScoreEvent);
  protected
  public
    constructor Create(const aRow: Integer; const aCol: Integer);
    destructor Destroy; override;
    procedure Fill;
    function IsEmpty: Boolean;
    function HasLeftCell: Boolean;
    function HasRightCell: Boolean;
    function HasUpCell: Boolean;
    function HasDownCell: Boolean;
    function IsLeftCell: Boolean;
    function IsRightCell: Boolean;
    function IsUpCell: Boolean;
    function IsDownCell: Boolean;
    function IsMax: Boolean;
    procedure AlignLeft;
    procedure AlignRight;
    procedure AlignUp;
    procedure AlignDown;
    property CellValue: Integer read GetCellValue;
    property CellPower: Integer read GetCellPower write SetCellPower;
    property Row: Integer read GetRow write SetRow;
    property Col: Integer read GetCol write SetCol;
    property CanMerge: Boolean read GetCanMerge;
    property LeftCell: TCell read GetLeftCell write SetLeftCell;
    property RightCell: TCell read GetRightCell write SetRightCell;
    property UpCell: TCell read GetUpCell write SetUpCell;
    property DownCell: TCell read GetDownCell write SetDownCell;
    property OnIncScore: TIncScoreEvent read GetOnIncScore write SetOnIncScore;
  published
  end;

implementation

const
  BASE: Integer = 2;
  DEFAULT_POWER: Integer = 0;
  INITIAL_POWER: Integer = 1;
  MAX_POWER: Integer = 11;

constructor TCell.Create(const aRow: Integer; const aCol: Integer);
begin
  FPower := DEFAULT_POWER;
  FRow := aRow;
  FCol := aCol;
  FLeftCell := nil;
  FRightCell := nil;
  FUpCell := nil;
  FDownCell := nil;
  FOnIncScore := nil;
end;

destructor TCell.Destroy;
begin
  inherited;
end;

procedure TCell.Fill;
begin
  FPower := INITIAL_POWER;
end;

function TCell.IsEmpty: Boolean;
begin
  Result := (FPower = DEFAULT_POWER);
end;

function TCell.HasLeftCell: Boolean;
begin
  Result := Assigned(FLeftCell);
end;

function TCell.HasRightCell: Boolean;
begin
  Result := Assigned(FRightCell);
end;

function TCell.HasUpCell: Boolean;
begin
  Result := Assigned(FUpCell);
end;

function TCell.HasDownCell: Boolean;
begin
  Result := Assigned(FDownCell);
end;

function TCell.IsLeftCell: Boolean;
begin
  Result := not Assigned(FLeftCell);
end;

function TCell.IsRightCell: Boolean;
begin
  Result := not Assigned(FRightCell);
end;

function TCell.IsUpCell: Boolean;
begin
  Result := not Assigned(FUpCell);
end;

function TCell.IsDownCell: Boolean;
begin
  Result := not Assigned(FDownCell);
end;

function TCell.IsMax: Boolean;
begin
  Result := FPower >= MAX_POWER;
end;

procedure TCell.AlignLeft;
begin
  RecursiveMoveLeft;
  RecursiveMergeLeft;
  RecursiveMoveLeft;
end;

procedure TCell.AlignRight;
begin
  RecursiveMoveRight;
  RecursiveMergeRight;
  RecursiveMoveRight;
end;

procedure TCell.AlignUp;
begin
  RecursiveMoveUp;
  RecursiveMergeUp;
  RecursiveMoveUp;
end;

procedure TCell.AlignDown;
begin
  RecursiveMoveDown;
  RecursiveMergeDown;
  RecursiveMoveDown;
end;

procedure TCell.Clear;
begin
  FPower := DEFAULT_POWER;
end;

procedure TCell.IncPower;
begin
  Inc(FPower);
end;

function TCell.HasSamePower(const aCell: TCell): Boolean;
begin
  Result := False;
  if Assigned(aCell) then
    Result := (FPower = aCell.CellPower);
end;

procedure TCell.MoveLeft;
begin
  if HasLeftCell then
  begin
    if (not IsEmpty) and (FLeftCell.IsEmpty) then
    begin
      FLeftCell.CellPower := FPower;
      Clear;
      FLeftCell.MoveLeft;
    end;
  end;
end;

procedure TCell.MoveRight;
begin       
  if HasRightCell then
  begin
    if (not IsEmpty) and (FRightCell.IsEmpty) then
    begin
      FRightCell.CellPower := FPower;
      Clear;
      FRightCell.MoveRight;
    end;
  end;
end;

procedure TCell.MoveUp;
begin        
  if HasUpCell then
  begin
    if (not IsEmpty) and (FUpCell.IsEmpty) then
    begin
      FUpCell.CellPower := FPower;
      Clear;
      FUpCell.MoveUp;
    end;
  end;
end;

procedure TCell.MoveDown;
begin    
  if HasDownCell then
  begin
    if (not IsEmpty) and (FDownCell.IsEmpty) then
    begin
      FDownCell.CellPower := FPower;
      Clear;
      FDownCell.MoveDown;
    end;
  end;
end;    

procedure TCell.RecursiveMoveLeft;
begin
  MoveLeft;
  if HasRightCell then
    FRightCell.RecursiveMoveLeft;
end;

procedure TCell.RecursiveMoveRight;
begin
  MoveRight;
  if HasLeftCell then
    FLeftCell.RecursiveMoveRight;
end;

procedure TCell.RecursiveMoveUp;
begin
  MoveUp;
  if HasDownCell then
    FDownCell.RecursiveMoveUp;
end;

procedure TCell.RecursiveMoveDown;
begin
  MoveDown;
  if HasUpCell then
    FUpCell.RecursiveMoveDown;
end;

procedure TCell.MergeLeft;
begin
  if HasRightCell then
  begin
    if (not FRightCell.IsEmpty) and HasSamePower(FRightCell) then
    begin
      IncPower;
      FRightCell.Clear;
      DoOnIncScore(CellValue);
    end;
  end;
end;

procedure TCell.MergeRight;
begin
  if HasLeftCell then
  begin
    if (not FLeftCell.IsEmpty) and HasSamePower(FLeftCell) then
    begin
      IncPower;
      FLeftCell.Clear;
      DoOnIncScore(CellValue);
    end;
  end;
end;

procedure TCell.MergeUp;
begin
  if HasDownCell then
  begin
    if (not FDownCell.IsEmpty) and HasSamePower(FDownCell) then
    begin
      IncPower;
      FDownCell.Clear;
      DoOnIncScore(CellValue);
    end;
  end;
end;

procedure TCell.MergeDown;
begin
  if HasUpCell then
  begin
    if (not FUpCell.IsEmpty) and HasSamePower(FUpCell) then
    begin
      Inc(FPower);
      FUpCell.Clear;
      DoOnIncScore(CellValue);
    end;
  end;
end;

procedure TCell.RecursiveMergeLeft;
begin
  MergeLeft;
  if HasRightCell then
    FRightCell.RecursiveMergeLeft;
end;

procedure TCell.RecursiveMergeRight;
begin
  MergeRight;
  if HasLeftCell then
    FLeftCell.RecursiveMergeRight;
end;

procedure TCell.RecursiveMergeUp;
begin
  MergeUp;
  if HasDownCell then
    FDownCell.RecursiveMergeUp;
end;

procedure TCell.RecursiveMergeDown;
begin
  MergeDown;
  if HasUpCell then
    FUpCell.RecursiveMergeDown;
end;

function TCell.GetCanMerge: Boolean;
begin
  Result := IsEmpty;
  if (not Result) and HasLeftCell then
    Result := HasSamePower(FLeftCell);
  if (not Result) and HasRightCell then
    Result := HasSamePower(FRightCell);
  if (not Result) and HasUpCell then
    Result := HasSamePower(FUpCell);
  if (not Result) and HasDownCell then
    Result := HasSamePower(FDownCell);
end;

procedure TCell.DoOnIncScore(const aScore: Integer);
begin
  if Assigned(FOnIncScore) then
    FOnIncScore(aScore);
end;

function TCell.GetCellValue: Integer;
begin
  Result := Round(Power(BASE, FPower));
end;

function TCell.GetCellPower: Integer;
begin
  Result := FPower;
end;

procedure TCell.SetCellPower(const aPower: Integer);
begin
  FPower := aPower;
end;

function TCell.GetRow: Integer;
begin
  Result := FRow;
end;

procedure TCell.SetRow(const aIndex: Integer);
begin
  FRow := aIndex;
end;

function TCell.GetCol: Integer;
begin
  Result := FCol;
end;

procedure TCell.SetCol(const aIndex: Integer);
begin
  FCol := aIndex;
end;

function TCell.GetLeftCell: TCell;
begin
  Result := FLeftCell;
end;

procedure TCell.SetLeftCell(const aCell: TCell);
begin
  FLeftCell := aCell;
end;

function TCell.GetRightCell: TCell;
begin
  Result := FRightCell;
end;

procedure TCell.SetRightCell(const aCell: TCell);
begin
  FRightCell := aCell;
end;

function TCell.GetUpCell: TCell;
begin
  Result := FUpCell;
end;

procedure TCell.SetUpCell(const aCell: TCell);
begin
  FUpCell := aCell;
end;

function TCell.GetDownCell: TCell;
begin
  Result := FDownCell;
end;

procedure TCell.SetDownCell(const aCell: TCell);
begin
  FDownCell := aCell;
end;

function TCell.GetOnIncScore: TIncScoreEvent;
begin
  Result := FOnIncScore;
end;

procedure TCell.SetOnIncScore(const aEvent: TIncScoreEvent);
begin
  FOnIncScore := aEvent;
end;

end.
