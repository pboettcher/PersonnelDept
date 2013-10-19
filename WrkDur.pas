unit WrkDur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ExtCtrls, TeeProcs, TeEngine, Chart, Series, TeeFunci,
  DbChart, ADODB;

type
  TFrmWrkDur = class(TForm)
    Ch: TChart;
    Series1: TBarSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDS:TDataSet;
    FBS:TBarSeries;
    procedure SetDS(DS:TDataSet);
  public
    property DataSet:TDataSet read FDS write SetDS;
  end;

var
  FrmWrkDur: TFrmWrkDur;

procedure DisplayWDStat(Stat:TDataSet);

implementation

{$R *.dfm}

procedure DisplayWDStat(Stat:TDataSet);
var Frm:TFrmWrkDur;
begin
  if Stat=nil then Exit;
  if Stat.FieldDefs.IndexOf('EmpCnt')<0 then Exit;
  if Stat.FieldDefs.IndexOf('WrkDur')<0 then Exit;
  if Stat.Eof then Exit;
  Frm:=TFrmWrkDur.Create(Application);
  Frm.DataSet:=Stat;
  Frm.ShowModal;
  Frm.Release;
end;

procedure TFrmWrkDur.SetDS(DS:TDataSet);
begin
  with Ch do begin
    Legend.Visible:=False;
    TopAxis.Visible:=False;
    Title.Visible:=False;
    View3D:=False;
    BottomAxis.LabelStyle:=talValue;
  end;
  FDS:=DS;
  with FBS do begin
    ParentChart:=Ch;
    ColorEachPoint:=True;
    Marks.ArrowLength:=20;
    Marks.Visible:= True;
    SeriesColor:= clGreen;
    BarBrush.Color:=clWhite;
    BarWidthPercent:=100;
    SideMargins:=False;
    XValues.DateTime:= False;
    XValues.Name:= 'Продолжительность';
    XValues.Multiplier:= 1;
    XValues.Order:= loAscending;
    YValues.DateTime:= False;
    YValues.Name:= 'Сотрудников';
    YValues.Multiplier:= 1;
    YValues.Order:= loNone;
  end;
{  FBS.Marks
  TSeriesMarks}
  FDS.First;
  while not FDS.Eof do begin
    FBS.AddBar(FDS['EmpCnt'],FDS['WrkDur'],clDefault);
    FDS.Next;
  end;
end;

procedure TFrmWrkDur.FormCreate(Sender: TObject);
begin
  FBS:=TBarSeries.Create(Self);
end;

procedure TFrmWrkDur.FormDestroy(Sender: TObject);
begin
  FBS.Free;
end;

end.

