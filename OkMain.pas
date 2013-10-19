unit OkMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, Grids, DBGrids, DBTables, ExtCtrls, Jpeg, PngImage, ToolWin,
  ComCtrls, Menus, StdCtrls, ImgList, WrkDur, Variants, Buttons, Clipbrd,
  DptList, TntDBGrids, CustomGrids;

type
  TQueryRec=record
    FIO:string;
    Fired:boolean;
    Working:boolean;
    Men:boolean;
    Women:boolean;
    Married:boolean;
    Unmarried:boolean;
    Children:boolean;
    NoChildren:boolean;
    YearsOld:integer;
    StartDate:TDateTime;
    EndDate:TDateTime;
  end;

  TUnicodeClipboard=class(TClipboard)
  private
    function GetAsWideText:WideString;
    procedure SetAsWideText(const Value:WideString);
  public
    property AsWideText:WideString read GetAsWideText write SetAsWideText;
  end;
  
  TForm1 = class(TForm)
    Conn: TADOConnection;
    DS: TDataSource;
    AQ: TADOQuery;
    Splitter1: TSplitter;
    pnBottom: TPanel;
    SG: TStringGrid;
    pnLeft: TPanel;
    pnPhoto: TPanel;
    Img: TImage;
    tvDept:TTreeView;
    aqDepts: TADOQuery;
    slDept: TSplitter;
    dsDepStaff: TDataSource;
    aqStaff: TADOQuery;
    dgStaff: TAutoSizeDBGrid;
    MainMenu1: TMainMenu;
    miFilt: TMenuItem;
    miFiltAll: TMenuItem;
    miFiltNew1month: TMenuItem;
    miFiltFired1m: TMenuItem;
    miFiltNew2months: TMenuItem;
    miFiltFired2m: TMenuItem;
    miFiltMen: TMenuItem;
    miFiltWomen: TMenuItem;
    miFiltWorking: TMenuItem;
    miFiltFired: TMenuItem;
    miFiltMarried: TMenuItem;
    miFiltUnmarried: TMenuItem;
    miFiltChildren: TMenuItem;
    miFiltNoChildren: TMenuItem;
    ilMenu: TImageList;
    tmDelayQuery: TTimer;
    miStat: TMenuItem;
    miWrkDur: TMenuItem;
    pmDetails: TPopupMenu;
    piCopyLine: TMenuItem;
    piCopyData: TMenuItem;
    piCopyHeadedData: TMenuItem;
    miExport: TMenuItem;
    pcList: TPageControl;
    tsStaff: TTabSheet;
    tsDepts: TTabSheet;
    DG: TAutoSizeDBGrid;
    ToolBar1: TToolBar;
    tbFiltMen: TToolButton;
    tbFiltWomen: TToolButton;
    ToolButton1: TToolButton;
    tbFiltWorking: TToolButton;
    tbFiltFired: TToolButton;
    ToolButton2: TToolButton;
    tbFiltMarried: TToolButton;
    tbFiltUnmarried: TToolButton;
    ToolButton3: TToolButton;
    tbFiltChildren: TToolButton;
    tbFiltNoChildren: TToolButton;
    ToolButton4: TToolButton;
    edFIO: TEdit;
    sbSearch: TSpeedButton;
    tmDelayDStaff: TTimer;
    spRequest: TADOStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miFiltAllClick(Sender: TObject);
    procedure miFiltNew1monthClick(Sender: TObject);
    procedure miFiltNew2monthsClick(Sender: TObject);
    procedure miFiltFired1mClick(Sender: TObject);
    procedure miFiltFired2mClick(Sender: TObject);
    procedure cbShowPhotoClick(Sender: TObject);
    procedure miFiltClick(Sender: TObject);
    procedure tbFiltClick(Sender: TObject);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure tmDelayQueryTimer(Sender: TObject);
    procedure DSDataChange(Sender: TObject; Field: TField);
    procedure miWrkDurClick(Sender: TObject);
    procedure edFIOChange(Sender: TObject);
    procedure sbSearchClick(Sender: TObject);
    procedure SGMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure piDetailCopyClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure tvDeptChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure aqStaffAfterScroll(DataSet: TDataSet);
    procedure tmDelayDStaffTimer(Sender: TObject);
    procedure pcListChange(Sender: TObject);
  private
    FRec:TQueryRec;
    FShowPhoto:boolean;
    FCurrIsFired:boolean;
    FDetailsRow:integer;
    FDeptList:TDeptList;
    procedure Req(const Query:string);
    procedure Request;
    procedure ChkMenu(Sender:TObject);
    function ToggleMenu(MI:TObject):boolean;
    procedure LoadDeptInfo(ID:LongInt);
    procedure UpdateDepts;
    procedure ClearDepBranch(Node:TTreeNode);
    procedure ClearDeptsTree;
    procedure LoadDeptTree;
    procedure LoadDeptNodes(Node:TTreeNode);
    procedure DisplayEmployee(ID:LongInt);
    procedure ClearUserInfo;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var Clip:TUnicodeClipboard;

procedure TForm1.Req(const Query:string);
var i:integer;
begin
  DG.DataSource:=nil;
  DG.Color:=clBtnFace;
  for i:=0 to SG.RowCount-1 do SG.Cells[1,i]:='';
  SG.Color:=clBtnFace;
  Img.Canvas.Brush.Style:=bsSolid;
  Img.Canvas.Brush.Color:=pnPhoto.Color;
  Img.Canvas.FillRect(Img.ClientRect);
  Img.Picture.Graphic.Width:=Screen.Width;
  Img.Picture.Graphic.Height:=Screen.Height;
  Img.Invalidate;
  Img.Visible:=FShowPhoto;
  Screen.Cursor:=crHourglass;
  Application.ProcessMessages;
  AQ.Close;
  AQ.SQL.Clear;
  AQ.SQL.Add(Query);
  AQ.Open;
  DG.DataSource:=DS;
  DG.Color:=clWindow;
  SG.Color:=clWindow;
  Screen.Cursor:=crDefault;
end;

procedure WriteStrToFile(FName,Strg:string);
var f:TextFile;
begin
  AssignFile(f,FName);
  {$I-}
  Rewrite(f);
  {$I+}
  if IOResult<>0 then Exit;
  Writeln(f,Strg);
  {$I-}
  CloseFile(f);
  {$I+}
end;

function DoubleSwitch(TrueSwitch, FalseSwitch:boolean):OleVariant;
begin
  if (TrueSwitch=FalseSwitch) then Result:=null else Result:=TrueSwitch;
end;

procedure TForm1.Request;
begin
  miFiltWorking.Checked:=FRec.Working;
  tbFiltWorking.Down:=FRec.Working;
  miFiltFired.Checked:=FRec.Fired;
  tbFiltFired.Down:=FRec.Fired;
  miFiltMen.Checked:=FRec.Men;
  tbFiltMen.Down:=FRec.Men;
  miFiltWomen.Checked:=FRec.Women;
  tbFiltWomen.Down:=FRec.Women;
  miFiltMarried.Checked:=FRec.Married;
  tbFiltMarried.Down:=FRec.Married;
  miFiltUnmarried.Checked:=FRec.Unmarried;
  tbFiltUnmarried.Down:=FRec.Unmarried;
  miFiltChildren.Checked:=FRec.Children;
  tbFiltChildren.Down:=FRec.Children;
  miFiltNoChildren.Checked:=FRec.NoChildren;
  tbFiltNoChildren.Down:=FRec.NoChildren;
  try
    spRequest.Close;
    with spRequest.Parameters do begin
      ParamValues['@Fired']:=DoubleSwitch(FRec.Fired, FRec.Working);
      ParamValues['@Women']:=DoubleSwitch(FRec.Women, FRec.Men);
      ParamValues['@Married']:=DoubleSwitch(FRec.Married, FRec.Unmarried);
      ParamValues['@Children']:=DoubleSwitch(FRec.Children, FRec.NoChildren);
      ParamValues['@FIO']:=edFIO.Text;
    end;
    spRequest.Open;
    DS.DataSet:=spRequest;
    DG.DataSource:=DS;
  finally
  end;
end;

procedure TForm1.ChkMenu(Sender:TObject);
var i:integer;
begin
  for i:=0 to miFilt.Count-1 do
    miFilt.Items[i].Checked:=False;
  if Sender is TMenuItem then TMenuItem(Sender).Checked:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FShowPhoto:=False;
  FDeptList:=TDeptList.Create;
end;

function SF(DS:TDataSet; FName:string):string;
var Fld:TField;
begin
  Result:='';
  Fld:=DS.FieldByName(FName);
  if Fld<>nil then Result:=DS.FieldByName(FName).AsString;
end;

procedure TForm1.DSDataChange(Sender: TObject; Field: TField);
begin
  tmDelayQuery.Enabled:=False;
  Application.ProcessMessages;
  tmDelayQuery.Enabled:=True;
end;

procedure TForm1.DisplayEmployee(ID:LongInt);
var PF:TBlobField;
    BS:TADOBlobStream;
    JP:TJpegImage;
    PNG:TPngObject;
    Age,s:string;
    D:TADOQuery;
begin
  D:=TADOQuery.Create(Self);
  D.Connection:=Conn;
  D.SQL.Clear;
  D.SQL.Add('GetEmployee '+IntToStr(ID));
  D.Open;
  if not D.Eof then begin
  PF:=TBLOBField(D.FieldByName('Photo'));
  Img.Visible:=FShowPhoto;
  if PF.IsNull then begin
    Img.Canvas.Brush.Style:=bsSolid;
    Img.Canvas.Brush.Color:=pnPhoto.Color;
    Img.Canvas.FillRect(Img.BoundsRect);
  end
  else begin
    //PF.SaveToFile('pict');
    BS:=TADOBlobStream.Create(PF,bmRead);
    try
      PNG:=TPngObject.Create;
      PNG.LoadFromStream(BS);
      pnPhoto.ClientWidth:=PNG.Width+2;
      pnPhoto.ClientHeight:=PNG.Height+2;
      Img.SetBounds(1,1,PNG.Width,PNG.Height);
      Img.Canvas.Draw(0,0,PNG);
      pnLeft.ClientWidth:=PNG.Width+15;
      PNG.Free;
    except
      BS.Seek(0,soFromBeginning);
      JP:=TJpegImage.Create;
      JP.LoadFromStream(BS);
      pnPhoto.ClientWidth:=JP.Width+2;
      pnPhoto.ClientHeight:=JP.Height+2;
      Img.SetBounds(1,1,JP.Width,JP.Height);
      Img.Canvas.Draw(0,0,JP);
      pnLeft.ClientWidth:=JP.Width+15;
      JP.Free;
    end;
    BS.Free;
  end;
  SG.Cells[1,0]:=SF(D,'FIO');
  if D.FieldByName('BirthDate').IsNull then SG.Cells[1,1]:='' else begin
    Age:=IntToStr(Trunc((Now-D.FieldByName('BirthDate').AsDateTime)/365.25));
    SG.Cells[1,1]:=SF(D,'BirthDate')+' ('+Age+')';
  end;
  SG.Cells[1,2]:=SF(D,'Sex');
  SG.Cells[1,3]:=SF(D,'Category');
  SG.Cells[1,4]:=SF(D,'dpt_name');
  SG.Cells[1,5]:=SF(D,'post');
  SG.Cells[1,6]:=SF(D,'ext');
  SG.Cells[1,7]:=SF(D,'org_name');
  s:=' - '+SF(D,'EndDate');
  FCurrIsFired:=(s<>' - ');
  if not FCurrIsFired then s:='';
  SG.Cells[1,8]:=SF(D,'StartDate')+s;
  SG.Cells[1,9]:=SF(D,'RegistrationCity');
  SG.Cells[1,10]:=SF(D,'RegistrationAddress');
  SG.Cells[1,11]:=SF(D,'RegistrationArea');
  SG.Cells[1,12]:=SF(D,'PhoneNumber');
  SG.Cells[1,13]:=SF(D,'Mate');
  SG.Cells[1,14]:=SF(D,'Children');
  end;
  D.Free;
end;

procedure TForm1.tmDelayQueryTimer(Sender: TObject);
begin
  tmDelayQuery.Enabled:=False;
  DisplayEmployee(DS.DataSet['id']);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  SG.RowCount:=15;
  SG.ColWidths[1]:=500;
  SG.Cells[0,0]:='Ф.И.О.';
  SG.Cells[0,1]:='Дата рождения';
  SG.Cells[0,2]:='Пол';
  SG.Cells[0,3]:='Категория';
  SG.Cells[0,4]:='Отдел';
  SG.Cells[0,5]:='Должность';
  SG.Cells[0,6]:='Местн. тел.';
  SG.Cells[0,7]:='Организация';
  SG.Cells[0,8]:='Период работы';
  SG.Cells[0,9]:='Город';
  SG.Cells[0,10]:='Адрес';
  SG.Cells[0,11]:='Район';
  SG.Cells[0,12]:='Телефон';
  SG.Cells[0,13]:='Супруг(а)';
  SG.Cells[0,14]:='Дети';
  miFiltAllClick(Self);
  UpdateDepts;
  pcList.ActivePageIndex:=0;
end;

procedure TForm1.cbShowPhotoClick(Sender: TObject);
begin
  FShowPhoto:=not FShowPhoto;
  Img.Visible:=FShowPhoto;
end;

procedure TForm1.miFiltAllClick(Sender: TObject);
begin
  FRec.Fired:=True;
  FRec.Working:=True;
  FRec.Men:=True;
  FRec.Women:=True;
  FRec.Married:=True;
  FRec.Unmarried:=True;
  FRec.Children:=True;
  FRec.NoChildren:=True;
  FRec.YearsOld:=0;
  FRec.StartDate:=0;
  FRec.EndDate:=0;
  Request;
end;

procedure TForm1.miFiltNew1monthClick(Sender: TObject);
begin
  ChkMenu(Sender);
  Req('QueryNew1m');
end;

procedure TForm1.miFiltNew2monthsClick(Sender: TObject);
begin
  ChkMenu(Sender);
  Req('QueryNew2m');
end;

procedure TForm1.miFiltFired1mClick(Sender: TObject);
begin
  ChkMenu(Sender);
  Req('QueryFir1m');
end;

procedure TForm1.miFiltFired2mClick(Sender: TObject);
begin
  ChkMenu(Sender);
  Req('QueryFir2m');
end;

function TForm1.ToggleMenu(MI:TObject):boolean;
begin
  Result:=False;
  if MI is TMenuItem then begin
    TMenuItem(MI).Checked:=not TMenuItem(MI).Checked;
    Result:=TMenuItem(MI).Checked;
  end;
end;

procedure TForm1.miFiltClick(Sender: TObject);
begin
  if not(Sender is TMenuItem) then Exit;
  if Sender=miFiltMen then FRec.Men:=not FRec.Men;
  if Sender=miFiltWomen then FRec.Women:=not FRec.Women;
  if Sender=miFiltWorking then FRec.Working:=not FRec.Working;
  if Sender=miFiltFired then FRec.Fired:=not FRec.Fired;
  if Sender=miFiltMarried then FRec.Married:=not FRec.Married;
  if Sender=miFiltUnmarried then FRec.Unmarried:=not FRec.Unmarried;
  if Sender=miFiltChildren then FRec.Children:=not FRec.Children;
  if Sender=miFiltNoChildren then FRec.NoChildren:=not FRec.NoChildren;
  Request;
end;

procedure TForm1.tbFiltClick(Sender: TObject);
begin
  if not(Sender is TToolButton) then Exit;
  if Sender=tbFiltMen then FRec.Men:=not FRec.Men;
  if Sender=tbFiltWomen then FRec.Women:=not FRec.Women;
  if Sender=tbFiltWorking then FRec.Working:=not FRec.Working;
  if Sender=tbFiltFired then FRec.Fired:=not FRec.Fired;
  if Sender=tbFiltMarried then FRec.Married:=not FRec.Married;
  if Sender=tbFiltUnmarried then FRec.Unmarried:=not FRec.Unmarried;
  if Sender=tbFiltChildren then FRec.Children:=not FRec.Children;
  if Sender=tbFiltNoChildren then FRec.NoChildren:=not FRec.NoChildren;
  Request;
end;

procedure TForm1.SGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const PeriodRow=8;
var Txt:string;
begin
  if FCurrIsFired and(ACol=1)and(ARow=PeriodRow) then begin
    SG.Canvas.Brush.Color:=$00A0FF;
    SG.Canvas.FillRect(Rect);
    Txt:=SG.Cells[1,PeriodRow];
    Inc(Rect.Top,2);
    Inc(Rect.Left,2);
    DrawText(SG.Canvas.Handle,PChar(Txt),-1,Rect,DT_LEFT or DT_VCENTER);
  end;
end;

procedure TForm1.miWrkDurClick(Sender: TObject);
var SQ:TADOQuery;
begin
  SQ:=TADOQuery.Create(Self);
  try
    SQ.Connection:=Conn;
    SQ.Close;
    SQ.SQL.Clear;
    SQ.SQL.Add('declare @CorrWidth int');
    SQ.SQL.Add('set @CorrWidth=365');
    SQ.SQL.Add('select EmpCnt=count([id]),WrkDur=((cast(EndDate as int)-cast(StartDate as int))/@CorrWidth)*@CorrWidth');
    SQ.SQL.Add('from employers');
    SQ.SQL.Add('where (dismissed=1)and(cast(EndDate as int)-cast(StartDate as int))>0 and BirthDate<StartDate');
    SQ.SQL.Add('group by ((cast(EndDate as int)-cast(StartDate as int))/@CorrWidth)*@CorrWidth');
    SQ.Open;
    DisplayWDStat(SQ);
  finally
    SQ.Free;
  end;
end;

procedure TForm1.edFIOChange(Sender: TObject);
begin
  FRec.FIO:=edFIO.Text;
end;

procedure TForm1.sbSearchClick(Sender: TObject);
begin
  Request;
end;

procedure TForm1.SGMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var SP:TPoint;
    Col:integer;
begin
  if Button=mbRight then begin
    SP:=SG.ClientToScreen(Point(X,Y));
    SG.MouseToCell(X,Y,Col,FDetailsRow);
    PMDetails.Popup(SP.X,SP.Y);
  end;
end;

procedure TForm1.piDetailCopyClick(Sender: TObject);
var Txt:WideString;
    i:integer; 
begin
  if Sender=piCopyLine then Clip.AsWideText:=SG.Cells[1,FDetailsRow];
  if Sender=piCopyData then begin
    Txt:='';
    for i:=0 to SG.RowCount-1 do Txt:=Txt+SG.Cells[1,i]+#13#10;
    Clip.AsWideText:=Txt;
  end;
  if Sender=piCopyHeadedData then begin
    Txt:='';
    for i:=0 to SG.RowCount-1 do Txt:=Txt+SG.Cells[0,i]+#9+SG.Cells[1,i]+#13#10;
    Clip.AsWideText:=Txt;
  end;
end;

function TUnicodeClipboard.GetAsWideText:WideString;
var Data:THandle;
begin
  Open;
  Data:=GetClipboardData(CF_UNICODETEXT);
  try
    if Data<>0 then Result:=PWideChar(GlobalLock(Data)) else Result:='';
  finally
    if Data<>0 then GlobalUnlock(Data);
    Close;
  end;
end;

procedure TUnicodeClipboard.SetAsWideText(const Value:WideString);
begin
  SetBuffer(CF_UNICODETEXT, PWideChar(Value)^, (Length(Value)+1)*2);
end;

procedure TForm1.miExportClick(Sender: TObject);
var SD:TSaveDialog;
    FN:string;
    QT:string;
    Q:TAdoQuery;
    hFile:LongWord;
    //i:integer;
begin
  SD:=TSaveDialog.Create(Self);
  SD.FileName:='';
  SD.Filter:='Текст (*.txt)|*.txt';
  SD.DefaultExt:='txt';
  if SD.Execute then FN:=SD.FileName else FN:='';
  SD.Free;
  if FN='' then Exit;
  hFile:=FileCreate(FN);
  if LongInt(hFile)=-1 then Exit;
  QT:='select Line='+
    'rtrim(e.LastName)+char(9)+'+
    'rtrim(e.FirstName)+char(9)+'+
    'rtrim(e.MiddleName)+char(9)+'+
    'convert(varchar,e.BirthDate,104)+char(9)+'+
    'e.Sex+char(9)+'+
    'rtrim(c.Category)+char(9)+'+
    'convert(varchar,e.StartDate,104)+char(9)+'+
    'IsNull(convert(varchar,e.EndDate,104),'''')+char(9)+'+
    'rtrim(o.Org_Name)+char(9)+'+
    'rtrim(d.dpt_name)+char(9)+'+
    'rtrim(p.post)+char(9)+'+
    'rtrim(e.RegistrationCity)+char(9)+'+
    'rtrim(e.RegistrationAddress)+char(9)+'+
    'rtrim(e.RegistrationArea)+char(9)+'+
    'rtrim(e.RegistrationZipCode)+char(9)+'+
    'rtrim(e.PhoneNumber)+char(9)+'+
    'cast(x.Ext as varchar)+char(9)+'+
    'rtrim(e.Login)+char(9)+'+
    'rtrim(e.Email)+char(9)+'+
    'case when e.Dismissed=1 then ''Уволен'' else '''' end+char(9)+'+
    'rtrim(e.PassportSerNum)+char(9)+'+
    'rtrim(e.PassportNumber)+char(9)+'+
    'rtrim(e.PassportGiven)+char(9)+'+
    'convert(varchar,e.PassportGivenDate,104)+char(9)+'+
    'case when e.Married=0 then ''нет'' when e.Married=1 then e.MarriedOn else '''' end+char(9)+'+
    'rtrim(e.Children) '+
    'from employers e '+
    'left join emp_categories c on c.[id]=e.CategoryID '+
    'left join organizations o on o.org_id=e.Organization '+
    'left join departments d on d.dpt_id=e.Department '+
    'left join posts p on p.post_id=e.PositionID '+
    'left join ext x on x.[id]=e.Ext '+
    'order by e.LastName,e.FirstName,e.MiddleName';
  Q:=TAdoQuery.Create(Self);
  Q.Connection:=Conn;
  Q.Close;
  Q.SQL.Clear;
  Q.SQL.Add(QT);
  Screen.Cursor:=crHourglass;
  Application.ProcessMessages;
  Q.Open;
  FN:='LastName'#9'FirstName'#9'MiddleName'#9'BirthDate'#9'Sex'#9+
  'Category'#9'StartDate'#9'EndDate'#9'Org_Name'#9'dpt_name'#9'post'#9+
  'RegistrationCity'#9'RegistrationAddress'#9'RegistrationArea'#9+
  'RegistrationZipCode'#9'PhoneNumber'#9'Ext'#9+
  'Login'#9'Email'#9'Dismissed'#9'PassportSerNum'#9'PassportNumber'#9+
  'PassportGiven'#9'PassportGivenDate'#9'Mate'#9+
  'Children'#13#10;
  FileWrite(hFile,PChar(FN)^,Length(FN));
  while not Q.Eof do begin
    if Q.FieldByName('Line')<>nil then begin
      FN:=Q.FieldByName('Line').AsString+#13#10;
      FileWrite(hFile,PChar(FN)^,Length(FN));
    end;
    Q.Next;
  end;
  Screen.Cursor:=crDefault;
  FileClose(hFile);
  {$I+}
end;

procedure TForm1.LoadDeptInfo(ID:LongInt);
begin
  try
    aqStaff.Close;
    aqStaff.Connection:=Conn;
    aqStaff.SQL.Clear;
    aqStaff.SQL.Add('select ID=cast(ID as int),FIO=ltrim(rtrim(em.LastName))+'' ''+ltrim(rtrim(em.FirstName))+'' ''+ltrim(rtrim(em.MiddleName)),');
    aqStaff.SQL.Add('Pos=IsNull(ps.Post,''''), Org=IsNull(org.org_name,'''')');
    aqStaff.SQL.Add('from employers em');
    aqStaff.SQL.Add('left join posts ps on ps.Post_ID=em.PositionID');
    aqStaff.SQL.Add('left join organizations org on org.org_id=em.organization');
    aqStaff.SQL.Add('where em.department='+IntToStr(ID)+' and em.dismissed=0');
    aqStaff.SQL.Add('order by em.LastName,em.FirstName,em.MiddleName');
    aqStaff.Open;
    if aqStaff.RecordCount=0 then ClearUserInfo;
  finally
  end;
end;

procedure TForm1.tvDeptChange(Sender: TObject; Node: TTreeNode);
var DID:LongInt;
begin
  DID:=PLongInt(tvDept.Selected.Data)^;
  LoadDeptInfo(DID);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FDeptList.Free;
end;

procedure TForm1.ClearDepBranch(Node:TTreeNode);
var i:integer;
begin
  for i:=0 to Node.Count-1 do begin
    ClearDepBranch(Node.Item[i]);
    Node.DeleteChildren;
  end;
end;

procedure TForm1.ClearDeptsTree;
var i:integer;
begin
  for i:=0 to tvDept.Items.Count-1 do ClearDepBranch(tvDept.Items[i]);
end;

procedure TForm1.LoadDeptNodes(Node:TTreeNode);
var PID:PLongInt;
    i:integer;
    ParID:LongInt;
begin
  if Node=nil then ParID:=0 else ParID:=PLongInt(Node.Data)^;
  for i:=0 to FDeptList.Count-1 do begin
    if (FDeptList[i].ParentID=ParID)and(FDeptList[i].DptID<>ParID) then begin
      New(PID);
      PID^:=FDeptList[i].DptID;
      LoadDeptNodes(tvDept.Items.AddChildObject(Node,FDeptList[i].Name,PID));
    end;
  end;
end;

procedure TForm1.LoadDeptTree;
begin
  ClearDeptsTree;
  LoadDeptNodes(nil);
end;

procedure TForm1.UpdateDepts;
var Rec:TDeptRec;
begin
  FDeptList.Clear;
  aqDepts.Connection:=Conn;
  aqDepts.SQL.Clear;
  aqDepts.SQL.Add('select dpt_id,dpt_parent_id,dpt_name,dpt_boss from departments order by dpt_name');
  aqDepts.Open;
  ClearDeptsTree;
  aqDepts.First;
  while not aqDepts.Eof do begin
    Rec.DptID:=aqDepts.FieldByName('dpt_id').AsInteger;
    if aqDepts.FieldByName('dpt_parent_id').IsNull then Rec.ParentID:=0
      else Rec.ParentID:=aqDepts.FieldByName('dpt_parent_id').AsInteger;
    Rec.Name:=aqDepts.FieldByName('dpt_name').AsString;
    Rec.BossID:=aqDepts.FieldByName('dpt_boss').AsInteger;
    FDeptList.Add(Rec);
    aqDepts.Next;
  end;
  LoadDeptTree;
end;

procedure TForm1.aqStaffAfterScroll(DataSet: TDataSet);
begin
  tmDelayDStaff.Enabled:=False;
  Application.ProcessMessages;
  tmDelayDStaff.Enabled:=True;
end;

procedure TForm1.tmDelayDStaffTimer(Sender: TObject);
var Fld:TField;
begin
  tmDelayDStaff.Enabled:=False;
  if aqStaff.FieldDefList.Find('id')<>nil then begin
    Fld:=aqStaff.FieldByName('id');
    if not Fld.IsNull then DisplayEmployee(Fld.AsInteger);
  end;
end;

procedure TForm1.pcListChange(Sender: TObject);
begin
  if pcList.ActivePage=tsStaff then tmDelayQueryTimer(tsStaff);
  if pcList.ActivePage=tsDepts then tmDelayDStaffTimer(tsDepts);
end;

procedure TForm1.ClearUserInfo;
var i:integer;
begin
  for i:=0 to SG.RowCount-1 do SG.Cells[1,i]:='';
  Img.Canvas.Brush.Style:=bsSolid;
  Img.Canvas.Brush.Color:=pnPhoto.Color;
  Img.Canvas.FillRect(Img.ClientRect);
  Img.Picture.Graphic.Width:=Screen.Width;
  Img.Picture.Graphic.Height:=Screen.Height;
  Img.Invalidate;
end;

initialization

Clip:=TUnicodeClipboard.Create;

finalization

Clip.Free;

end.

