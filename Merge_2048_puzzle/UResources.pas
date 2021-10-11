unit UResources;

interface

uses
  SysUtils, Windows, Graphics, GraphUtil;

const
// default html colors in 2048
// #CDC0B4 // empty
// #EEE4DA // 2
// #EDE0C8 // 4
// #F2B179 // 8
// #F59563 // 16
// #F67C5F // 32
// #F65E3B // 64
// #EDCF72 // 128
// #EDCC61 // 256
// #EDC850 // 512
// #EDC53F // 1024
// #EDC22E // 2048

  COLOR_DEFAULT: TColor = 11845837; // power 0: default power
  COLORS: array[0..9] of TColor =
  (
  //3064557   // power 11
    4179437,  // power 10
    14345454, // power 1
    13164781, // power 2
    7975410,  // power 3
    6526453,  // power 4
    6257910,  // power 5
    3890934,  // power 6
    7524333,  // power 7
    6409453,  // power 8
    5294317   // power 9
  );

resourcestring
  CAPTION_DEFAULT_VERSION = 'no version info';
  CAPTION_VERSION_FORMAT = '%d.%d.%d.%d';
  CAPTION_SCORE = '%s - %d';
  CAPTION_DELETE_HIGHSCORE = 'Delete';
  MESSAGE_EXIT = 'Exit?';
  MESSAGE_HELP = 'Merge (puzzle game)'#13+
                 'Version: %s'#13+
                 'Date: 2014-03'#13+
                 'Author: zwyx'#13+
                 'Contact: zwyx@hotmail.fr'#13+
                 'Inspired from 2048: http://gabrielecirulli.github.io/2048/'#13+
                 #13+
                 'Aim: join the numbers and get to the 2048 tile.'#13+
                 #13+
                 'How to play: use your arrow keys to move the tiles, when two tiles with the same number touch, they merge into one.'#13+
                 #13+
                 'Keys:'#13+
                 #9'ECHAP: exit,'#13+
                 #9'F1: about,'#13+
                 #9'F2: restart,'#13+
                 #9'F3: high score,'#13+
                 #9'LEFT: swap left,'#13+
                 #9'RIGHT: swap right,'#13+
                 #9'UP: swap up,'#13+
                 #9'DOWN: swap down.';  
  MESSAGE_RESTART = 'Restart?';
  MESSAGE_NEW_HIGHSCORE = 'You have beaten the previous high score, please enter your name:';
  MESSAGE_NO_HIGHSCORE = 'No high score recorded yet.';
  MESSAGE_HIGHSCORE = 'High score: %d points, by %s.';
  MESSAGE_DELETE_HIGHSCORE = 'Delete the high score?';
  MESSAGE_WIN = 'You won with %d points. Click "OK" to restart or "Cancel" to continue.';
  MESSAGE_LOSE = 'You lost with %d points. Click "OK" to try again.';

function GetContrastColor(aColor: TColor): TColor;
function GetExeVersion(const aExeName: String): String;
function GetUser: String;

implementation

function GetContrastColor(aColor: TColor): TColor;
var
  wH: Word;
  wL: Word;
  wS: Word;
  iColor: Cardinal;
begin
  iColor := ColorToRGB(aColor);
  // convert the color in hue, luminance, saturation
  ColorRGBToHLS(iColor, wH, wL, wS);
  if (wL < 120) or ((wL = 120) and (wH > 120)) then
    Result := clWhite
  else
    Result := clBlack;
end;

function GetExeVersion(const aExeName: String): String;
var
  pInfo: PVSFixedFileInfo;
  iInfoSize: Cardinal;
  iNull: Cardinal;
  iBufferSize: DWORD;
  pBuffer: Pointer;
  iMajor: Word;
  iMinor: Word;
  iRelease: Word;
  iBuild: Word;
begin
  Result := CAPTION_DEFAULT_VERSION;
  iBufferSize := GetFileVersionInfoSize(PChar(aExeName), iNull);
  if iBufferSize > 0 then
  begin
    GetMem(pBuffer, iBufferSize);
    try
      if GetFileVersionInfo(PChar(aExeName), iNull, iBufferSize, pBuffer) then
      begin
        if VerQueryValue(pBuffer, '\', Pointer(pInfo), iInfoSize) then
        begin
          iMajor := HiWord(pInfo^.dwFileVersionMS); // extract major version
          iMinor := LoWord(pInfo^.dwFileVersionMS); // extract minor version
          iRelease := HiWord(pInfo^.dwFileVersionLS); // extract release version
          iBuild := LoWord(pInfo^.dwFileVersionLS); // extract build version}
          Result := Format(CAPTION_VERSION_FORMAT, [iMajor, iMinor, iRelease, iBuild]);
        end;
      end;
    finally
      FreeMem(pBuffer, iBufferSize);
    end;
  end;
end;

function GetUser: String;
var
  aUser: array[0..255] of Char;
  iSize: Cardinal;
begin
  iSize := SizeOf(aUser);
  if GetUserName(@aUser, iSize) then
    Result := StrPas(aUser)
  else
    Result := '';
end;

end.

