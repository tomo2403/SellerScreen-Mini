unit StaticsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  EditBtn, Calendar, ExtCtrls, Grids, SynHighlighterXML, TAGraph,
  TASeries, TADbSource, TASources, LCLType, Buttons;

type

  { TStaticsForm }

  TStaticsForm = class(TForm)
    MonthDrawChartsBtn: TButton;
    TotalChartDataSG: TStringGrid;
    TotalRevChart: TChart;
    TotalRevChSeries: TBarSeries;
    TotalRevRCS: TRandomChartSource;
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
    YearLossesLbl: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
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
    MonthLossesLbl: TLabel;
    Label46: TLabel;
    Label49: TLabel;
    Year404Lbl: TLabel;
    Panel3: TPanel;
    YearSelectionPanel: TPanel;
    Panel5: TPanel;
    MonthSelectionPanel: TPanel;
    MonthSummaryPanel: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    YearRevenueRCS: TRandomChartSource;
    MonthSoldRCS: TRandomChartSource;
    MonthRevenueRCS: TRandomChartSource;
    TotalSoldRCS: TRandomChartSource;
    ScrollBox5: TScrollBox;
    MonthSummaryScrollBox: TScrollBox;
    MonthScrollBox: TScrollBox;
    YearTopSoldSG: TStringGrid;
    YearTopRevSG: TStringGrid;
    MonthTopSoldSG: TStringGrid;
    MonthTopRevSG: TStringGrid;
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
    Label14: TLabel;
    Label15: TLabel;
    Panel2: TPanel;
    PC: TPageControl;
    DaySheet: TTabSheet;
    MonthSheet: TTabSheet;
    DaySG: TStringGrid;
    DayValues: TStringGrid;
    YearSoldRCS: TRandomChartSource;
    DayChartsScrollBox: TScrollBox;
    TotalScrollBox: TScrollBox;
    YearScrollBox: TScrollBox;
    TotalTopSoldSG: TStringGrid;
    TotalTopRevLbl: TStringGrid;
    TotalSheet: TTabSheet;
    YearSheet: TTabSheet;
    YearRevenueChart: TChart;
    MonthSoldChart: TChart;
    TotalSoldChart: TChart;
    procedure DayCalDayChanged(Sender: TObject);
    procedure DayDrawChartsBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure SaveDayStatics(d : TDateTime);
    procedure LoadTotalStatics(charts : boolean = false);
    function LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
    procedure SaveTotalStatics();
    procedure TotalDrawChartsBtnClick(Sender: TObject);
  private

  public
    loadedToday: boolean;
  end;

  TotalStaticsSummary = record
    Customers : word;
    Sold : word;
    Revenue : double;
    Cancellations : word;
    Redemptions : word;
    Loses : double;
  end;


var
  StaticsForm: TStaticsForm;
  loadedToday: boolean = false;
  tStatics : TotalStaticsSummary;
  tSFile : File of TotalStaticsSummary;


implementation

{$R *.lfm}

{ TStaticsForm }

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

procedure TStaticsForm.SaveDayStatics(d : TDateTime);
var
  fileName : string;
begin
  DateTimeToString(fileName, '"Statics\Day\"yyyymmdd"0.xml"', d);
  DaySG.SaveToFile(fileName);
  DateTimeToString(fileName, '"Statics\Day\"yyyymmdd"1.xml"', d);
  DayValues.SaveToFile(fileName);
end;

function TStaticsForm.LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
var
  fileName : string;
begin
  DateTimeToString(fileName, '"Statics\Day\"yyyymmdd"0.xml"', d);
  if FileExists(fileName) then
  begin
    Day404Lbl.Visible := false;
    DaySG.Clear();
    DaySG.LoadFromFile(fileName);
    DaySG.Refresh;
    try
      DateTimeToString(fileName, '"Statics\Day\"yyyymmdd"1.xml"', d);
      DayValues.LoadFromFile(fileName);
      DayValues.Refresh;
    except
      Application.MessageBox('Die Zusammenfassung des Tages konnte nicht geladen werden!', 'Tagesstatistiken', MB_ICONERROR + MB_OK);
    end;

    if charts then DayDrawChartsBtnClick(DayDrawChartsBtn);

    if d = Date then loadedToday := true
    else loadedToday := false;

    Result:= true;
  end
  else
  begin
    Day404Lbl.Visible := true;
    Result:= true;
  end;
end;

procedure TStaticsForm.LoadTotalStatics(charts : boolean = false);
begin
  try
    AssignFile(tSFile, 'Statics\Total\total_summary');
    Reset(tSFile);
    while not EOF(tSFile) do
    begin
      Read(tSFile, tStatics);
    end;
    CloseFile(tSFile);

    TotalCustomersLbl.Caption:= tStatics.Customers.ToString;
    TotalSoldLbl.Caption:= tStatics.Sold.ToString;
    TotalRevLbl.Caption:= FloatToStrF(tStatics.Revenue, ffCurrency, 10, 2);
    TotalCanLbl.Caption:= tStatics.Cancellations.ToString;
    TotalRedLbl.Caption:= tStatics.Redemptions.ToString;
    TotalLosesLbl.Caption:= FloatToStrF(tStatics.Loses, ffCurrency, 10, 2);
  except
    Application.MessageBox('Die Zusammenfassung konnte nicht geladen werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
  end;

  try
    TotalChartDataSG.LoadFromFile('Statics\Total\total_charts.xml');
  except
    Application.MessageBox('Die Daten der Diagramme konnten nicht geladen werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
  end;

  if charts then TotalDrawChartsBtnClick(TotalDrawChartsBtn);
end;

procedure TStaticsForm.SaveTotalStatics();
begin
  try
    tStatics.Customers:= StrToInt(TotalCustomersLbl.Caption);
    tStatics.Sold:= StrToInt(TotalSoldLbl.Caption);
    tStatics.Revenue:= CurrToFloat(TotalRevLbl.Caption);
    tStatics.Cancellations:= StrToInt(TotalCanLbl.Caption);
    tStatics.Redemptions:= StrToInt(TotalRedLbl.Caption);
    tStatics.Loses:= CurrToFloat(TotalLosesLbl.Caption);
    AssignFile(tSFile, 'Statics\Total\total_summary');
    Rewrite(tSFile);
    Write(tSFile, tStatics);
    CloseFile(tSFile);
  except
    Application.MessageBox('Die Zusammenfassung konnte nicht gespeichert werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
  end;

  try
    TotalChartDataSG.SaveToFile('Statics\Total\total_charts.xml');
  except
    Application.MessageBox('Die Daten der Diagramme konnten nicht gespeichert werden!', 'Gesamtstatistiken', MB_ICONERROR + MB_OK);
  end;
end;

procedure TStaticsForm.TotalDrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
    TotalSoldChSeries.Clear;
    TotalRevChSeries.Clear;
    for i:= 0 to TotalChartDataSG.RowCount - 1 do
    begin
      TotalSoldChSeries.AddXY(StrToInt(TotalChartDataSG.Cells[0,i]), StrToInt(TotalChartDataSG.Cells[1,i]), TotalChartDataSG.Cells[0,i]);
      TotalRevChSeries.AddXY(StrToInt(TotalChartDataSG.Cells[0,i]), StrToFloat(TotalChartDataSG.Cells[2,i]), TotalChartDataSG.Cells[0,i]);
    end;
    TotalSoldChart.AxisList[1].Intervals.Count := TotalChartDataSG.RowCount;
    TotalRevChart.AxisList[1].Intervals.Count := TotalChartDataSG.RowCount;
end;

procedure TStaticsForm.FormCreate(Sender: TObject);
begin
  DaySG.SaveOptions := [soDesign, soContent];
  DayValues.SaveOptions := [soContent];
  TotalChartDataSG.SaveOptions := [soDesign, soContent];
  LoadDayStatics(Date, true);
  LoadTotalStatics();
end;

procedure TStaticsForm.PCChange(Sender: TObject);
begin
  case PC.TabIndex of
  0: DayDrawChartsBtnClick(sender);
  end;
end;

procedure TStaticsForm.DayCalDayChanged(Sender: TObject);
begin
  LoadDayStatics(DayCal.DateTime, true);
end;

procedure TStaticsForm.DayDrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
  DaySoldChSeries.Clear ;
  DayRevChSeries.Clear ;
  for i:=1 to DaySG.RowCount - 1 do
  begin
    DaySoldChSeries.AddXY(0, StrToInt(DaySG.Cells[3, i]), DaySG.Cells[2, i]);
    DayRevChSeries.AddXY(0, CurrToFloat(DaySG.Cells[4, i]), DaySG.Cells[2, i]);
  end;
end;

end.

