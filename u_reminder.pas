//procedure TForm1.FormCreate(Sender: TObject);
//begin
//  playsound.SoundFile:=st;   // сюда, через какую-то системную переменную, нужно передать путь, от куда была запущена программа будильник
//end;
// команда записи текста в файл echo 'Здесь наше сообщение' |text2wave -eval '(voice_msu_ru_nsh_clunits)' > wavfile.wav
// команда записи из текстового файла в wav файл cat 'empty.txt' |text2wave -eval '(voice_msu_ru_nsh_clunits)' > empty.wav

unit u_reminder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uplaysound, Process, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, mylib;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit4: TEdit;
    Image1: TImage;
    Image2: TImage;
    ecntLbl: TLabel;
    SetAlarmBtn: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    LCurTime: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    playsound: Tplaysound;
    SetBtn: TButton;
    ClrBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    Timer2: TTimer;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    procedure ClrBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;



var
  Form1     : TForm1;
  h, m, s   : integer;
  f         : text;
  st, t2, s1, s2, dzin, empty, path, water: string;
  t, t1, hs, ms, sumT, resT, h1, h2: TTime;


implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Label1.Caption:='Текущая дата:        ' + datetostr(date);
  Label2.Caption:='Текущее время:     ' + timetostr(time);
  LCurTime.Caption:='Текущее время:     ' + timetostr(time);
end;

procedure TForm1.SetBtnClick(Sender: TObject);

begin
  st:=Edit4.Text;
  t:=time;
  h:=strtoint(edit1.Text);  //устанавливаем кол-во часов
  m:=strtoint(edit2.Text); //устанавливаем кол-во минут
  s:=strtoint(edit3.Text); //устанавливаем кол-во секунд
  hs:=h * 3600; //получаем кол-во секунд в установленных часах
  ms:=m * 60; // получаем кол-во секунд в установленных минутах
  sumT:=hs + ms + s;   //сумарное кол-во секунд
  resT:=t + (sumT/86400);  // (час равен 3600 секунд (24*3600 в сутках или 86400))
  Label6.Caption:='Сработает в: ' + FormatDateTime('hh:mm:ss',(resT)); //показываем установленное время
  t1:=strtotime(FormatDateTime('hh:mm:ss',(resT)));
  t2:=(FormatDateTime('hh:mm',(resT))); //преобразовываем время для команды at путем удаления секунд
  Label7.Caption:='Осталось: ' + timetostr(t1-t); //показываем сколько осталось
  ClrBtn.Enabled:=true;  //делаем кнопку "Сброс" активной
  Timer2.Enabled:=true;  //включаем наш второй таймер

  //пишем напоминание в файл
    if length(st) > 0 then
    begin
      assignfile (f, 'alarm.txt');
      Rewrite (f);
      writeln(f, st);
      closefile (f);
    end;
  //Очищаем поля эдитов
  Edit1.Text:='0';
  Edit2.Text:='0';
  Edit3.Text:='0';
  Edit4.Text:='';
end;

procedure TForm1.ClrBtnClick(Sender: TObject);
begin
  Timer2.Enabled:=false;    // выключаем таймер №2
  Label6.Caption:='Сработает в: '; // чистим лейблы
  Label7.Caption:='Осталось: ';
  ecntlbl.caption:='0';
  Edit1.Text:='0';
  Edit2.Text:='0';
  Edit3.Text:='0';
  DeleteFile('alarm.txt');
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  path:=ExtractFilePath(ParamStr(0)); // получаем путь, от куда была запущена программа
  dzin:= path+'wav'+PathDelim+'1.wav';
  empty:=path+'wav'+PathDelim+'empty.wav';
  water:=path+'wav'+PathDelim+'water.wav';
  playsound.SoundFile:=dzin;
end;


procedure TForm1.FormShow(Sender: TObject);
begin
  Edit4.TextHint:='О чем напомнить?';
end;


procedure TForm1.Timer2Timer(Sender: TObject);
begin
  h1:=time;
  h2:=resT-h1;
  Label7.Caption:='Осталось: ' + timetostr(h2);
  if (h2<0) then
   begin
     Timer2.Enabled:=False;
     Label6.Caption:='Таймер сработал в: ' + FormatDateTime('hh:mm:ss',(resT));
     playsound.execute;
     sleep (500);
     if FileExists('alarm.txt') then
      begin
       s1:='festival --tts '+path+'alarm.txt'; //записываем команду /root/./alarm.sh в строковую переменную
       fun_StrToCommandLine(s1);    //передаем строку в процедуру
      end else
      begin
        s2:='aplay '+empty;
        fun_StrToCommandLine(s2);
      end;
     if st = '1' then
      begin
        s2:='aplay '+water;
        fun_StrToCommandLine(s2);
      end;
     ecntlbl.caption:=inttostr(strtoint(ecntLbl.caption)+1); //подсчет количества сработанных напоминаний
     if length(st) > 0 then
      begin
      if st<>'1' then
     ShowMessage(st)
      end else
     ShowMessage('Вы что-то должны были сделать!');
     DeleteFile('alarm.txt');
     if st ='1' then
      begin
       ShowMessage('Выпей водички!');
       Edit2.Text:='25';
      end;
   end;
end;

end.
