unit MyMsgForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tmy_msgform }

  Tmy_msgform = class(TForm)
    Image1: TImage;
    background: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  my_msgform: Tmy_msgform;

procedure showAlertForm (const ss:string; imgidx:integer; timeout:integer);


implementation

{$R *.lfm}

{ Tmy_msgform }

{Процедура принимает текст уведомления, индекс картинки из ImageList и время на показ уведомления (в милисекундах)}
procedure ShowAlertForm (const ss:string; imgidx:integer; timeout:integer);
begin
  with my_msgform do
    begin
     ImageList1.GetBitmap(imgidx,Image1.Picture.Bitmap);
     Label1.Caption:=ss;
     Timer1.Interval:=timeout*1000;
     ShowModal;
    end;
end;

procedure Tmy_msgform.FormShow(Sender: TObject);
begin
  timer1.Enabled:=true;
end;

procedure Tmy_msgform.Timer1StopTimer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  my_msgform.Close;
end;

end.

