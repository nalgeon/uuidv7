program UUIDv7ConsoleApp;

uses
  SysUtils,
  DateUtils,
  uuidv7 in '..\src\uuidv7.pas';

begin
  Randomize;
  try
  for var i := 0 to 30 do

    Writeln('Generated UUIDv7: ', GUIDToString( GenerateUUIDv7).ToLower);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.

