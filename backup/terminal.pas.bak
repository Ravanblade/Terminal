unit terminal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ListView1: TListView;
    ListView2: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure wczytajLoty(sciezka : AnsiString; lista : TListView);
    function ostatniZaznaczonyOdlot() : TListItem;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  ostatni : TListItem; //Zmienna w ktorej przechowywany jest ostatni obiekt
                       //zaznaczony w ListView2

implementation
uses bilety;
{$R *.lfm}

{ TForm1 }

procedure TForm1.wczytajLoty(sciezka : AnsiString; lista : TListView);
var
  t: TStringList;
  ln: TStringList;
  i, k: integer;
  lot : TListItem;
begin
  ln := TStringList.Create;
  t := TStringList.Create;
  ln.LoadFromFile(sciezka);

  for i := 0 to ln.count-1 do
  begin
    t.Clear;
    t.Delimiter := ';';
    t.StrictDelimiter := True;
    t.DelimitedText := ln[i];

    //Tworzenie wpisu do listy
    lot := TListItem.Create(lista.Items);
    lot.Caption := t[0];//Nazwa w pierwszej kolumnie

    for k := 1 to 4 do
    begin
      lot.SubItems.Add(t[k]); //Dodanie nazw do kolejnych kolumn
    end;

    lista.Items.AddItem(lot); //Dodanie obiektu do wybranego w argumencie TListView
   end;

   ln.Free;
   t.Free;

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  if Assigned(ListView2.Selected) then
  begin
     ostatni := ListView2.Selected;
     Form2.Show;
  end
  else
    ShowMessage('Aby zakupic bilet musisz wybrac lot z listy odlotow!');
end;

function TForm1.ostatniZaznaczonyOdlot() : TListItem;
begin
  result := ostatni;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  wczytajLoty('przyloty.txt', ListView1);
  wczytajLoty('odloty.txt', ListView2);
end;

end.

