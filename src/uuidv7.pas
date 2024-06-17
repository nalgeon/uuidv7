unit uuidv7;

interface

uses
  SysUtils,
  DateUtils;

function GenerateUUIDv7: TGUID;

implementation

function GenerateUUIDv7: TGUID;
var
  timestamp: Int64;
  randomBytes: TBytes;
  uuid: TGUID;
begin
  timestamp := DateTimeToUnix(Now) * 1000;

  // Generate 10 random bytes
  SetLength(randomBytes, 10);
  Randomize;
  for var i := 0 to 9 do
    randomBytes[i] := Random(256);

  // Populate the TGUID fields
  uuid.D1 := (timestamp shr 16) and $FFFFFFFF; // Top 32 bits of the 48-bit timestamp
  uuid.D2 := ((timestamp shr 4) and $0FFF) or $7000; // Next 12 bits of the timestamp and version 7
  uuid.D3 := ((timestamp and $0000000F) shl 12) or ((randomBytes[0] shr 4) and $0FFF); // Last 4 bits of timestamp and first 4 bits of randomBytes[0]
  uuid.D4[0] := (randomBytes[0] and $0F) or $80; // Set the variant to 10xx
  Move(randomBytes[1], uuid.D4[1], 7);

  Result := uuid;
end;


end.
