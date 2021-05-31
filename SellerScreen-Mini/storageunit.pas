unit StorageUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, Grids,
  MaskEdit, ExtCtrls, Spin, Buttons, LCLType;

type

  { TStorageForm }

  TStorageForm = class(TForm)
    PrEditNameLbl: TBoundLabel;
    PrEditSaveBtn: TBitBtn;
    PrEditCancelBtn: TBitBtn;
    CloseBtn: TBitBtn;
    PrEditStatusBox: TComboBox;
    PrEditPriceBox: TFloatSpinEdit;
    PrEditBox: TGroupBox;
    PrEditStatusLbl: TLabel;
    PrEditPriceLbl: TLabel;
    PrEditAvailableLbl: TLabel;
    PrEditNameBox: TLabeledEdit;
    MainMenu: TMainMenu;
    ProductMI: TMenuItem;
    AddProductMI: TMenuItem;
    DemoMI: TMenuItem;
    GenStorageMI: TMenuItem;
    RemoveProdctBtn: TMenuItem;
    SG: TStringGrid;
    PrEditAvailableBox: TSpinEdit;
    procedure AddProductMIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenStorageMIClick(Sender: TObject);
    procedure SaveStorage();
    procedure PrEditCancelBtnClick(Sender: TObject);
    procedure PrEditSaveBtnClick(Sender: TObject);
    procedure RemoveProdctBtnClick(Sender: TObject);
    procedure SGSelection(Sender: TObject; aCol, aRow: Integer);
    procedure GetSelectedProduct();
  private

  public

  end;

var
  StorageForm: TStorageForm;

implementation

uses
  MainUnit;

{$R *.lfm}

{ TStorageForm }

function GetCurrency(Num: String): string;
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
    end;
  end;
end;

function CurrToFloat(curr: String) : double;
var
  i : Integer;
  Str : String = '';
begin
  Result := 0;
  for i := 1 to length(curr) do
  begin
    if (curr[i] in ['0'..'9', ',']) then
    begin
      Str := Str + curr[i];
      Result := StrToFloat(Str);
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

procedure TStorageForm.GetSelectedProduct();
begin
  try
    PrEditNameBox.Text := SG.Cells[1, SG.Row];
  except
    PrEditNameBox.Text := 'n/a';
  end;
  try
    case SG.Cells[2, SG.Row] of
      'Aktiv': PrEditStatusBox.ItemIndex := 0
      else PrEditStatusBox.ItemIndex := 1;
    end;
  except
    PrEditStatusBox.ItemIndex := 1;
  end;
  try
    PrEditPriceBox.Value := CurrToFloat(SG.Cells[3, SG.Row]);
  except
    PrEditPriceBox.Value := 0;
  end;
  try
    PrEditAvailableBox.Value := StrToFloat(SG.Cells[4, SG.Row]);
  except
    PrEditAvailableBox.Value := 0;
  end;
end;

procedure TStorageForm.SaveStorage();
begin
  ForceDirectories('Config');
  SG.SaveToFile('Config\storage.xml');
end;

procedure TStorageForm.FormCreate(Sender: TObject);
begin
  try
    SG.SaveOptions := [soDesign, soContent];
    SG.LoadFromFile('Config\storage.xml');
    SG.Refresh;
    GetSelectedProduct();
    MainForm.LoadShop();
    except
     Application.MessageBox('Lager konnte nicht geladen werden!', 'Lager', mb_IconError + mb_Ok)
    end;
end;

procedure TStorageForm.AddProductMIClick(Sender: TObject);
begin
  SG.RowCount:= SG.RowCount + 1;
end;

procedure TStorageForm.GenStorageMIClick(Sender: TObject);
begin
  SaveStorage();
end;

procedure TStorageForm.PrEditCancelBtnClick(Sender: TObject);
begin
  GetSelectedProduct();
end;

procedure TStorageForm.PrEditSaveBtnClick(Sender: TObject);
begin
  SG.Cells[1, SG.Row] := PrEditNameBox.Text;
  SG.Cells[2, SG.Row] := PrEditStatusBox.Text;
  SG.Cells[3, SG.Row] := GetCurrency(FloatToStr(PrEditPriceBox.Value));
  SG.Cells[4, SG.Row] := FloatToStr(PrEditAvailableBox.Value);

  SaveStorage();
end;

procedure TStorageForm.RemoveProdctBtnClick(Sender: TObject);
var
  Reply, BoxStyle: Integer;
begin
  BoxStyle := MB_ICONWARNING + MB_YESNO;
  Reply := Application.MessageBox('Möchten Sie dieses Produkt wirdklich löschen?', 'Lager', BoxStyle);
  if Reply = IDYES then
  begin
    SG.DeleteRow(SG.Row);
    SaveStorage();
  end;
end;

procedure TStorageForm.SGSelection(Sender: TObject; aCol, aRow: Integer);
begin
  GetSelectedProduct();
end;

end.

