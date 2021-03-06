unit StaticsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  EditBtn, Calendar, ExtCtrls, Grids, SynHighlighterXML, TAGraph,
  TASeries, TADbSource, TASources, LCLType, Buttons, DateUtils;

type

  { TStaticsForm }

  StaticsSummary = record
    Customers : word;
    Sold : word;
    Revenue : double;
    Cancellations : word;
    Redemptions : word;
    Loses : double;
  end;

  TStaticsForm = class(TForm)
    MonthDrawChartsBtn: TButton;
    TotalChartDataSG: TStringGrid;
    Total404Lbl: TLabel;
    YearChartDataSG: TStringGrid;
    TotalRevChart: TChart;
    TotalRevChSeries: TBarSeries;
    TotalRevRCS: TRandomChartSource;
    MonthChartDataSG: TStringGrid;
    YearDrawChartsBtn: TButton;
    TotalDrawChartsBtn: TButton;
    FlowPanel2: TFlowPanel;
    FlowPanel4: TFlowPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TotalCanLbl: TLabel;
    TotalCustomersLbl: TLabel;
    TotalLosesLbl: TLabel;
    TotalRedLbl: TLabel;
    TotalRevLbl: TLabel;
    TotalSoldLbl: TLabel;
    TotalSummaryLbl: TLabel;
    TotalSummaryPanel: TPanel;
    TotalSummarySBFlowPanel: TFlowPanel;
    TotalSummaryScrollBox: TScrollBox;
    YearFlowPane1: TFlowPanel;
    YearSoldChSeries: TBarSeries;
    YearRevChSeries: TBarSeries;
    MonthSoldChSeries: TBarSeries;
    MonthRevChSeries: TBarSeries;
    TotalSoldChSeries: TBarSeries;
    YearDateEdit: TDateEdit;
    MonthDateEdit: TDateEdit;
    Month404Lbl: TLabel;
    YearFlowPane: TFlowPanel;
    MonthFlowPanel: TFlowPanel;
    MonthSummarySBFlowPanel: TFlowPanel;
    FlowPanel13: TFlowPanel;
    FlowPanel14: TFlowPanel;
    MonthSBFlowPanel: TFlowPanel;
    FlowPanel7: TFlowPanel;
    FlowPanel8: TFlowPanel;
    FlowPanel9: TFlowPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    YearCustomersLbl: TLabel;
    YearSoldLbl: TLabel;
    YearRevLbl: TLabel;
    YearCanLbl: TLabel;
    YearRedLbl: TLabel;
    YearLosesLbl: TLabel;
    Label29: TLabel;
    Label32: TLabel;
    MonthSummaryLbl: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    MonthCustomersLbl: TLabel;
    MonthSoldLbl: TLabel;
    MonthRevLbl: TLabel;
    MonthCanLbl: TLabel;
    MonthRedLbl: TLabel;
    MonthLosesLbl: TLabel;
    Year404Lbl: TLabel;
    Panel3: TPanel;
    YearSelectionPanel: TPanel;
    MonthSelectionPanel: TPanel;
    MonthSummaryPanel: TPanel;
    YearRevenueRCS: TRandomChartSource;
    MonthSoldRCS: TRandomChartSource;
    MonthRevenueRCS: TRandomChartSource;
    TotalSoldRCS: TRandomChartSource;
    ScrollBox5: TScrollBox;
    MonthSummaryScrollBox: TScrollBox;
    MonthScrollBox: TScrollBox;
    MonthRevenueChart: TChart;
    YearSoldChart: TChart;
    DayDrawChartsBtn: TButton;
    DaySoldChart: TChart;
    DayRevenueChart: TChart;
    DaySoldChSeries: TPieSeries;
    DayCal: TCalendar;
    DayCalendar: TCalendar;
    Day404Lbl: TLabel;
    DayRevChSeries: TPieSeries;
    DayChartsSBFlowPanel: TFlowPanel;
    TotalSBFlowPanel: TFlowPanel;
    YearSBFlowPanel: TFlowPanel;
    PC: TPageControl;
    DaySheet: TTabSheet;
    MonthSheet: TTabSheet;
    DaySG: TStringGrid;
    DayValues: TStringGrid;
    YearSoldRCS: TRandomChartSource;
    DayChartsScrollBox: TScrollBox;
    TotalScrollBox: TScrollBox;
    YearScrollBox: TScrollBox;
    TotalSheet: TTabSheet;
    YearSheet: TTabSheet;
    YearRevenueChart: TChart;
    MonthSoldChart: TChart;
    TotalSoldChart: TChart;
    procedure DayCalDayChanged(Sender: TObject);
    procedure DayDrawChartsBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MonthDateEditChange(Sender: TObject);
    procedure MonthDrawChartsBtnClick(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure SaveDayStatics(d : TDateTime);
    procedure LoadTotalStatics(charts : boolean = false);
    function LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
    procedure SaveTotalStatics();
    procedure TotalDrawChartsBtnClick(Sender: TObject);
    procedure YearDateEditChange(Sender: TObject);
    procedure YearDrawChartsBtnClick(Sender: TObject);
    procedure LoadMonthStatics(d : TDateTime; charts : boolean = false);
    procedure LoadYearStatics(d : TDateTime; charts : boolean = false);
    procedure SaveMonthStatics(d : TDateTime);
    procedure SaveYearStatics(d : TDateTime);
  private

  public
    loadedDay: TDateTime;
    tStatics : StaticsSummary;
    mStatics : StaticsSummary;
    yStatics : StaticsSummary;
  end;

var
  StaticsForm: TStaticsForm;
  loadedDay: TDateTime;
  tStatics : StaticsSummary;
  mStatics : StaticsSummary;
  yStatics : StaticsSummary;
  tSFile : File of StaticsSummary;
  mSFile : File of StaticsSummary;
  ySFile : File of StaticsSummary;

implementation

uses
  MainUnit;

{$R *.lfm}

{ TStaticsForm }

//Konvertiert einen Preis in einen Float.
//Dabei werden die einzelnen Zeichen ??berpr??ft
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

//L??d die Tagesstatistiken
function TStaticsForm.LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
var
  fileName, path : string;
begin
  //Pfad zur Datei erzeugen
  path := '"Statics\' + YearOf(d).ToString + '\' + MonthOf(d).ToString;
  DateTimeToString(fileName, path + '\"yyyy"_"mm"_"dd"_p.xml"', d);
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    //Datei laden
    Day404Lbl.Visible := false;
    DaySG.Clear();
    DaySG.LoadFromFile(fileName);
    DaySG.Refresh;
    try
      //Versuchen, die Zusammenfassung zu laden
      DateTimeToString(fileName, path + '\"yyyy"_"mm"_"dd"_v.xml"', d);
      DayValues.LoadFromFile(fileName);
      DayValues.Refresh;
    except
      Application.MessageBox('Die Zusammenfassung des Tages konnte nicht geladen werden!', 'Tagesstatistiken', MB_ICONERROR + MB_OK);
    end;

    //Eventuell Diagramme zeichnen
    if charts then DayDrawChartsBtnClick(DayDrawChartsBtn);

    loadedDay := d;
    Result:= true;
  end
  else
  begin
    Day404Lbl.Visible := true;
    Result:= true;
  end;
end;

//Speichert die Tagesstatistiken
procedure TStaticsForm.SaveDayStatics(d : TDateTime);
var
  fileName, path : string;
begin
  //Pfad zur Datei erzeugen
  path := 'Statics\' + YearOf(Now).ToString + '\' + MonthOf(Now).ToString;
  //Ordner erzeugen
  if ForceDirectories(path) then
  begin
    DateTimeToString(fileName, '"' + path + '\"yyyy"_"mm"_"dd"_p.xml"', d);
    DaySG.SaveToFile(fileName);
    DateTimeToString(fileName, '"' + path + '\"yyyy"_"mm"_"dd"_v.xml"', d);
    //Speichern
    DayValues.SaveToFile(fileName);
    Day404Lbl.Visible := false;
  end
  else Application.MessageBox('Das Verzeichnis konnte nicht erstellt werden!', 'Tagesstatistiken', MB_ICONERROR + MB_OK);
end;

//L??d die Gesamtstatistiken
procedure TStaticsForm.LoadTotalStatics(charts : boolean = false);
var
  filename, path : string;
begin
  //Pfad zur Datei erzeugen
  path := 'Statics';
  Total404Lbl.Visible := false;

  filename := path + '\summary.bin';
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    try
      //Datei laden
      AssignFile(tSFile, fileName);
      Reset(tSFile);
      while not EOF(tSFile) do Read(tSFile, tStatics);
      CloseFile(tSFile);
    except
      Application.MessageBox('Die Zusammenfassung konnte nicht geladen werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
    end;
  end
  else Total404Lbl.Visible := true;

  filename := path + '\charts.xml';
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    try
      //Datei laden
      TotalChartDataSG.LoadFromFile(fileName);
    except
      Application.MessageBox('Die Daten der Diagramme konnten nicht geladen werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
    end;
  end
  else Total404Lbl.Visible := true;

  //Eventuell Diagramme zeichnen
  if charts then TotalDrawChartsBtnClick(TotalDrawChartsBtn);
end;

//Speichert die Gesamtstatistiken
procedure TStaticsForm.SaveTotalStatics();
begin
  //Ordner erzeugen
  if ForceDirectories('Statics') then
  begin
    try
      //Zusammenfassung speichern
      AssignFile(tSFile, 'Statics\summary.bin');
      Rewrite(tSFile);
      Write(tSFile, tStatics);
      CloseFile(tSFile);
    except
      Application.MessageBox('Die Zusammenfassung konnte nicht gespeichert werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
    end;

    try
      //Diagramme speichern
      TotalChartDataSG.SaveToFile('Statics\charts.xml');
    except
      Application.MessageBox('Die Daten der Diagramme konnten nicht gespeichert werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
    end;
    Total404Lbl.Visible := false;
  end
  else Application.MessageBox('Das Verzeichnis konnte nicht erstellt werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
end;

//L??d die Monatsstatistiken
procedure TStaticsForm.LoadMonthStatics(d : TDateTime; charts : boolean = false);
var
  filename, path : string;
begin
  //Pfad zur Datei erzeugen
  path := 'Statics\' + YearOf(d).ToString + '\' + MonthOf(d).ToString;
  Month404Lbl.Visible := false;

  filename := path + '\summary.bin';
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    try
      //Datei laden
      AssignFile(mSFile, filename);
      Reset(mSFile);
      while not EOF(mSFile) do Read(mSFile, mStatics);
      CloseFile(mSFile);
    except
      Application.MessageBox('Die Zusammenfassung konnte nicht geladen werden!', 'Monatsstatistiken', MB_ICONERROR + MB_OK);
      Month404Lbl.Visible := true;
    end;
  end
  else Month404Lbl.Visible := true;

  filename := path + '\charts.xml';
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    try
      //Datei laden
      MonthChartDataSG.LoadFromFile(filename);
    except
      Application.MessageBox('Die Daten der Diagramme konnten nicht geladen werden!', 'Monatsstatistiken', MB_ICONERROR + MB_OK);
      Month404Lbl.Visible := true;
    end;
  end
  else Month404Lbl.Visible := true;

  //Eventuell Diagramme zeichnen
  if charts then MonthDrawChartsBtnClick(MonthDrawChartsBtn);
end;

//Speichert die Monatsstatistiken
procedure TStaticsForm.SaveMonthStatics(d : TDateTime);
var
  path : string;
begin
  //Pfad zur Datei erzeugen
  path := 'Statics\' + YearOf(d).ToString + '\' + MonthOf(d).ToString;
  //Ordner erzeugen
  if ForceDirectories(path) then
  begin
    try
      //Zusammenfassung speichern
      AssignFile(mSFile, 'Statics\' + YearOf(d).ToString + '\' + MonthOf(d).ToString + '\summary.bin');
      Rewrite(mSFile);
      Write(mSFile, mStatics);
      CloseFile(mSFile);
    except
      Application.MessageBox('Die Zusammenfassung konnte nicht gespeichert werden!', 'Monatsstatistiken', MB_ICONERROR + MB_OK);
    end;

    try
      //Diagramme speichern
      MonthChartDataSG.SaveToFile('Statics\' + YearOf(d).ToString + '\' + MonthOf(d).ToString + '\charts.xml');
    except
      Application.MessageBox('Die Daten der Diagramme konnten nicht gespeichert werden!', 'Monatsstatistiken', MB_ICONERROR + MB_OK);
    end;
    Month404Lbl.Visible := false;
  end
  else Application.MessageBox('Das Verzeichnis konnte nicht erstellt werden!', 'Monatsstatistiken', MB_ICONERROR + MB_OK);
end;

procedure TStaticsForm.LoadYearStatics(d : TDateTime; charts : boolean = false);
var
  filename, path : string;
begin
  //Pfad zur Datei erzeugen
  path := 'Statics\' + YearOf(d).ToString;
  Year404Lbl.Visible := false;

  filename := path + '\summary.bin';
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    try
      //Datei laden
      AssignFile(ySFile, filename);
      Reset(ySFile);
      while not EOF(ySFile) do Read(ySFile, yStatics);
      CloseFile(ySFile);
    except
      Application.MessageBox('Die Zusammenfassung konnte nicht geladen werden!', 'Jahresstatistiken', MB_ICONERROR + MB_OK);
    end;
  end
  else Year404Lbl.Visible := true;

  filename := path + '\charts.xml';
  //Pr??fen ob Dateien vorhanden sind
  if FileExists(fileName) then
  begin
    try
      //Datei laden
      YearChartDataSG.LoadFromFile(filename);
    except
      Application.MessageBox('Die Daten der Diagramme konnten nicht geladen werden!', 'Jahresstatistiken', MB_ICONERROR + MB_OK);
    end;
  end
  else Year404Lbl.Visible := true;

  //Eventuell Diagramme zeichnen
  if charts then MonthDrawChartsBtnClick(MonthDrawChartsBtn);
end;

//Speichert die Jahresstatistiken
procedure TStaticsForm.SaveYearStatics(d : TDateTime);
var
  path : string;
begin
  path := 'Statics\' + YearOf(d).ToString;
  //Ordner erzeugen
  if ForceDirectories(path) then
  begin
    try
      //Zusammenfassung speichern
      AssignFile(ySFile, path + '\summary.bin');
      Rewrite(ySFile);
      Write(ySFile, yStatics);
      CloseFile(ySFile);
    except
      Application.MessageBox('Die Zusammenfassung konnte nicht gespeichert werden!', 'Jahresstatistiken', MB_ICONERROR + MB_OK);
    end;
    try
      //Diagramme speichern
      YearChartDataSG.SaveToFile(path + '\charts.xml');
    except
      Application.MessageBox('Die Daten der Diagramme konnten nicht gespeichert werden!', 'Jahresstatistiken', MB_ICONERROR + MB_OK);
    end;
    Year404Lbl.Visible := false;
  end
  else Application.MessageBox('Das Verzeichnis konnte nicht erstellt werden!', 'Jahresstatistiken', MB_ICONERROR + MB_OK);
end;




procedure TStaticsForm.TotalDrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
  //Diagramme s??ubern
  TotalSoldChSeries.Clear;
  TotalRevChSeries.Clear;
  //Punkte aus Daten erzeugen
  for i:= 0 to TotalChartDataSG.RowCount - 1 do
  begin
    TotalSoldChSeries.AddXY(StrToInt(TotalChartDataSG.Cells[0,i]), StrToInt(TotalChartDataSG.Cells[1,i]), TotalChartDataSG.Cells[0,i]);
    TotalRevChSeries.AddXY(StrToInt(TotalChartDataSG.Cells[0,i]), StrToFloat(TotalChartDataSG.Cells[2,i]), TotalChartDataSG.Cells[0,i]);
  end;

  //Achsenbeschriftung anpassen
  TotalSoldChart.AxisList[1].Intervals.Count := TotalChartDataSG.RowCount;
  TotalRevChart.AxisList[1].Intervals.Count := TotalChartDataSG.RowCount;
end;

procedure TStaticsForm.YearDateEditChange(Sender: TObject);
begin
  //Jahresstatistiken laden
  LoadYearStatics(YearDateEdit.Date, true);
end;

procedure TStaticsForm.YearDrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
  //Diagramme s??ubern
  YearSoldChSeries.Clear;
  YearRevChSeries.Clear;
  //Punkte aus Daten erzeugen
  for i:= 0 to 11 do
  begin
    YearSoldChSeries.AddXY(i + 1, StrToInt(YearChartDataSG.Cells[0,i]));
    YearRevChSeries.AddXY(i + 1, StrToFloat(YearChartDataSG.Cells[1,i]));
  end;
end;

procedure TStaticsForm.FormCreate(Sender: TObject);
begin
  MainForm.StatusBar.Panels[0].Text := 'Statistiken vorbereiten...';

  //Fenster vorbereiten
  PC.TabIndex := 0;
  DayCal.DateTime := Now;
  //Zu speichernde/ladende Daten festlegen
  DaySG.SaveOptions := [soDesign, soContent];
  DayValues.SaveOptions := [soContent];
  TotalChartDataSG.SaveOptions := [soDesign, soContent];
  YearChartDataSG.SaveOptions := [soContent];
  MonthChartDataSG.SaveOptions := [soContent];
  //Statistiken laden
  LoadDayStatics(Date);
  LoadMonthStatics(Date);
  LoadYearStatics(Date);
  LoadTotalStatics();

  MainForm.StatusBar.Panels[0].Text := 'Bereit';
end;

procedure TStaticsForm.MonthDateEditChange(Sender: TObject);
begin
  //Monatsstatistiken laden
  LoadMonthStatics(MonthDateEdit.Date, true);
end;

procedure TStaticsForm.MonthDrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
  //Diagramme s??ubern
  MonthSoldChSeries.Clear;
  MonthRevChSeries.Clear;
  //Punkte aus Daten erzeugen
  for i:= 0 to 30 do
  begin
    MonthSoldChSeries.AddXY(i + 1, StrToInt(MonthChartDataSG.Cells[0,i]));
    MonthRevChSeries.AddXY(i + 1, StrToFloat(MonthChartDataSG.Cells[1,i]));
  end;
end;

procedure TStaticsForm.PCChange(Sender: TObject);
begin
  //Pr??fen welche Seite ausgew??hlt wurde
  if (PC.TabIndex = 0) then
  begin
    DayDrawChartsBtnClick(sender);
  end
  else if (PC.TabIndex = 1) then
  begin
    MonthDrawChartsBtnClick(sender);

    //Zusammenfassung darstellen
    MonthCustomersLbl.Caption:= mStatics.Customers.ToString;
    MonthSoldLbl.Caption:= mStatics.Sold.ToString;
    MonthRevLbl.Caption:= FloatToStrF(mStatics.Revenue, ffCurrency, 10, 2);
    MonthCanLbl.Caption:= mStatics.Cancellations.ToString;
    MonthRedLbl.Caption:= mStatics.Redemptions.ToString;
    MonthLosesLbl.Caption:= FloatToStrF(mStatics.Loses, ffCurrency, 10, 2);
  end
  else if (PC.TabIndex = 2) then
  begin
    YearDrawChartsBtnClick(sender);

    //Zusammenfassung darstellen
    YearCustomersLbl.Caption:= yStatics.Customers.ToString;
    YearSoldLbl.Caption:= yStatics.Sold.ToString;
    YearRevLbl.Caption:= FloatToStrF(yStatics.Revenue, ffCurrency, 10, 2);
    YearCanLbl.Caption:= yStatics.Cancellations.ToString;
    YearRedLbl.Caption:= yStatics.Redemptions.ToString;
    YearLosesLbl.Caption:= FloatToStrF(yStatics.Loses, ffCurrency, 10, 2);
  end
  else
  begin
    TotalDrawChartsBtnClick(sender);

    //Zusammenfassung darstellen
    TotalCustomersLbl.Caption:= tStatics.Customers.ToString;
    TotalSoldLbl.Caption:= tStatics.Sold.ToString;
    TotalRevLbl.Caption:= FloatToStrF(tStatics.Revenue, ffCurrency, 10, 2);
    TotalCanLbl.Caption:= tStatics.Cancellations.ToString;
    TotalRedLbl.Caption:= tStatics.Redemptions.ToString;
    TotalLosesLbl.Caption:= FloatToStrF(tStatics.Loses, ffCurrency, 10, 2);
  end;
end;

procedure TStaticsForm.DayCalDayChanged(Sender: TObject);
begin
  //Tagesstatistiken laden
  LoadDayStatics(DayCal.DateTime, true);
end;

procedure TStaticsForm.DayDrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
  //Diagramme s??ubern
  DaySoldChSeries.Clear ;
  DayRevChSeries.Clear ;
  //Punkte aus Daten erzeugen
  for i:=1 to DaySG.RowCount - 1 do
  begin
    DaySoldChSeries.AddXY(0, StrToInt(DaySG.Cells[3, i]), DaySG.Cells[1, i]);
    DayRevChSeries.AddXY(0, CurrToFloat(DaySG.Cells[4, i]), DaySG.Cells[1, i]);
  end;
end;
end.
