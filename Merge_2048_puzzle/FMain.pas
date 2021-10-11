unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, UResources, UCustomRegistry, UGrid;

type
  TFrmMain = class(TForm)
    SgrGrid: TStringGrid;
    procedure FormCreate(aSender: TObject);
    procedure FormDestroy(aSender: TObject);
    procedure FormClose(aSender: TObject; var aAction: TCloseAction);
    procedure FormResize(aSender: TObject);
    procedure FormKeyDown(aSender: TObject; var aKey: Word; aShift: TShiftState);
    procedure FormMouseMove(aSender: TObject; aShift: TShiftState; aX: Integer; aY: Integer);
    procedure SgrGridDrawCell(aSender: TObject; aCol: Integer; aRow: Integer; aRect: TRect; aState: TGridDrawState);
  private                
    FRegistry: TCustomRegistry;
    FGrid: TGrid;
    FHasAlreadyWon: Boolean;
    FMouseCoord: TPoint;
    procedure UpdateGrid;
    procedure UpdateScore;
    procedure UpdateHighScore;
    procedure Reset;
    procedure AskExit;
    procedure AskAbout;
    procedure AskRestart;
    procedure AskHighScore;
    procedure AskSwap(const aDirection: TDirection);
  public
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

const
  DELAY: Integer = 100; // milliseconds
  DEFAULT_COORD: Integer = 0; // default position for the mouse pointer
  DEFAULT_PLAYER: String = ''; // default player name for the high score input

procedure TFrmMain.FormCreate(aSender: TObject);
var
  rSelection: TGridRect;
begin
  FRegistry := TCustomRegistry.Create;
  with rSelection do
  begin
    Left := -1;
    Right := -1;
    Top := -1;
    Bottom := -1;
  end;
  SgrGrid.Selection := rSelection;
  SgrGrid.DoubleBuffered := True;
  Reset;
end;

procedure TFrmMain.FormDestroy(aSender: TObject);
begin
  FRegistry.Free;
  FGrid.Free;
end;

procedure TFrmMain.FormClose(aSender: TObject; var aAction: TCloseAction);
begin
  AskExit;
end;

procedure TFrmMain.FormResize(aSender: TObject);
begin
  with SgrGrid do
  begin
    DefaultRowHeight := (ClientHeight - (RowCount - 1) * GridLineWidth) div RowCount;
    DefaultColWidth := (ClientWidth - (ColCount - 1) * GridLineWidth) div ColCount;
  end;
end;

procedure TFrmMain.FormKeyDown(aSender: TObject; var aKey: Word; aShift: TShiftState);
begin
  case aKey of
    VK_ESCAPE: AskExit;
    VK_F1: AskAbout;
    VK_F2: AskRestart;
    VK_F3: AskHighScore;
    VK_LEFT: AskSwap(dLeft);
    VK_RIGHT: AskSwap(dRight);
    VK_UP: AskSwap(dUp);
    VK_DOWN: AskSwap(dDown);
  end;
end;

procedure TFrmMain.FormMouseMove(aSender: TObject; aShift: TShiftState; aX: Integer; aY: Integer);
var
  iDeltaX: Integer;
  iDeltaY: Integer;
begin
  if (GetKeyState(VK_LBUTTON) < 0) then
  begin
    if (FMouseCoord.X = DEFAULT_COORD) and (FMouseCoord.Y = DEFAULT_COORD) then
    begin
      FMouseCoord.X := aX;
      FMouseCoord.Y := aY;
    end
    else
    begin
      iDeltaX := aX - FMouseCoord.X;
      iDeltaY := aY - FMouseCoord.Y;
      if Abs(iDeltaX) > Abs(iDeltaY) then
      begin
        // horizontal swap
        if (iDeltaX > 0) then
          AskSwap(dRight)
        else if (iDeltaX < 0) then
          AskSwap(dLeft);
      end
      else
      begin
        // vertical swap
        if (iDeltaY > 0) then
          AskSwap(dDown)
        else if (iDeltaY < 0) then
          AskSwap(dUp);
      end;
    end;
  end;
end;

procedure TFrmMain.SgrGridDrawCell(aSender: TObject; aCol: Integer; aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  sCell: String;
  iColor: TColor;
begin
  sCell := SgrGrid.Cells[aCol, aRow];
  SgrGrid.Canvas.FillRect(aRect);
  SetTextAlign(SgrGrid.Canvas.Handle, TA_CENTER);
  if FGrid.Cell[aRow + 1, aCol + 1].IsEmpty then
    iColor := COLOR_DEFAULT
  else
    iColor := COLORS[FGrid.Cell[aRow + 1, aCol + 1].CellPower mod (High(COLORS) + 1)];
  SgrGrid.Canvas.Brush.Color := iColor;
  SgrGrid.Canvas.Font.Color := GetContrastColor(iColor);
  SgrGrid.Canvas.Font.Style := [fsBold];
  SgrGrid.Canvas.TextRect(aRect, aRect.Left + (aRect.Right - aRect.Left) div 2, aRect.Top + (aRect.Bottom - aRect.Top) div 2, sCell);
end;

procedure TFrmMain.UpdateGrid;
var
  iRow: Integer;
  iCol: Integer;
begin
  if (SgrGrid.RowCount * SgrGrid.ColCount) > 0 then
  begin
    for iRow := 0 to SgrGrid.RowCount - 1 do
    begin
      for iCol := 0 to SgrGrid.ColCount - 1 do
      begin
        if FGrid.Cell[iRow + 1, iCol + 1].IsEmpty then
          SgrGrid.Cells[iCol, iRow] := ''
        else
          SgrGrid.Cells[iCol, iRow] := IntToStr(FGrid.Cell[iRow + 1, iCol + 1].CellValue);
      end;
    end;
  end;
end;

procedure TFrmMain.UpdateScore;
begin
  if (FGrid.Score = 0) then
    Caption := Application.Title
  else
    Caption := Format(CAPTION_SCORE, [Application.Title, FGrid.Score]);
end;

procedure TFrmMain.UpdateHighScore;
var
  sPlayer: String;
begin
  if (FGrid.Score > FRegistry.ReadHighScore.Score) then
  begin
    sPlayer := InputBox(Application.Title, MESSAGE_NEW_HIGHSCORE, DEFAULT_PLAYER);
    if sPlayer <> DEFAULT_PLAYER then
      FRegistry.WriteHighScore(sPlayer, FGrid.Score);
  end;
end;

procedure TFrmMain.Reset;
begin                       
  FHasAlreadyWon := False;
  FMouseCoord.X := DEFAULT_COORD;
  FMouseCoord.Y := DEFAULT_COORD;
  if Assigned(FGrid) then
  begin
    UpdateHighScore;
    FGrid.Free;
  end;
  FGrid := TGrid.Create(SgrGrid.RowCount, SgrGrid.ColCount);
  FGrid.FillRandomEmptyCell;
  FGrid.FillRandomEmptyCell;
  UpdateScore;
  UpdateGrid;
end;

procedure TFrmMain.AskExit;
begin
  if (FGrid.Score = 0) or (MessageDlg(MESSAGE_EXIT, mtConfirmation, [mbOK, mbCancel], 0) = mrOK) then
  begin
    UpdateHighScore;
    Application.Terminate;
  end;
end;

procedure TFrmMain.AskAbout;
begin
  ShowMessage(Format(MESSAGE_HELP, [GetExeVersion(Application.ExeName)]));
end;

procedure TFrmMain.AskRestart;
begin
  if (FGrid.Score = 0) or (MessageDlg(MESSAGE_RESTART, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    Reset;
end;

procedure TFrmMain.AskHighScore;
var
  oMessage: TForm;
  rHighScore: THighScore;
begin
  if not FRegistry.HasHighScore then
  begin
    ShowMessage(MESSAGE_NO_HIGHSCORE);
  end
  else
  begin
    rHighScore := FRegistry.ReadHighScore;
    oMessage := CreateMessageDialog(Format(MESSAGE_HIGHSCORE, [rHighScore.Score, rHighScore.Player]), mtCustom, [mbOK, mbIgnore]);
    try
      TButton(oMessage.FindComponent('Ignore')).Caption := CAPTION_DELETE_HIGHSCORE;
      if oMessage.ShowModal = mrIgnore then
        if MessageDlg(MESSAGE_DELETE_HIGHSCORE, mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
          FRegistry.DeleteHighScore;
    finally
      oMessage.Free;
    end;
  end;
end;

procedure TFrmMain.AskSwap(const aDirection: TDirection);
begin
  if FGrid.Swap(aDirection) then
  begin
    UpdateScore;
    UpdateGrid;
    Refresh;
    Sleep(DELAY);
    FGrid.FillRandomEmptyCell;
    UpdateGrid;
    if FGrid.HasLost then
      if MessageDlg(Format(MESSAGE_LOSE, [FGrid.Score]), mtCustom, [mbOK], 0) = mrOK then
        Reset;
    if not FHasAlreadyWon then
      if FGrid.HasWon then
      begin
        FHasAlreadyWon := True;
        if MessageDlg(Format(MESSAGE_WIN, [FGrid.Score]), mtCustom, [mbOK, mbCancel], 0) = mrOK then
          Reset;
      end;
  end;
  FMouseCoord.X := DEFAULT_COORD;
  FMouseCoord.Y := DEFAULT_COORD;
end;

end.

