// Use as a regular unit from Delphi, or run as a console app from FreePascal
unit uuidv7;

interface

uses
  SysUtils, DateUtils;

function GenerateUUIDv7: TGUID;
function GenerateUUIDv7ex(const aTimestamp:Int64; const aBytes:TBytes=[]):TGUID;

implementation


function GenerateUUIDv7ex(const aTimestamp:Int64; const aBytes:TBytes): TGUID;
var
  timestamp: Int64;
  randomBytes: array[0..9] of Byte;
  uuid: TGUID;
  i: Integer;
begin
  FillChar(uuid, SizeOf(uuid), 0);
  
  if Length(aBytes) <> 10 then
  begin
    // Generate 10 random bytes
    for i := 0 to 9 do
      randomBytes[i] := Random($100);
  end
  else
    move(aBytes[0],RandomBytes[0],10);

  // Populate the TGUID fields
  uuid.D1 := (atimestamp shr 16) and $FFFFFFFF;      // Top 32 bits of the 48-bit timestamp
  uuid.D2 := (atimestamp and $FFFF);                 // Next 16 bits of the timestamp
  uuid.D3 := (RandomBytes[8] SHL 4) or ((randomBytes[9] and $F0) shr 4) or $7000; // random bytes and version 7
  uuid.D4[0] := (randomBytes[0] and $3F) or $80;     // Set the variant to 10xx
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

  // Generate 10 random bytes
  for i := 0 to 9 do
    randomBytes[i] := Random($100);

  // Populate the TGUID fields
  uuid.D1 := (atimestamp shr 16) and $FFFFFFFF;      // Top 32 bits of the 48-bit timestamp
  uuid.D2 := (atimestamp and $FFFF);                 // Next 16 bits of the timestamp
  uuid.D3 := (RandomBytes[8] SHL 4) or ((randomBytes[9] and $F0) shr 4) or $7000; // random bytes and version 7
  uuid.D4[0] := (randomBytes[0] and $3F) or $80;     // Set the variant to 10xx
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
  Result := GenerateUUIDv7ex(Timestamp,[]);
end;

// Optionally remove this to make a regular unit for FPC too
{$IFDEF FPC}
var i: Integer;
begin
  Randomize;
  for i := 0 to 30 do
    writeln(GUIDToString(GenerateUUIDv7).ToLower);
  readln;
{$ELSE}
initialization
  Randomize;
{$ENDIF}
end.
