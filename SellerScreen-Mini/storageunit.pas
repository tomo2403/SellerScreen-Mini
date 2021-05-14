unit StorageUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, Grids;

type

  { TStorageForm }

  TStorageForm = class(TForm)
    MainMenu: TMainMenu;
    OpenDialog1: TOpenDialog;
    ProductMI: TMenuItem;
    AddProductMI: TMenuItem;
    DemoMI: TMenuItem;
    GenStorageMI: TMenuItem;
    RemoveProdctBtn: TMenuItem;
    ActProductBtn: TMenuItem;
    DeactProductBtn: TMenuItem;
    SG: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure GenStorageMIClick(Sender: TObject);
    procedure SGEditingDone(Sender: TObject);
    procedure SGKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  StorageForm: TStorageForm;
  Check : string;

implementation

{$R *.lfm}

{ TStorageForm }

function GetCurrency(Num: String):string;
var
  i : Integer;
  Str : String = '';
  crry : Currency;
begin
  Result := '';
  for i := 1 to length(Num) do
  begin
    if (Num[i] in ['0'..'9', ',']) then
    begin
      Str := Str + Num[i];
      crry := StrToFloat(Str);
      Result := FloatToStrF(crry, ffCurrency, 10, 2);
      Check := Result;
    end;
  end;
end;

function ExtractCurrencySymbol(crry: String):string;
var
  i : Integer;
  Str : String = '';
begin
  Result := '';
  for i := 1 to length(crry) do
  begin
    if NOT (crry[i] in ['0'..'9','.',',']) then
    Begin
      Str := Str + crry[i];
      Result := ' ' + Trim(Str);
  end;
  end;

end;

procedure TStorageForm.SGEditingDone(Sender: TObject);
begin
  try
    if (SG.Col = 3) then
    begin
      if AnsiPos(Check, SG.Cells[SG.Col, SG.Row]) <> 0 then exit;
      if (Trim(SG.Cells[SG.Col, SG.Row]) = '') then exit
      else
      begin
        SG.Cells[SG.Col, SG.Row] := GetCurrency(SG.Cells[SG.Col, SG.Row]) + ExtractCurrencySymbol(SG.Cells[SG.Col, SG.Row]);
        Exit;
      end;
    end;
  except
    ShowMessage('Eingabe ist nicht korrekt formatiert. Überprüfen Sie sie!');
    SG.Cells[SG.Col, SG.Row] := '0';
  end;

  try
    SG.SaveToFile('storage.xml')
  except
    ShowMessage('Lager konnte nicht gespeichert werden!')
  end;
end;

procedure TStorageForm.SGKeyPress(Sender: TObject; var Key: char);
var
  KeyCode: Integer;
begin
  if (SG.Col = 3 or 4) then
  begin
    KeyCode := Ord(Key);
    if not (KeyCode = 44) or ((KeyCode >= 48) and (KeyCode <= 57)) then Key := #0;
  end;
end;

procedure TStorageForm.FormCreate(Sender: TObject);
begin
  SG.SaveOptions := [soContent];
   //Load the XML
   SG.LoadFromFile('storage.xml');
   //Refresh the Grid
   SG.Refresh;
end;

procedure TStorageForm.GenStorageMIClick(Sender: TObject);
begin
  SG.SaveToFile('storage.xml')
end;

end.

