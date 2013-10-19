object FrmWrkDur: TFrmWrkDur
  Left = 192
  Top = 129
  AutoScroll = False
  Caption = 'FrmWrkDur'
  ClientHeight = 332
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Ch: TChart
    Left = 0
    Top = 0
    Width = 534
    Height = 332
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BottomAxis.ExactDateTime = False
    BottomAxis.LabelStyle = talMark
    LeftAxis.LabelStyle = talValue
    Legend.Visible = False
    TopAxis.Visible = False
    View3D = False
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Series1: TBarSeries
      Marks.ArrowLength = 20
      Marks.Visible = True
      SeriesColor = clRed
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
  end
end
