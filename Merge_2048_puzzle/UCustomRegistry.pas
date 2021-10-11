unit UCustomRegistry;

interface

uses
  Registry, Windows;

type
  THighScore = record
    Player: String;
    Score: Integer;
  end;

  TCustomRegistry = class(TRegistry)
  private
  protected
  public
    function HasHighScore: Boolean;
    function ReadHighScore: THighScore;
    function ReadPlayer: String;
    function ReadScore: Integer;
    procedure WriteHighScore(const aHighScore: THighScore); overload;
    procedure WriteHighScore(const aPlayer: String; const aScore: Integer); overload;
    procedure DeleteHighScore;
  published
  end;

implementation

const
  KEY_NAME: String = 'SOFTWARE\Merge';
  KEY_PLAYER: String = 'Player';
  KEY_SCORE: String = 'Score';
  DEFAULT_HIGHSCORE: THighScore = (Player: ''; Score: 0);

function TCustomRegistry.HasHighScore: Boolean;
begin
  Result := ReadScore <> DEFAULT_HIGHSCORE.Score;
end;

function TCustomRegistry.ReadHighScore: THighScore;
begin
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey(KEY_NAME, False);
    Result.Player := ReadString(KEY_PLAYER);
    Result.Score := ReadInteger(KEY_SCORE);
    CloseKey;
  except
    on E: ERegistryException do
      Result := DEFAULT_HIGHSCORE;
  end;
end;

function TCustomRegistry.ReadPlayer: String;
begin
  Result := ReadHighScore.Player;
end;

function TCustomRegistry.ReadScore: Integer;
begin
  Result := ReadHighScore.Score;
end;

procedure TCustomRegistry.WriteHighScore(const aHighScore: THighScore);
begin
  WriteHighScore(aHighScore.Player, aHighScore.Score);
end;

procedure TCustomRegistry.WriteHighScore(const aPlayer: String; const aScore: Integer);
begin
  if (aScore <> DEFAULT_HIGHSCORE.Score) then
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey(KEY_NAME, True);
    WriteString(KEY_PLAYER, aPlayer);
    WriteInteger(KEY_SCORE, aScore);
    CloseKey;
  end;
end;

procedure TCustomRegistry.DeleteHighScore;    
begin
  RootKey := HKEY_LOCAL_MACHINE;
  DeleteKey(KEY_NAME);
  CloseKey;
end;

end.
