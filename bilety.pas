unit bilety;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, CheckLst;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wczytajRejsy(nr_linii : integer);
    procedure zapiszMiejsce();
  private
    { private declarations }
  public
    { public declarations }
    miasto, nr_rejsu, czas_l, cena_b, data, uwagi, term : AnsiString;
  end;

var
  Form2: TForm2;

implementation
uses terminal, potwierdzenie;

{$R *.lfm}

{ TForm2 }

procedure TForm2.wczytajRejsy(nr_linii : integer);
var
  t: TStringList;
  ln: TStringList;
  k : integer;
  nr : AnsiString;
begin
  ln := TStringList.Create;
  t := TStringList.Create;
  ln.LoadFromFile('odloty.txt');
  t.Clear;
  t.Delimiter := ';';
  t.StrictDelimiter := True;
  t.DelimitedText := ln[nr_linii];
  //Zapisanie wszystkich danych lotu na potrzeby potwierdzenia rezerwacji
  miasto := t[0];
  nr_rejsu := t[1];
  czas_l := t[6];
  cena_b := t[5];
  data := t[2];
  term := t[3];
  uwagi := t[4];
  //
  Form2.Caption := 'Kup bilet - ' + t[0] + ' ' + t[2];
  Edit1.Caption := t[0] + ' ' + t[2];
  Label4.Caption := 'Numer rejsu: ' + t[1];
  Label5.Caption := 'Czas lotu  : ' + t[6];
  Label6.Caption := 'Cena jednostkowa biletu: ' + t[5];

  //W pliku kazde siedzenie jest zapisane zero-jedynkowo
  for k := 7 to t.Count - 1 do
  begin
   if t[k] = '0' then
   begin
      if (k > 6) and (k <= 10) then //Jezeli jest to miejsce od 0 do 4 (czyli indeks w pliku 6 do 10)
          nr := 'A';                //to jest to miejsce w rzedzie A
      if (k > 10) and (k <= 14) then//To samo tylko od 5 do 9 i rzad B
          nr := 'B';
      if (k > 14) and (k <= 18) then
          nr := 'C';
      if (k > 18) and (k <= 22) then
          nr := 'D';
      if (k > 22) and (k <= 26) then
          nr := 'E';
      if (k > 26) and (k <= 30) then
          nr := 'F';

      CheckListBox1.Items.Add(nr + IntToStr((k-7) mod 4+1));  //k-7 mod 4 +1
    end;                                                 //jako ze miejsca zaczynaja sie od indeksu 7
   end;                                                  //to odejmujemy od licznika petli 7 aby uzyskac
                                                         //numery od 0
                                                         //mod 4 +1 - po to aby miejsca byly numerowane od 1 do 4
                                                         //czyli nie A1 A2 .. B5 .. C10 tylko A1 .. A4 B1 .. B4 i tak dalej
  ln.Free;
  t.Free;
end;

procedure TForm2.zapiszMiejsce();
var
  ln, t: TStringList;
  str1, str2, str3 : AnsiString;
  i,j ,modyfikator: integer;
begin
  str1 := '';
  str2 := '';
  str3 := '';
  ln := TStringList.Create;
  t := TStringList.Create;

  ln.LoadFromFile('odloty.txt');
  t.Clear;
  t.Delimiter := ';';
  t.StrictDelimiter := True;

  for j := 0 to CheckListBox1.Count -1 do
  begin

    if Form2.CheckListBox1.Checked[j] = true then
    begin

    str3 := '';
    t.DelimitedText := ln[Form1.ostatniZaznaczonyOdlot().Index];

    //Jako ze wczesniej miejsca zostaly zapisane w formacie A1..A4
    //to trzeba wyciangac z tego rzad oraz numer
    str1 := Copy(CheckListBox1.Items[j],1,1);//Kopiujemy z aktualnego wybranego miejsca
                                             //w CheckListBox1 pierwszy znak, czyli numer rzedu

    //modyfikator to liczba taka aby mozna bylo wyliczyc indeks w pliku danego miejsca w samolocie
    //na podstawie oznaczenia rzedu A..F
    case str1 of
         'A': modyfikator := 0;
         'B': modyfikator := 1*4;
         'C': modyfikator := 2*4;
         'D': modyfikator := 3*4;
         'E': modyfikator := 4*4;
         'F': modyfikator := 5*4;
    end;

    str2 := Copy(CheckListBox1.Items[j],2,Length(CheckListBox1.Items[j])-1);

    t[6+StrToInt(str2)+modyfikator] := '1';

    for i := 0 to t.Count - 1 do
    begin
         if t.Count-1 = i then
         begin
            str3 += t[i];
         end
         else
            str3 += t[i] + ';';
    end;

    ln[Form1.ostatniZaznaczonyOdlot().Index] := str3;

    end;


  end;

  ln.SaveToFile('odloty.txt');

  ln.Free;
  t.Free;

end;


procedure TForm2.Button1Click(Sender: TObject);
begin

    if CheckListBox1.SelCount < 1 then
    begin
       ShowMessage('Prosze wybrac miejsca!');
       Abort;
    end;

    if CheckListBox1.Count > 0 then
    begin
         Form3.Show;
         Form2.Hide;
    end
    else
        ShowMessage('Brak wolnych miejsc do zakupienia!');
end;

procedure TForm2.FormShow(Sender: TObject);
begin
     CheckListBox1.Items.Clear;
     wczytajRejsy(Form1.ostatniZaznaczonyOdlot().Index);
end;


end.

