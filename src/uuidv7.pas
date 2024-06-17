unit uuidv7;

interface

{$DEFINE USE_MORMOT_RNG}

uses
  SysUtils,
  DateUtils {$IFDEF USE_MORMOT_RNG},
  mormot.crypt.core {$ENDIF};

function GenerateUUIDv7: TGUID;

implementation

function GenerateUUIDv7: TGUID;
var
  timestamp: Int64;
  randomBytes: TBytes;
  uuid: TGUID;
  {$IFDEF USE_MORMOT_RNG}
  rng: TAESPRNG;
  {$ELSE}
  i: integer;
  {$ENDIF}
begin
  timestamp := DateTimeToUnix(Now) * 1000;

  // Generate 10 cryptographically secure random bytes
  SetLength(randomBytes, 10);
  {$IFDEF USE_MORMOT_RNG}
  rng := TAESPRNG.Create;
  try
    rng.FillRandom(randomBytes, Length(randomBytes));
  finally
    rng.Free;
  end;
  {$ELSE}
  for i := 0 to 9 do
    randomBytes[i] := Random(256);
  {$ENDIF}

  // Populate the TUUID fields
  uuid.D1 := (timestamp shr 28) and $FFFFFFFF;
  uuid.D2 := (timestamp shr 12) and $FFFF;
  uuid.D3 := ((timestamp and $0FFF) shl 4) or $7; // Set the version to 7

  uuid.D4[0] := (randomBytes[0] and $3F) or $80; // Set the variant to 10xx
  Move(randomBytes[1], uuid.D4[1], 7);

  Result := uuid;
end;


end.
