{ SellerScreen-Mini

  Copyright (c) 2021 tomo2403

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
}

unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  StdCtrls, ComCtrls, Menus, LCLIntf, Grids, LCLType;

type

  { TMainForm }

  TMainForm = class(TForm)
    CancelBtn: TButton;
    NotReadyLbl: TLabel;
    MainPriceLbl: TLabel;
    PayPanel: TFlowPanel;
    CustomerLbl: TLabel;
    ResetData: TMenuItem;
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
    FileMI: TMenuItem;
    ViewMI: TMenuItem;
    DemoMI: TMenuItem;
    HelpMI: TMenuItem;
    CancelPurchaseBtn: TButton;
    StatusBar: TStatusBar;
    procedure CancelBtnClick(Sender: TObject);
    procedure CancelPurchaseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadShop();
    procedure AboutMIClick(Sender: TObject);
    procedure GitHubMIClick(Sender: TObject);
    procedure DocsMIClick(Sender: TObject);
    procedure ResetDataClick(Sender: TObject);
    procedure NewCustomerBtnClick(Sender: TObject);
    procedure OpenStorageMIClick(Sender: TObject);
    procedure PayBtnClick(Sender: TObject);
    procedure RetourBtnClick(Sender: TObject);
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
  ShopMode: integer = 0;

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
  SG.Enabled:= false;
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

  if SG.RowCount < 2 then
  begin
    SG.Visible := false;
    SellPanel.Enabled := false;
    NotReadyLbl.Visible:= true;
  end
  else
  begin
    SG.Visible := true;
    SellPanel.Enabled := true;
    NotReadyLbl.Visible:= false;
  end;

  SG.Enabled:= true;
  StatusBar.Panels[1].Text := IntToStr(SG.RowCount - 1) + ' von ' + IntToStr(StorageForm.SG.RowCount - 1) + ' Produkten aktiv';
  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ForceDirectories('Config');
  ForceDirectories('Statics\Day');
  ForceDirectories('Statics\Month');
  ForceDirectories('Statics\Year');
end;

procedure TMainForm.CancelBtnClick(Sender: TObject);
var
  i : integer;
begin
  if ShopMode > 1 then LoadShop();

  SG.Enabled := false;
  SellPanel.Visible := true;
  PayPanel.Visible := false;
  MainPrice:= 0;
  MainPriceLbl.Caption := 'Gesamtpreis: 0,00 €';
  ShopMode:= 0;

  for i:= 1 to SG.RowCount - 1 do SG.Cells[4, i]:= '0';
end;

procedure TMainForm.CancelPurchaseBtnClick(Sender: TObject);
var
  i, row : integer;
begin
  if StaticsForm.LoadDayStatics(Date) then
  begin
    SG.RowCount:= 1;
    for i:= 1 to StaticsForm.DaySG.RowCount - 1 do
    begin
      if (StrToInt(StaticsForm.DaySG.Cells[3, i]) - StrToInt(StaticsForm.DaySG.Cells[5, i]) > 0) then
      begin
        row:= SG.RowCount;
        SG.RowCount:= row + 1;
        SG.Cells[1, row]:= StaticsForm.DaySG.Cells[1, row];
        SG.Cells[2, row]:= StaticsForm.DaySG.Cells[2, row];
        SG.Cells[3, row]:= (StrToInt(StaticsForm.DaySG.Cells[3, row]) - StrToInt(StaticsForm.DaySG.Cells[5, row])).ToString;
        SG.Cells[4, row]:= '0';
        SG.Cells[5, row]:= '+';
        SG.Cells[6, row]:= '-';
        SG.Cells[7, row]:= '+++';
        SG.Cells[8, row]:= '---';
      end;
    end;
    NewCustomerBtnClick(sender);
    ShopMode:= 2;
  end;
end;

procedure TMainForm.GitHubMIClick(Sender: TObject);
begin
  OpenURL('https://github.com/tomo2403/SellerScreen-Mini');
end;

procedure TMainForm.DocsMIClick(Sender: TObject);
begin

end;

procedure TMainForm.ResetDataClick(Sender: TObject);
begin

end;

procedure TMainForm.NewCustomerBtnClick(Sender: TObject);
begin
  SG.Enabled := true;
  SellPanel.Visible := false;
  PayPanel.Visible := true;
  ShopMode:= 1;
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
  if ShopMode = 1 then
  begin
    if not StaticsForm.loadedToday then
      StaticsForm.LoadDayStatics(Date);

    if (SG.RowCount > 1) then
    begin
      for i:= 1 to SG.RowCount - 1 do
      begin
        sell:= StrToInt(SG.Cells[4, i]);
        if sell > 0 then
        begin
          price:= CurrToFloat(SG.Cells[2, i]);
          revenue:= price * sell;
          found:= false;

          for j:= 1 to StaticsForm.DaySG.RowCount - 1 do
          begin
            if (StaticsForm.DaySG.Cells[1, j] = SG.Cells[1, i]) and (StaticsForm.DaySG.Cells[2, j] = SG.Cells[2, i]) then
            begin
              sold:= StrToInt(StaticsForm.DaySG.Cells[3, j]) + sell;
              StaticsForm.DaySG.Cells[3, j]:= sold.ToString;
              StaticsForm.DaySG.Cells[4, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);

              found := true;
              break;
            end;
          end;

          if not found or (StaticsForm.DaySG.RowCount < 2) then
          begin
            StaticsForm.DaySG.RowCount:= StaticsForm.DaySG.RowCount + 1;
            k:= StaticsForm.DaySG.RowCount - 1;
            StaticsForm.DaySG.Cells[1, k]:= SG.Cells[1, i];
            StaticsForm.DaySG.Cells[2, k]:= SG.Cells[2, i];
            StaticsForm.DaySG.Cells[3, k]:= sell.ToString;
            StaticsForm.DaySG.Cells[4, k]:= FloatToStrF(revenue, ffCurrency, 10, 2);
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
              SG.Cells[3, j]:= sold.ToString();

              break;
            end;
          end;
        end;
      end;
      StorageForm.SG.SaveToFile('storage.xml');
      StaticsForm.SaveDayStatics(Date);
      CancelBtnClick(sender);
    end
    else
    begin
      ShowMessage('Es wurde nichts zum Verkaufen ausgewählt.');
      CancelBtnClick(sender);
    end;
  end
  else if (ShopMode = 2) then
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
          found:= false;

          for j:= 1 to StaticsForm.DaySG.RowCount - 1 do
          begin
            if (StaticsForm.DaySG.Cells[1, j] = SG.Cells[1, i]) and (StaticsForm.DaySG.Cells[2, j] = SG.Cells[2, i]) then
            begin
              sold:= StrToInt(StaticsForm.DaySG.Cells[3, j]) - sell;
              StaticsForm.DaySG.Cells[3, j]:= sold.ToString;
              StaticsForm.DaySG.Cells[4, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);
              if (sold = 0) and (StrToInt(StaticsForm.DaySG.Cells[5, j]) = 0) then StaticsForm.DaySG.DeleteRow(j);
              break;
            end;
          end;

          StaticsForm.DayValues.Cells[1, 1] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 1]) - sell);
          StaticsForm.DayValues.Cells[1, 2] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 2]) - revenue, ffCurrency, 10, 2);
          StaticsForm.DayValues.Cells[1, 3] := FloatToStr(CurrToFloat(StaticsForm.DayValues.Cells[1, 3]) + sell);

          for j:= 1 to StorageForm.SG.RowCount - 1 do
          begin
            if (StorageForm.SG.Cells[1, j] = SG.Cells[1, i]) and (StorageForm.SG.Cells[3, j] = SG.Cells[2, i]) then
            begin
              StorageForm.SG.Cells[4, j]:= (StrToInt(StorageForm.SG.Cells[4, j]) + sell).ToString;
              found:= true;
              break;
            end;
          end;

          if not found then Application.MessageBox(PChar('Das Produkt ' + SG.Cells[1, i] + ' befindet sich nicht mehr im Lager!'), 'Problem beim Stornieren', MB_ICONWARNING + MB_OK);
      end;
    end;
      StorageForm.SG.SaveToFile('storage.xml');
      StaticsForm.SaveDayStatics(Date);
      CancelBtnClick(sender);
      LoadShop();
    end
    else
    begin
      ShowMessage('Es wurde nichts zum Stornieren ausgewählt.');
      CancelBtnClick(sender);
    end;
  end
  else if (ShopMode = 3) then
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
              sold:= StrToInt(StaticsForm.DaySG.Cells[5, j]) + sell;
              StaticsForm.DaySG.Cells[5, j]:= sold.ToString;
              StaticsForm.DaySG.Cells[6, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);
              break;
            end;
          end;

          StaticsForm.DayValues.Cells[1, 4] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 4]) + sell);
          StaticsForm.DayValues.Cells[1, 5] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 5]) + revenue, ffCurrency, 10, 2);
      end;
    end;
      StorageForm.SG.SaveToFile('storage.xml');
      StaticsForm.SaveDayStatics(Date);
      CancelBtnClick(sender);
      LoadShop();
    end
    else
    begin
      ShowMessage('Es wurde nichts zum Zurücknehmen ausgewählt.');
      CancelBtnClick(sender);
    end;
  end;
end;

procedure TMainForm.RetourBtnClick(Sender: TObject);
begin
  CancelPurchaseBtnClick(sender);
  ShopMode:= 3;
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

