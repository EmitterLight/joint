unit MyLib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process;

procedure fun_StrToCommandLine (var cmd: string); // Процедура для передачи команды Командной строке Linux в качестве строки


implementation

{Процедура для передачи команды Командной строке Linux в качестве строки}
procedure fun_StrToCommandLine(var cmd: string);
var
  AProcess: TProcess;
begin
  AProcess := TProcess.Create(nil);
  try
  AProcess.CommandLine := cmd;
  AProcess.Options := AProcess.Options;
  AProcess.Execute;
  finally
  AProcess.Free;
  end;
end;


end.

