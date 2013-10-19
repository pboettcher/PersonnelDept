unit DptList;

interface

uses Windows,Classes;

type
  PDeptRec=^TDeptRec;
  TDeptRec=record
    DptID:LongInt;
    ParentID:LongInt;
    Name:ShortString;
    BossID:LongInt;
  end;

  TDeptList=class
  private
    FList:TList;
    procedure SetItem(i:integer; Rec:TDeptRec);
    function GetItem(i:integer):TDeptRec;
    function GetCount:integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const DptID,ParentID:LongInt; const Name:ShortString; const BossID:LongInt):Integer; overload;
    function Add(const Rec:TDeptRec):integer; overload;
    procedure Delete(i:integer);
    property Items[i:integer]:TDeptRec read GetItem write SetItem; default;
    property Count:integer read GetCount;
  end;

implementation

constructor TDeptList.Create;
begin
  FList:=TList.Create;
end;

destructor TDeptList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

procedure TDeptList.Clear;
var i:integer;
begin
  for i:=0 to FList.Count-1 do begin
    if FList[i]<>nil then Dispose(PDeptRec(FList[i]));
  end;
  FList.Clear;
end;

function TDeptList.Add(const Rec:TDeptRec):integer;
var PDR:PDeptRec;
begin
  New(PDR);
  PDR^:=Rec;
  Result:=FList.Add(PDR);
end;

function TDeptList.Add(const DptID,ParentID:LongInt; const Name:ShortString; const BossID:LongInt):Integer;
var PDR:PDeptRec;
begin
  New(PDR);
  PDR^.DptID:=DptID;
  PDR^.ParentID:=ParentID;
  PDR^.Name:=Name;
  PDR^.BossID:=BossID;
  Result:=FList.Add(PDR);
end;

procedure TDeptList.SetItem(i:integer; Rec:TDeptRec);
begin
  if (i<0)or(i>=FList.Count) then Exit;
  PDeptRec(FList[i])^:=Rec;
end;

function TDeptList.GetItem(i:integer):TDeptRec;
begin
  Result.DptID:=0;
  Result.ParentID:=0;
  Result.Name:='';
  Result.BossID:=0;
  if (i<0)or(i>=FList.Count) then Exit;
  if FList[i]=nil then Exit;
  Result:=PDeptRec(FList[i])^;
end;

procedure TDeptList.Delete(i:integer);
begin
  if (i<0)or(i>=FList.Count) then Exit;
  if FList[i]<>nil then Dispose(PDeptRec(FList[i]));
  Flist.Delete(i);
end;

function TDeptList.GetCount:integer;
begin
  Result:=FList.Count;
end;

end.
