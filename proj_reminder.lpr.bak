program proj_reminder;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, u_reminder, mymsgform
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.Title:='Напоминальщик';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tmy_msgform, my_msgform);
  Application.Run;
end.

