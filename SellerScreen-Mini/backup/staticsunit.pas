unit StaticsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  EditBtn, Calendar, ExtCtrls, Grids, SynHighlighterXML, TAGraph,
  TASeries, TADbSource, TAIntervalSources, TASources, LCLType, Buttons, Types;

type

  { TStaticsForm }

  TStaticsForm = class(TForm)
    Chart1BarSeries2: TBarSeries;
    Chart1BarSeries3: TBarSeries;
    Chart1BarSeries4: TBarSeries;
    Chart1BarSeries5: TBarSeries;
    Chart1BarSeries6: TBarSeries;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    FlowPanel10: TFlowPanel;
    FlowPanel11: TFlowPanel;
    FlowPanel12: TFlowPanel;
    FlowPanel13: TFlowPanel;
    FlowPanel14: TFlowPanel;
    FlowPanel15: TFlowPanel;
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
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label49: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    RandomChartSource2: TRandomChartSource;
    RandomChartSource3: TRandomChartSource;
    RandomChartSource4: TRandomChartSource;
    RandomChartSource5: TRandomChartSource;
    ScrollBox5: TScrollBox;
    ScrollBox6: TScrollBox;
    ScrollBox7: TScrollBox;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    StringGrid8: TStringGrid;
    YearRevenueChart1: TChart;
    YearSoldChart: TChart;
    DrawChartsBtn: TButton;
    DaySoldChart: TChart;
    DayRevenueChart: TChart;
    DayCPS1: TPieSeries;
    DayCal: TCalendar;
    DayCalendar: TCalendar;
    Day404Lbl: TLabel;
    DayCPS2: TPieSeries;
    FlowPanel1: TFlowPanel;
    FlowPanel2: TFlowPanel;
    FlowPanel3: TFlowPanel;
    FlowPanel4: TFlowPanel;
    FlowPanel5: TFlowPanel;
    FlowPanel6: TFlowPanel;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    PC: TPageControl;
    DaySheet: TTabSheet;
    MonthSheet: TTabSheet;
    DaySG: TStringGrid;
    DayValues: TStringGrid;
    RandomChartSource1: TRandomChartSource;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;
    ScrollBox4: TScrollBox;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TotalSheet: TTabSheet;
    YearSheet: TTabSheet;
    YearRevenueChart: TChart;
    YearSoldChart1: TChart;
    YearSoldChart2: TChart;
    procedure DayCalDayChanged(Sender: TObject);
    procedure DrawChartsBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveDayStatics(d : TDateTime);
    procedure LoadTotalStatics(charts : boolean = false);
    function LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
    procedure ScrollBox2Click(Sender: TObject);
  private

  public
    loadedToday: boolean;
  end;

  TotalStatics = record
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
  tStatics : TotalStatics;
  tSFile : File of TotalStatics;

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

    if charts then DrawChartsBtnClick(DrawChartsBtn);

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

procedure TStaticsForm.ScrollBox2Click(Sender: TObject);
begin

end;

procedure TStaticsForm.LoadTotalStatics(charts : boolean = false);
begin
  AssignFile(tSFile, 'total');
  Reset(tSFile);
  while not EOF(tSFile) do
  begin
    Read(tSFile, tStatics);
  end;
  CloseFile(tSFile);
end;
procedure TStaticsForm.FormCreate(Sender: TObject);
begin
  DaySG.SaveOptions := [soDesign, soContent];
  DayValues.SaveOptions := [soContent];
  LoadDayStatics(Date, true);
end;

procedure TStaticsForm.DayCalDayChanged(Sender: TObject);
begin
  LoadDayStatics(DayCal.DateTime, true);
end;

procedure TStaticsForm.DrawChartsBtnClick(Sender: TObject);
var
  i : integer;
begin
      DayCPS1.Clear ;
      DayCPS2.Clear ;
      for i:=1 to DaySG.RowCount - 1 do
      begin
        DayCPS1.AddXY(0, StrToInt(DaySG.Cells[3, i]), DaySG.Cells[2, i]);
        DayCPS2.AddXY(0, CurrToFloat(DaySG.Cells[4, i]), DaySG.Cells[2, i]);
      end;
end;

end.

