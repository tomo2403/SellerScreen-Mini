unit StaticsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  EditBtn, Calendar, ExtCtrls, Grids, ValEdit, SynHighlighterXML, TAGraph,
  TASources, TASeries, TALegendPanel, Types, LCLType;

type

  { TStaticsForm }

  TStaticsForm = class(TForm)
    Chart1: TChart;
    DayCPS: TPieSeries;
    DayCal: TCalendar;
    DayLoadBtn: TButton;
    DayCalendar: TCalendar;
    Day404Lbl: TLabel;
    PC: TPageControl;
    DaySheet: TTabSheet;
    MonthSheet: TTabSheet;
    DaySG: TStringGrid;
    RandomChartSource1: TRandomChartSource;
    DayValues: TStringGrid;
    YearSheet: TTabSheet;
    TotalSheet: TTabSheet;
    procedure DayCalDayChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveDayStatics(d : TDateTime);
    procedure LoadDayStatics(d : TDateTime);
    procedure DayLoadBtnClick(Sender: TObject);
  private

  public
    loadedToday: boolean;
  end;

var
  StaticsForm: TStaticsForm;
  loadedToday: boolean = false;

implementation

{$R *.lfm}

{ TStaticsForm }

procedure TStaticsForm.SaveDayStatics(d : TDateTime);
var
  fileName : string;
begin
  DateTimeToString(fileName, 'yyyymmdd"0.xml"', d);
  DaySG.SaveToFile(fileName);
  DateTimeToString(fileName, 'yyyymmdd"1.xml"', d);
  DayValues.SaveToFile(fileName);
end;

procedure TStaticsForm.LoadDayStatics(d : TDateTime);
var
  fileName : string;
begin
  DateTimeToString(fileName, 'yyyymmdd"0.xml"', d);
  if FileExists(fileName) then
  begin
    Day404Lbl.Visible := false;
    DaySG.Clear();
    DaySG.LoadFromFile(fileName);
    DaySG.Refresh;
    try
      DateTimeToString(fileName, 'yyyymmdd"1.xml"', d);
      DayValues.LoadFromFile(fileName);
      DayValues.Refresh;
    except
      Application.MessageBox('Die Zusammenfassung des Tages konnte nicht geladen werden!', 'Tagesstatistiken', MB_ICONERROR + MB_OK);
    end;
    if d = Date then loadedToday := true
    else loadedToday := false;
  end
  else Day404Lbl.Visible := true;
end;

procedure TStaticsForm.FormCreate(Sender: TObject);
begin
  DaySG.SaveOptions := [soDesign, soContent];
  DayValues.SaveOptions := [soContent];
  LoadDayStatics(Date);
end;

procedure TStaticsForm.DayCalDayChanged(Sender: TObject);
begin
  LoadDayStatics(DayCal.DateTime);
end;

procedure TStaticsForm.DayLoadBtnClick(Sender: TObject);
begin
  LoadDayStatics(DayCal.DateTime);
end;

end.

