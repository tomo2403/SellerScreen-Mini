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
    PageControl1: TPageControl;
    DaySheet: TTabSheet;
    MonthSheet: TTabSheet;
    DaySG: TStringGrid;
    RandomChartSource1: TRandomChartSource;
    DayValues: TStringGrid;
    YearSheet: TTabSheet;
    TotalSheet: TTabSheet;
    procedure DayCalDayChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveDayStatics(date : TDateTime);
    procedure LoadDayStatics(date : TDateTime);
    procedure DayLoadBtnClick(Sender: TObject);
    procedure YearSheetContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private

  public

  end;

var
  StaticsForm: TStaticsForm;

implementation

{$R *.lfm}

{ TStaticsForm }

procedure TStaticsForm.SaveDayStatics(date : TDateTime);
var
  fileName : string;
begin
  DateTimeToString(fileName, 'yyyymmdd"0.xml"', date);
  DaySG.SaveToFile(fileName);
  DateTimeToString(fileName, 'yyyymmdd"1.xml"', date);
  DayValues.SaveToFile(fileName);
end;

procedure TStaticsForm.LoadDayStatics(date : TDateTime);
var
  fileName : string;
begin
  DateTimeToString(fileName, 'yyyymmdd"0.xml"', date);
  if FileExists(fileName) then
  begin
    Day404Lbl.Visible := false;
    DaySG.LoadFromFile(fileName);
    DaySG.Refresh;
    try
      DateTimeToString(fileName, 'yyyymmdd"1.xml"', date);
      DayValues.LoadFromFile(fileName);
      DayValues.Refresh;
    except
      Application.MessageBox('Die Zusammenfassung des Tages konnte nicht geladen werden!', 'Tagesstatistiken', MB_ICONERROR + MB_OK);
    end;
  end
  else Day404Lbl.Visible := true;
end;

procedure TStaticsForm.FormCreate(Sender: TObject);
begin
  DaySG.SaveOptions := [soDesign, soContent];
  DayValues.SaveOptions := [soContent];
end;

procedure TStaticsForm.DayCalDayChanged(Sender: TObject);
begin
  LoadDayStatics(DayCal.DateTime);
end;

procedure TStaticsForm.YearSheetContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TStaticsForm.DayLoadBtnClick(Sender: TObject);
begin
  LoadDayStatics(DayCal.DateTime);
end;

end.

