program Merge;

uses
  Forms,
  UResources in 'src\UResources.pas',
  UCustomRegistry in 'src\UCustomRegistry.pas',
  UCell in 'src\UCell.pas',
  UGrid in 'src\UGrid.pas',
  FMain in 'src\FMain.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Merge 2048';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
