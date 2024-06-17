program uuidv7_demolazarus;

{$mode objfpc}{$H+}

{.$DEFINE USE_MORMOT_RNG}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  SysUtils, DateUtils, uuidv7
  {$IFDEF USE_MORMOT_RNG}
  , mormot.crypt.core
  {$ENDIF}
  ;

var i: integer;
begin
  {$IFNDEF USE_MORMOT_RNG}
  Randomize;
  {$ENDIF}
  try
    for i := 0 to 25 do
      Writeln('Generated UUIDv7: ', GUIDToString( GenerateUUIDv7));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.

