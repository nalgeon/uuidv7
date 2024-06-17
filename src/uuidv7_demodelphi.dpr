program uuidv7_demodelphi;

uses
  SysUtils,
  uuidv7 in 'uuidv7.pas';

begin
  {$IFNDEF USE_MORMOT_RNG}
  Randomize;
  {$endif}
  try
    for var i := 0 to 25 do
      Writeln('Generated UUIDv7: ', GUIDToString( GenerateUUIDv7));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.

