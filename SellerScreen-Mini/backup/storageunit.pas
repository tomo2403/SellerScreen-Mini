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
    procedure SGSelection(Sender: TObject);
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

//Konvertiert einen Preis in einen Float.
//Dabei werden die einzelnen Zeichen überprüft
function CurrToFloat(curr: String) : double;
var
  i : Integer;
  Str : String = '';
begin
  Result := 0;
  for i := 1 to length(curr) do
  begin
    if (curr[i] in ['0'..'9', ',', '.']) then
    begin
      Str := Str + curr[i];
      Result := StrToFloat(Str);
    end;
  end;
end;

//Kopiert das asgewählte Produkt in das Bearbeitungsfeld
procedure TStorageForm.GetSelectedProduct();
begin
  try
    //Namen lesen
    PrEditNameBox.Text := SG.Cells[1, SG.Row];
  except
    PrEditNameBox.Text := 'n/a';
  end;
  try
    //Status lesen
    case SG.Cells[2, SG.Row] of
      'Aktiv': PrEditStatusBox.ItemIndex := 0
      else PrEditStatusBox.ItemIndex := 1;
    end;
  except
    PrEditStatusBox.ItemIndex := 1;
  end;
  try
    //Preis lesen
    PrEditPriceBox.Value := CurrToFloat(SG.Cells[3, SG.Row]);
  except
    PrEditPriceBox.Value := 0;
  end;
  try
    //Verfügbarkeit lesen
    PrEditAvailableBox.Value := StrToFloat(SG.Cells[4, SG.Row]);
  except
    PrEditAvailableBox.Value := 0;
  end;
end;

procedure TStorageForm.SaveStorage();
begin
  MainForm.StatusBar.Panels[0].Text := 'Speichern...';
  //Ordner erzeugen
  ForceDirectories('Config');
  //Datei speichern
  SG.SaveToFile('Config\storage.xml');
  MainForm.StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TStorageForm.FormCreate(Sender: TObject);
begin
  MainForm.StatusBar.Panels[0].Text := 'Lager vorbereiten...';
  try
    //Lager laden
    SG.SaveOptions := [soDesign, soContent];
    SG.LoadFromFile('Config\storage.xml');
    SG.Refresh;
    GetSelectedProduct();
  except
    Application.MessageBox('Lager konnte nicht geladen werden!', 'SellerScreen-Mini', mb_IconError + mb_Ok)
  end;
  //Kasse aktualisieren
  MainForm.LoadShop();
  MainForm.StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TStorageForm.AddProductMIClick(Sender: TObject);
begin
  //Zeile für neues Produkt einfügen
  SG.RowCount:= SG.RowCount + 1;
end;

procedure TStorageForm.PrEditCancelBtnClick(Sender: TObject);
begin
  GetSelectedProduct();
end;

procedure TStorageForm.PrEditSaveBtnClick(Sender: TObject);
begin
  SG.Cells[1, SG.Row] := PrEditNameBox.Text;
  SG.Cells[2, SG.Row] := PrEditStatusBox.Text;
  SG.Cells[3, SG.Row] := FloatToStrF(PrEditPriceBox.Value, ffCurrency, 10, 2);
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

procedure TStorageForm.SGSelection(Sender: TObject);
begin
  GetSelectedProduct();
end;

end.

