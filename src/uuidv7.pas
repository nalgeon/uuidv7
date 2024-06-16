program UUIDv7;

uses
  SysUtils, DateUtils;

type
  TByteArray = array[0..15] of Byte;
  TInt64Bytes = record
    case Integer of
      0: (IntValue: Int64);
      1: (Bytes: TByteArray);
  end;

function UUIDv7: Int64;
var
  Value: TInt64Bytes;
  Timestamp: Int64;
  i: integer;
begin
  // random bytes
  for i:=Low(Value.Bytes) to High(Value.Bytes) do Value.Bytes[i]:= Random(256);

  // current timestamp in ms
  Timestamp := DateTimeToUnix(Now) * 1000;

  // timestamp
  Value.Bytes[0] := (Timestamp shr 40) and $FF;
  Value.Bytes[1] := (Timestamp shr 32) and $FF;
  Value.Bytes[2] := (Timestamp shr 24) and $FF;
  Value.Bytes[3] := (Timestamp shr 16) and $FF;
  Value.Bytes[4] := (Timestamp shr 8) and $FF;
  Value.Bytes[5] := Timestamp and $FF;

  // version and variant
  Value.Bytes[6] := (Value.Bytes[6] and $0F) or $70;
  Value.Bytes[8] := (Value.Bytes[8] and $3F) or $80;

  Result := Value.IntValue;
end;

function UUIDv7ToStr(UUID: Int64):string;
var
  Value: TInt64Bytes;
  i: integer;
begin
  Value.IntValue:=uuid;
  Result:='';
  for i:=Low(value.Bytes) to High(value.Bytes) do begin
    Result:= Result + lowercase( format('%.2x',[value.bytes[i] ]) );
    if i in [3, 5, 7, 9] then Result:= Result+ '-';
  end;
end;

begin
  Writeln(UUIDv7ToStr(UUIDv7));
  Readln;
end.
