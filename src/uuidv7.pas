// Use as a regular unit from Delphi, or run as a console app from FreePascal
unit uuidv7;

{$DEFINE CALLRANDOMIZE}

interface

uses
  SysUtils, DateUtils;

function GenerateUUIDv7: TGUID;
function GenerateUUIDv7ex(const aTimestamp:int64):TGUID;

implementation


function GenerateUUIDv7ex(const aTimestamp:int64): TGUID;
var
  timestamp: Int64;
  randomBytes: array[0..9] of Byte;
  uuid: TGUID;
  i: Integer;
begin
  FillChar(uuid, SizeOf(uuid), 0);

  // Generate 10 random bytes
  for i := 0 to 9 do
    randomBytes[i] := Random($FF);

  // Populate the TGUID fields
  uuid.D1 := (atimestamp shr 16) and $FFFFFFFF;      // Top 32 bits of the 48-bit timestamp
  uuid.D2 := ((atimestamp shr 4) and $FFFF);         // Next 16 bits of the timestamp and version 7
  uuid.D3 := ((atimestamp and $0000000F) shl 12) or  // the last 4 bits of timestamp
              (randomBytes[0] and $F0) or $7000;     // the top 4 bits of randomBytes[0]
  uuid.D4[0] := (randomBytes[0] and $0F) or $80;     // Set the variant to 10xx
  Move(randomBytes[1], uuid.D4[1], 7);               // Remaining 7 bytes

  Result := uuid;
end;

function GenerateUUIDv7:TGUID;
var
  timestamp: Int64;
begin
  {$IFDEF FPC}
  timestamp := DateTimeToUnix(Now) * 1000; // seconds accuracy
  {$ELSE}
  timestamp := DateTimeToMilliseconds(Now) - Int64(UnixDateDelta + DateDelta) * MSecsPerDay; // millisecond accuracy
  {$ENDIF}
  Result := GenerateUUIDv7ex(Timestamp);
end;

// Optionally remove this to make a regular unit for FPC too
{$IFDEF FPC}
var i: Integer;
begin
  {$IFDEF CALLRANDOMIZE}
  Randomize;
  {$ENDIF}
  for i := 0 to 30 do
    writeln(GUIDToString(GenerateUUIDv7).ToLower);
  readln;
{$ELSE}
initialization
  {$IFDEF CALLRANDOMIZE}
  Randomize;
  {$ENDIF}
{$ENDIF}
end.
