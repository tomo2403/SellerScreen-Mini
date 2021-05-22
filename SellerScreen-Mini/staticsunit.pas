unit StaticsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  EditBtn, Calendar, ExtCtrls, Grids, SynHighlighterXML, TAGraph,
  TASeries, TADbSource, LCLType, Types;

type

  { TStaticsForm }

  TStaticsForm = class(TForm)
    DaySoldChart: TChart;
    DayRevenueChart: TChart;
    DayCPS1: TPieSeries;
    DayCal: TCalendar;
    DayCalendar: TCalendar;
    Day404Lbl: TLabel;
    DayCPS2: TPieSeries;
    FlowPanel1: TFlowPanel;
    PC: TPageControl;
    DaySheet: TTabSheet;
    MonthSheet: TTabSheet;
    DaySG: TStringGrid;
    DayValues: TStringGrid;
    ScrollBox1: TScrollBox;
    YearSheet: TTabSheet;
    TotalSheet: TTabSheet;
    procedure DayCalDayChanged(Sender: TObject);
    procedure DaySheetContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SaveDayStatics(d : TDateTime);
    function LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
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
  DateTimeToString(fileName, 'yyyymmdd"0.xml"', d);
  DaySG.SaveToFile(fileName);
  DateTimeToString(fileName, 'yyyymmdd"1.xml"', d);
  DayValues.SaveToFile(fileName);
end;

function TStaticsForm.LoadDayStatics(d : TDateTime; charts : boolean = false) : boolean;
var
  fileName : string;
  i : integer;
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

    if charts then
    begin
      DayCPS1.Clear ;
      DayCPS2.Clear ;
      for i:=1 to DaySG.RowCount - 1 do
      begin
        DayCPS1.AddXY(0, StrToInt(DaySG.Cells[3, i]), DaySG.Cells[2, i]);
        DayCPS2.AddXY(0, CurrToFloat(DaySG.Cells[4, i]), DaySG.Cells[2, i]);
      end;
    end;

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

procedure TStaticsForm.DaySheetContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

