unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  StdCtrls, ComCtrls, Menus, LCLIntf, Grids;

type

  { TMainForm }

  TMainForm = class(TForm)
    CancelBtn: TButton;
    MainPriceLbl: TLabel;
    PayPanel: TFlowPanel;
    CustomerLbl: TLabel;
    MenuItem10: TMenuItem;
    OpenStorageMI: TMenuItem;
    SG: TStringGrid;
    ShowStaticsMI: TMenuItem;
    OpenSettingsMI: TMenuItem;
    AboutMI: TMenuItem;
    GitHubMI: TMenuItem;
    DocsMI: TMenuItem;
    ReloadMI: TMenuItem;
    SaveMI: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PayBtn: TButton;
    RetourBtn: TButton;
    NewCustomerBtn: TButton;
    SellPanel: TFlowPanel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    CancelPurchaseBtn: TButton;
    StatusBar: TStatusBar;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadShop();
    procedure AboutMIClick(Sender: TObject);
    procedure GitHubMIClick(Sender: TObject);
    procedure DocsMIClick(Sender: TObject);
    procedure NewCustomerBtnClick(Sender: TObject);
    procedure OpenStorageMIClick(Sender: TObject);
    procedure PayBtnClick(Sender: TObject);
    procedure SaveMIClick(Sender: TObject);
    procedure ReloadMIClick(Sender: TObject);
    procedure SGButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure ShowStaticsMIClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;
  MainPrice: Real = 0;

implementation

uses
  AboutUnit, StorageUnit, StaticsUnit;

{$R *.lfm}

{ TMainForm }

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

procedure TMainForm.LoadShop();
var
  i: integer;
begin
  StatusBar.Panels[0].Text := 'Laden...';
  SG.RowCount:= 1;
  for i:= 0 to StorageForm.SG.RowCount - 1 do
  begin
    if (StorageForm.SG.Cells[2, i] = 'Aktiv') and (StrToInt(StorageForm.SG.Cells[4, i]) > 0) then
    begin
      SG.RowCount:= SG.RowCount + 1;
      SG.Cells[1, SG.RowCount - 1]:= StorageForm.SG.Cells[1, i];
      SG.Cells[2, SG.RowCount - 1]:= StorageForm.SG.Cells[3, i];
      SG.Cells[3, SG.RowCount - 1]:= StorageForm.SG.Cells[4, i];
      SG.Cells[4, SG.RowCount - 1]:= '0';
      SG.Cells[5, SG.RowCount - 1]:= '+';
      SG.Cells[6, SG.RowCount - 1]:= '-';
      SG.Cells[7, SG.RowCount - 1]:= '+++';
      SG.Cells[8, SG.RowCount - 1]:= '---';
    end;
  end;
  StatusBar.Panels[1].Text := IntToStr(SG.RowCount - 1) + ' von ' + IntToStr(StorageForm.SG.RowCount - 1) + ' Produkten aktiv';
  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

end;

procedure TMainForm.CancelBtnClick(Sender: TObject);
var
  i : integer;
begin
  SG.Enabled := false;
  SellPanel.Visible := true;
  PayPanel.Visible := false;
  MainPriceLbl.Caption := 'Gesamtpreis: 0,00 €';

  for i:= 1 to SG.RowCount - 1 do SG.Cells[4, i]:= '0';
end;

procedure TMainForm.GitHubMIClick(Sender: TObject);
begin
  OpenURL('https://github.com/tomo2403/SellerScreen-Mini');
end;

procedure TMainForm.DocsMIClick(Sender: TObject);
begin

end;

procedure TMainForm.NewCustomerBtnClick(Sender: TObject);
begin
  SG.Enabled := true;
  SellPanel.Visible := false;
  PayPanel.Visible := true;
end;

procedure TMainForm.OpenStorageMIClick(Sender: TObject);
begin
  StorageForm.ShowModal;
  StorageForm.FormCreate(sender);
end;

procedure TMainForm.PayBtnClick(Sender: TObject);
var
  i, j, k, sell, sold : integer;
  found : boolean = false;
  price, revenue : double;
begin
  if (SG.RowCount > 1) then
  begin
    for i:= 1 to SG.RowCount - 1 do
    begin
      sell:= StrToInt(SG.Cells[4, i]);
      if sell > 0 then
      begin
        price:= CurrToFloat(SG.Cells[2, i]);
        revenue:= price * sell;

        for j:= 1 to StaticsForm.DaySG.RowCount - 1 do
        begin
          if (StaticsForm.DaySG.Cells[1, j] = SG.Cells[1, i]) and (StaticsForm.DaySG.Cells[2, j] = SG.Cells[2, i]) then
          begin
            sold:= StrToInt(StaticsForm.DaySG.Cells[3, j]) + sell;
            StaticsForm.DaySG.Cells[3, j]:= sold.ToString;
            StaticsForm.DaySG.Cells[4, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);

            found := true;
            continue;
          end;
        end;

        if not found or (StaticsForm.DaySG.RowCount < 2) then
        begin
          StaticsForm.DaySG.RowCount:= StaticsForm.DaySG.RowCount + 1;
          k:= StaticsForm.DaySG.RowCount - 1;
          StaticsForm.DaySG.Cells[1, k]:= SG.Cells[1, i];
          StaticsForm.DaySG.Cells[2, k]:= SG.Cells[2, i];
          StaticsForm.DaySG.Cells[3, k]:= sell.ToString;
          StaticsForm.DaySG.Cells[4, k]:= revenue.ToString;
          StaticsForm.DaySG.Cells[5, k]:= '0';
          StaticsForm.DaySG.Cells[6, k]:= FloatToStrF(0, ffCurrency, 10, 2);
        end;

        StaticsForm.DayValues.Cells[1, 0] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 0]) + 1);
        StaticsForm.DayValues.Cells[1, 1] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 1]) + sell);
        StaticsForm.DayValues.Cells[1, 2] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 2]) + revenue, ffCurrency, 10, 2);

        for j:= 1 to StorageForm.SG.RowCount - 1 do
        begin
          if (StorageForm.SG.Cells[1, j] = SG.Cells[1, i]) and (StorageForm.SG.Cells[3, j] = SG.Cells[2, i]) then
          begin
            sold:= StrToInt(StorageForm.SG.Cells[4, j]) - sell;
            StorageForm.SG.Cells[4, j]:= sold.ToString;
            StorageForm.SG.SaveToFile('storage.xml');
            SG.Cells[3, j]:= sold.ToString();

            continue;
          end;
        end;
      end;
    end;
    StaticsForm.SaveDayStatics(Date);
    CancelBtnClick(sender);
  end
  else
  begin
    ShowMessage('Es wurde nichts zum Verkaufen ausgewählt.');
    CancelBtnClick(sender);
  end;
end;

procedure TMainForm.SaveMIClick(Sender: TObject);
begin
  StorageForm.SG.SaveToFile('storage.xml');
end;

procedure TMainForm.ReloadMIClick(Sender: TObject);
begin
  StorageForm.FormCreate(sender);
  LoadShop();
end;

procedure TMainForm.SGButtonClick(Sender: TObject; aCol, aRow: Integer);
var
  befor, av : integer;
  price : real = 0;
begin
  befor := StrToInt(SG.Cells[4, aRow]);
  av:= StrToInt(SG.Cells[3, aRow]);
  case aCol of
  5: if befor < av then SG.Cells[4, aRow] := (befor + 1).ToString;
  6: if befor > 0 then SG.Cells[4, aRow] := (befor - 1).ToString;
  7: SG.Cells[4, aRow] := av.ToString;
  8: SG.Cells[4, aRow] := '0';
  end;

  price:= CurrToFloat(SG.Cells[2, aRow]);
  MainPrice:= MainPrice - (price * befor);
  MainPrice:= MainPrice + (price * StrToInt(SG.Cells[4, aRow]));
  MainPriceLbl.Caption := 'Gesamtpreis: ' + FloatToStrF(MainPrice, ffCurrency, 10, 2);
end;

procedure TMainForm.ShowStaticsMIClick(Sender: TObject);
begin
  StaticsForm.Show;
end;

procedure TMainForm.AboutMIClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

end.

