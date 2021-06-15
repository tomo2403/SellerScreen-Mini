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
  StdCtrls, ComCtrls, Menus, LCLIntf, Grids, LCLType, DateUtils, ShellAPI;

type

  { TMainForm }

  TMainForm = class(TForm)
    CancelBtn: TButton;
    ResetData: TMenuItem;
    NotReadyLbl: TLabel;
    MainPriceLbl: TLabel;
    PayPanel: TFlowPanel;
    CustomerLbl: TLabel;
    OpenStorageMI: TMenuItem;
    SG: TStringGrid;
    ShowStaticsMI: TMenuItem;
    AboutMI: TMenuItem;
    GitHubMI: TMenuItem;
    DocsMI: TMenuItem;
    ReloadMI: TMenuItem;
    SaveMI: TMenuItem;
    PayBtn: TButton;
    RetourBtn: TButton;
    NewCustomerBtn: TButton;
    SellPanel: TFlowPanel;
    MainMenu: TMainMenu;
    FileMI: TMenuItem;
    ViewMI: TMenuItem;
    HelpMI: TMenuItem;
    CancelPurchaseBtn: TButton;
    StatusBar: TStatusBar;
    procedure CancelBtnClick(Sender: TObject);
    procedure CancelPurchaseBtnClick(Sender: TObject);
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
    //Prüfen ob Zeichen zulässig ist
    if (curr[i] in ['0'..'9', ',', '.']) then
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
  //Für neue Daten vorbereiten
  StatusBar.Panels[0].Text := 'Laden...';
  SG.Enabled:= false;
  SG.RowCount:= 1;
  //Jedes Produkt im Lager durchegehen
  for i:= 1 to StorageForm.SG.RowCount - 1 do
  begin
    //Prüfen ob Produkt zum Verkaufen bereit ist
    if (StorageForm.SG.Cells[2, i] = 'Aktiv') and (StrToInt(StorageForm.SG.Cells[4, i]) > 0) then
    begin
      //Produkt in Kasse kopieren
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

  //Prüfen ob Produkte gealden wurden
  if SG.RowCount < 2 then
  begin
    //Hinweiß zur Kasse einblenden
    SG.Visible := false;
    SellPanel.Enabled := false;
    NotReadyLbl.Visible:= true;
  end
  else
  begin
    //Kasse einblenden
    SG.Visible := true;
    SellPanel.Enabled := true;
    NotReadyLbl.Visible:= false;
  end;

  if ShopMode > 0 then SG.Enabled:= true;

  //StatusBar aktualisieren
  StatusBar.Panels[1].Text := IntToStr(SG.RowCount - 1) + ' von ' + IntToStr(StorageForm.SG.RowCount - 1) + ' Produkten aktiv';
  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.CancelBtnClick(Sender: TObject);
var
  i : integer;
begin
  //Vorgang sichbar machen
  StatusBar.Panels[0].Text := 'Abbrechen...';
  //Kasse neu laden wenn kein Standard-Verkauf gestartet wurde
  if ShopMode > 1 then LoadShop();

  //Kasse schließen
  SG.Enabled := false;
  SellPanel.Visible := true;
  PayPanel.Visible := false;
  MainPrice:= 0;
  MainPriceLbl.Caption := 'Gesamtpreis: 0,00 €';
  ShopMode:= 0;

  //Kasse leeren
  for i:= 1 to SG.RowCount - 1 do SG.Cells[4, i]:= '0';
  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.CancelPurchaseBtnClick(Sender: TObject);
var
  i, row : integer;
begin
  //Vorgang sichbar machen
  StatusBar.Panels[0].Text := 'Stornieren...';
  if StaticsForm.LoadDayStatics(Date) then
  begin
    //Tagesstatistiken in Kasse laden
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
    //Kasse öffnen
    NewCustomerBtnClick(sender);
    ShopMode:= 2;
  end;
  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.GitHubMIClick(Sender: TObject);
begin
  //Zum GitHub Repository weiterleiten
  OpenURL('https://github.com/tomo2403/SellerScreen-Mini');
end;

procedure TMainForm.DocsMIClick(Sender: TObject);
begin
  //Zum GitHub Repository weiterleiten
  OpenURL('https://github.com/tomo2403/SellerScreen-Mini/wiki');
end;

procedure TMainForm.ResetDataClick(Sender: TObject);
var
  ShOp : TSHFileOpStruct;
  exe : boolean = false;
begin
  //Lösch-Operation vorbereiten
  ShOp.Wnd := Self.Handle;
  ShOp.wFunc := FO_DELETE;
  ShOp.pTo := nil;
  ShOp.fFlags := FOF_NOCONFIRMATION;

  //Fragen ob Lager gelöscht werden soll
  if Application.MessageBox('Möchten Sie das Lager wirklich zurücksetzten? Diese Aktion kann nicht Rückgängig gemacht werden!', 'Lager zurücksetzen', MB_ICONWARNING + MB_YESNO) = IDYES then
  begin
    //Lager löschen
    ShOp.pFrom := PChar('Config\'#0);
    SHFileOperation(ShOp);
    exe := true;
  end;

  //Fragen ob alle Statistiken gelöscht werden sollen
  if Application.MessageBox('Möchten Sie alle Statistiken löschen? Diese Aktion kann nicht Rückgängig gemacht werden!', 'Statistiken zurücksetzen', MB_ICONWARNING + MB_YESNO) = IDYES then
  begin
    //Statistiken löschen
    ShOp.pFrom := PChar('Statics\'#0);
    SHFileOperation(ShOp);
    exe := true;
  end;

  //Anwendung neu starten wenn Aktion ausgeführt
  if exe then
  begin
    Application.MessageBox('Die Anwendung wird nun neu gestartet.', 'SellerScreen-Mini', MB_ICONInformation + MB_OK);
    ShellExecute(Handle, nil, PChar(Application.ExeName), nil, nil, SW_SHOWNORMAL);
    Application.Terminate;
  end;
end;

procedure TMainForm.NewCustomerBtnClick(Sender: TObject);
begin
  //Kasse öffnen
  SG.Enabled := true;
  SellPanel.Visible := false;
  PayPanel.Visible := true;
  //Aktualisiere Kundenzähler
  CustomerLbl.Caption := 'Kunde: ' + (StrToInt(StaticsForm.DayValues.Cells[1, 0]) + 1).ToString;
  ShopMode:= 1;
end;

procedure TMainForm.OpenStorageMIClick(Sender: TObject);
begin
  //Lager öffnen und StatusBar bearbeiten
  StatusBar.Panels[0].Text := 'Lager geöffnet';
  StorageForm.ShowModal;
  StorageForm.FormCreate(sender);
  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.PayBtnClick(Sender: TObject);
var
  i, j, k, sell, sold, month, day : integer;
  found : boolean = false;
  price, revenue : double;
begin
  StatusBar.Panels[0].Text := 'Bezahlen...';
  month:= StrToInt(MonthOf(Now).ToString) - 1;
  day:= StrToInt(DayOf(Now).ToString) - 1;

  if ShopMode = 1 then
  begin
    //Tagesstatistiken laden, wenn noch nicht geschehen
    if StaticsForm.loadedDay = Date then StaticsForm.LoadDayStatics(Now);

    if (SG.RowCount > 1) then
    begin
      //Jedes Produkt ansehen
      for i:= 1 to SG.RowCount - 1 do
      begin
        sell:= StrToInt(SG.Cells[4, i]);
        if sell > 0 then
        begin
          //Werte zum Rechnen konvertierne und zwischenspeichern
          price:= CurrToFloat(SG.Cells[2, i]);
          revenue:= price * sell;
          found:= false;

          //Prüfen ob Produkt bereits verkauft wurde.
          for j:= 1 to StaticsForm.DaySG.RowCount - 1 do
          begin
            //Produkt bearbeiten wenn vorhanden
            if (StaticsForm.DaySG.Cells[1, j] = SG.Cells[1, i]) and (StaticsForm.DaySG.Cells[2, j] = SG.Cells[2, i]) then
            begin
              sold:= StrToInt(StaticsForm.DaySG.Cells[3, j]) + sell;
              StaticsForm.DaySG.Cells[3, j]:= sold.ToString;
              StaticsForm.DaySG.Cells[4, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);

              found := true;
              break;
            end;
          end;

          //Produkt neu hinzufügen wenn noch nicht verkauft
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

          //Zusammenfassung für Tagesstatistiken bearbeiten
          StaticsForm.DayValues.Cells[1, 1] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 1]) + sell);
          StaticsForm.DayValues.Cells[1, 2] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 2]) + revenue, ffCurrency, 10, 2);

          //Zusammenfassung für Gesamtstatistiken bearbeiten
          StaticsForm.tStatics.Sold := StaticsForm.tStatics.Sold + sell;
          StaticsForm.tStatics.Revenue := StaticsForm.tStatics.Revenue + revenue;

          //Produkt in Gesamtstatistiken suchen
          found:= false;
          for j:= 0 to StaticsForm.TotalChartDataSG.RowCount - 1 do
          begin
            //Produkt bearbeiten wenn gefunden
            if (StaticsForm.TotalChartDataSG.Cells[0,j] = YearOf(Now).ToString) then
            begin
              StaticsForm.TotalChartDataSG.Cells[1,j]:= (StrToInt(StaticsForm.TotalChartDataSG.Cells[1,j]) + sell).ToString;
              StaticsForm.TotalChartDataSG.Cells[2,j]:= (StrToFloat(StaticsForm.TotalChartDataSG.Cells[2,j]) + revenue).ToString;

              found:= true;
              break;
            end;
          end;

          //Produkt zu Gesamtstatistiken hinzufügen
          if not found then
          begin
            j:= StaticsForm.TotalChartDataSG.RowCount;
            StaticsForm.TotalChartDataSG.RowCount := StaticsForm.TotalChartDataSG.RowCount + 1;
            StaticsForm.TotalChartDataSG.Cells[0,j]:= YearOf(Now).ToString;
            StaticsForm.TotalChartDataSG.Cells[1,j]:= sell.ToString;
            StaticsForm.TotalChartDataSG.Cells[2,j]:= revenue.ToString;
          end;

          //Zusammenfassung für Jahresstatistiken bearbeiten
          StaticsForm.YearChartDataSG.Cells[0, month]:= (StrToInt(StaticsForm.YearChartDataSG.Cells[0, month]) + sell).ToString;
          StaticsForm.YearChartDataSG.Cells[1, month]:= (StrToFloat(StaticsForm.YearChartDataSG.Cells[1, month]) + revenue).ToString;
          StaticsForm.yStatics.Sold := StaticsForm.yStatics.Sold + sell;
          StaticsForm.yStatics.Revenue := StaticsForm.yStatics.Revenue + revenue;
          
          //Zusammenfassung für Monatsstatistiken bearbeiten
          StaticsForm.MonthChartDataSG.Cells[0, day]:= (StrToInt(StaticsForm.MonthChartDataSG.Cells[0, day]) + sell).ToString;
          StaticsForm.MonthChartDataSG.Cells[1, day]:= (StrToFloat(StaticsForm.MonthChartDataSG.Cells[1, day]) + revenue).ToString;
          StaticsForm.mStatics.Sold := StaticsForm.mStatics.Sold + sell;
          StaticsForm.mStatics.Revenue := StaticsForm.mStatics.Revenue + revenue;

          //Produkt im Lager suchen
          for j:= 1 to StorageForm.SG.RowCount - 1 do
          begin
            if (StorageForm.SG.Cells[1, j] = SG.Cells[1, i]) and (StorageForm.SG.Cells[3, j] = SG.Cells[2, i]) then
            begin
              //Produkt bearbeiten wenn gefunden
              sold:= StrToInt(StorageForm.SG.Cells[4, j]) - sell;
              StorageForm.SG.Cells[4, j]:= sold.ToString;
              SG.Cells[3, j]:= sold.ToString();

              //Schleife unterbechen weil gefunden
              break;
            end;
          end;
        end;
      end;
      
      //Kundenzähler für alle Statistiken bearbeiten
      StaticsForm.DayValues.Cells[1, 0] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 0]) + 1);
      StaticsForm.tStatics.Customers := StaticsForm.tStatics.Customers + 1;
      StaticsForm.yStatics.Customers := StaticsForm.yStatics.Customers + 1;
      StaticsForm.mStatics.Customers := StaticsForm.mStatics.Customers + 1;
    end
    else
    begin
      //Kasse schließen wenn nichts verkauft wird
      ShowMessage('Es wurde nichts zum Verkaufen ausgewählt.');
      CancelBtnClick(sender);
    end;
  end
  else if (ShopMode = 2) then
  begin
    if (SG.RowCount > 1) then
    begin
      //Jedes Produkt ansehen
      for i:= 1 to SG.RowCount - 1 do
      begin
        sell:= StrToInt(SG.Cells[4, i]);
        if sell > 0 then
        begin
          //Werte zum Rechnen konvertierne und zwischenspeichern
          price:= CurrToFloat(SG.Cells[2, i]);
          revenue:= price * sell;
          found:= false;

          //Produkt in Tagesstatistiken suchen
          for j:= 1 to StaticsForm.DaySG.RowCount - 1 do
          begin
            if (StaticsForm.DaySG.Cells[1, j] = SG.Cells[1, i]) and (StaticsForm.DaySG.Cells[2, j] = SG.Cells[2, i]) then
            begin
              //Produkt bearbeiten
              sold:= StrToInt(StaticsForm.DaySG.Cells[3, j]) - sell;
              StaticsForm.DaySG.Cells[3, j]:= sold.ToString;
              StaticsForm.DaySG.Cells[4, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);
              //Produkt entfernen wenn Verkaufszahlen = 0
              if (sold = 0) and (StrToInt(StaticsForm.DaySG.Cells[5, j]) = 0) then StaticsForm.DaySG.DeleteRow(j);
              break;
            end;
          end;

          //Zusammenfassung für Tagesstatistiken bearbeiten
          StaticsForm.DayValues.Cells[1, 1] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 1]) - sell);
          StaticsForm.DayValues.Cells[1, 2] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 2]) - revenue, ffCurrency, 10, 2);
          StaticsForm.DayValues.Cells[1, 3] := FloatToStr(CurrToFloat(StaticsForm.DayValues.Cells[1, 3]) + sell);

          //Zusammenfassung für Gesamtstatistiken bearbeiten
          StaticsForm.tStatics.Cancellations := StaticsForm.tStatics.Cancellations + sell;
          StaticsForm.tStatics.Sold := StaticsForm.tStatics.Sold - sell;
          StaticsForm.tStatics.Revenue := StaticsForm.tStatics.Revenue - revenue;

          //Produkt in Gesamtstatistiken suchen
          for j:= 0 to StaticsForm.TotalChartDataSG.RowCount - 1 do
          begin
            if (StaticsForm.TotalChartDataSG.Cells[0,j] = YearOf(Now).ToString) then
            begin
              //Produkt bearbeiten
              StaticsForm.TotalChartDataSG.Cells[1,j]:= (StrToInt(StaticsForm.TotalChartDataSG.Cells[1,j]) - sell).ToString;
              StaticsForm.TotalChartDataSG.Cells[2,j]:= (StrToFloat(StaticsForm.TotalChartDataSG.Cells[2,j]) - revenue).ToString;
              break;
            end;
          end;

          //Zusammenfassung für Jahresstatistiken bearbeiten
          StaticsForm.YearChartDataSG.Cells[0, month]:= (StrToInt(StaticsForm.YearChartDataSG.Cells[0, month]) - sell).ToString;
          StaticsForm.YearChartDataSG.Cells[1, month]:= (StrToFloat(StaticsForm.YearChartDataSG.Cells[1, month]) - revenue).ToString;
          StaticsForm.yStatics.Sold := StaticsForm.yStatics.Sold - sell;
          StaticsForm.yStatics.Revenue := StaticsForm.yStatics.Revenue - revenue;
          StaticsForm.yStatics.Cancellations := StaticsForm.yStatics.Cancellations + 1;

          //Zusammenfassung für Monatsstatistiken bearbeiten
          StaticsForm.MonthChartDataSG.Cells[0, day]:= (StrToInt(StaticsForm.MonthChartDataSG.Cells[0, day]) - sell).ToString;
          StaticsForm.MonthChartDataSG.Cells[1, day]:= (StrToFloat(StaticsForm.MonthChartDataSG.Cells[1, day]) - revenue).ToString;
          StaticsForm.mStatics.Sold := StaticsForm.mStatics.Sold - sell;
          StaticsForm.mStatics.Revenue := StaticsForm.mStatics.Revenue - revenue;
          StaticsForm.mStatics.Cancellations := StaticsForm.mStatics.Cancellations + 1;

          //Produkt im Lager suchen
          for j:= 1 to StorageForm.SG.RowCount - 1 do
          begin
            if (StorageForm.SG.Cells[1, j] = SG.Cells[1, i]) and (StorageForm.SG.Cells[3, j] = SG.Cells[2, i]) then
            begin
              //Produkt bearbeiten wenn gefunden
              StorageForm.SG.Cells[4, j]:= (StrToInt(StorageForm.SG.Cells[4, j]) + sell).ToString;
              found:= true;
              break;
            end;
          end;

          if not found then Application.MessageBox(PChar('Das Produkt ' + SG.Cells[1, i] + ' befindet sich nicht mehr im Lager!'), 'Problem beim Stornieren', MB_ICONWARNING + MB_OK);
      end;
    end;
      LoadShop();
    end
    else
    begin
      //Kasse schließen wenn nichts verkauft wird
      ShowMessage('Es wurde nichts zum Stornieren ausgewählt.');
      CancelBtnClick(sender);
    end;
  end
  else if (ShopMode = 3) then
  begin
    if (SG.RowCount > 1) then
    begin
      //Jedes Produkt ansehen
      for i:= 1 to SG.RowCount - 1 do
      begin
        sell:= StrToInt(SG.Cells[4, i]);
        if sell > 0 then
        begin
          //Werte zum Rechnen konvertierne und zwischenspeichern
          price:= CurrToFloat(SG.Cells[2, i]);
          revenue:= price * sell;

          //Produkt in Tagesstatistiken suchen
          for j:= 1 to StaticsForm.DaySG.RowCount - 1 do
          begin
            if (StaticsForm.DaySG.Cells[1, j] = SG.Cells[1, i]) and (StaticsForm.DaySG.Cells[2, j] = SG.Cells[2, i]) then
            begin
              //Produkt bearbeiten
              sold:= StrToInt(StaticsForm.DaySG.Cells[5, j]) + sell;
              StaticsForm.DaySG.Cells[5, j]:= sold.ToString;
              StaticsForm.DaySG.Cells[6, j]:= FloatToStrF(price * sold, ffCurrency, 10, 2);
              break;
            end;
          end;

          //Zusammenfassung für Tagesstatistiken bearbeiten
          StaticsForm.DayValues.Cells[1, 4] := IntToStr(StrToInt(StaticsForm.DayValues.Cells[1, 4]) + sell);
          StaticsForm.DayValues.Cells[1, 5] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 5]) + revenue, ffCurrency, 10, 2);

          //Zusammenfassung für Gesamtstatistiken bearbeiten
          StaticsForm.tStatics.Redemptions := StaticsForm.tStatics.Redemptions + sell;
          StaticsForm.tStatics.Loses := StaticsForm.tStatics.Loses + revenue;

          //Zusammenfassung für Jahresstatistiken bearbeiten
          StaticsForm.yStatics.Loses := StaticsForm.yStatics.Loses + revenue;
          StaticsForm.yStatics.Redemptions := StaticsForm.yStatics.Redemptions + sell;

          //Zusammenfassung für Monatsstatistiken bearbeiten
          StaticsForm.mStatics.Loses := StaticsForm.mStatics.Loses + revenue;
          StaticsForm.mStatics.Redemptions := StaticsForm.mStatics.Redemptions + sell;
      end;
    end;
      //Kasse für Standard-Verkauf vorbereiten
      LoadShop();
    end
    else
    begin
      //Kasse schließen wenn nichts ausgewählt wurde
      ShowMessage('Es wurde nichts zum Zurücknehmen ausgewählt.');
      CancelBtnClick(sender);
    end;
  end;

  //Lager und Statistiken speichern
  StaticsForm.DayValues.Cells[1, 6] := FloatToStrF(CurrToFloat(StaticsForm.DayValues.Cells[1, 2]) - CurrToFloat(StaticsForm.DayValues.Cells[1, 5]), ffCurrency, 10, 2);
  StorageForm.SaveStorage();
  StaticsForm.SaveDayStatics(Date);
  StaticsForm.SaveTotalStatics();
  StaticsForm.SaveMonthStatics(Date);
  StaticsForm.SaveYearStatics(Date);
  //Kasse schließen
  CancelBtnClick(sender);

  StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TMainForm.RetourBtnClick(Sender: TObject);
begin
  //Kasse vorbereiten
  CancelPurchaseBtnClick(sender);
  ShopMode:= 3;
end;

procedure TMainForm.SaveMIClick(Sender: TObject);
begin
  //Lager speichern
  StorageForm.SaveStorage();
end;

procedure TMainForm.ReloadMIClick(Sender: TObject);
begin
  //Lager neu laden und Kasse aktualisieren
  StorageForm.FormCreate(sender);
  LoadShop();
end;

procedure TMainForm.SGButtonClick(Sender: TObject; aCol, aRow: Integer);
var
  before, av : integer;
  price : real = 0;
begin
  //Verkaufsanzahl vor bearbeitung
  before := StrToInt(SG.Cells[4, aRow]);
  //Maximale Verfügbarkeit
  av:= StrToInt(SG.Cells[3, aRow]);
  //Prüfen welche Spalte ausgelöst hat
  case aCol of
  5: if before < av then SG.Cells[4, aRow] := (before + 1).ToString;
  6: if before > 0 then SG.Cells[4, aRow] := (before - 1).ToString;
  7: SG.Cells[4, aRow] := av.ToString;
  8: SG.Cells[4, aRow] := '0';
  end;

  //Gesamtpreis aktualisieren
  price:= CurrToFloat(SG.Cells[2, aRow]);
  MainPrice:= MainPrice - (price * before);
  MainPrice:= MainPrice + (price * StrToInt(SG.Cells[4, aRow]));
  MainPriceLbl.Caption := 'Gesamtpreis: ' + FloatToStrF(MainPrice, ffCurrency, 10, 2);
end;

procedure TMainForm.ShowStaticsMIClick(Sender: TObject);
begin
  //Statistiken anzeigen
  StaticsForm.Show;
end;

procedure TMainForm.AboutMIClick(Sender: TObject);
begin
  //Über-Fenster öffnen
  AboutForm.ShowModal;
end;
end.
