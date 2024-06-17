unit UUIDv7Test;

interface

uses
  DUnitX.TestFramework, SysUtils, DateUtils;

type
  [TestFixture]
  TUUIDv7Test = class(TObject)
  public
    [Test]
    procedure TestUUIDv7Timestamp;
  end;

implementation

uses
  UUIDv7;

procedure TUUIDv7Test.TestUUIDv7Timestamp;
var
  uuid: TGUID;
  timestamp: Int64;
  extractedTimestamp: Int64;
  dateTimeNow: TDateTime;
begin
  dateTimeNow := Now;
  timestamp := DateTimeToUnix(dateTimeNow) * 1000;

  uuid := GenerateUUIDv7;

  // Extract the timestamp from the UUID
  extractedTimestamp := (Int64(uuid.D1) shl 12) or (Int64(uuid.D2) and $0FFF);
  extractedTimestamp := (extractedTimestamp shl 4) or (Int64(uuid.D3) shr 12);

  // Allow for some variance due to processing time
  Assert.IsTrue(Abs(extractedTimestamp - timestamp) < 1000, 'Timestamp is not correctly placed in the UUID');
end;

initialization
  TDUnitX.RegisterTestFixture(TUUIDv7Test);
  TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Pause;

end.

