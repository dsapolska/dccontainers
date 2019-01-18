unit U_DCRBTContainer;

interface

uses
  Classes, U_DCTree, U_DCManagerBase, U_DCHashBase, U_DCTreeKeyValue;

type
  {
    Base container class for maps/sets working on Red-Black tree index.

    Attention: class takes ownership of objects passed to constructor and destroys them in destructor
  }
  TDCRBTContainer = class
  private
    function GetCount : Integer;
    function CheckIsEmpty : boolean;
    function GetItem(AIndex: integer): PDCTreeKeyValue;

    procedure FreeObjects;
    procedure FreeExistingValueObject(AKVPtr : PDCTreeKeyValue);
  protected
    FTree : TDCTree;
    FManager : TDCManagerBase;
    FHash : TDCHashBase;

    function IntAdd(AHashedKey : integer; AValue : integer) : boolean; overload;
    function IntAdd(AHashedKey : integer; const AValue : string) : boolean; overload;
    function IntAdd(AHashedKey : integer; AValue : TObject) : boolean; overload;

    procedure IntReplaceValue(AKVPtr : PDCTreeKeyValue; AValue : integer); overload;
    procedure IntReplaceValue(AKVPtr : PDCTreeKeyValue; const AValue : string); overload;
    procedure IntReplaceValue(AKVPtr : PDCTreeKeyValue; AValue : TObject); overload;

    function IntRemove(AHashedKey : integer; var VValue : TObject) : boolean; overload;
    function IntRemove(AHashedKey : integer) : boolean; overload;
    function IntFind(AHashedKey : integer) : PDCTreeKeyValue;
  public
    property Count : integer read GetCount;
    property IsEmpty : boolean read CheckIsEmpty;
    property Items[AIndex : integer] : PDCTreeKeyValue read GetItem; default;

    constructor Create(AManager : TDCManagerBase; AHash : TDCHashBase = nil);
    destructor Destroy; override;

    procedure Clear(AFreeObjects : boolean = false);
    function IndexOf(AKVPtr : PDCTreeKeyValue) : integer;

    procedure ShowTree(AStrings : TStrings);
  end;

implementation

uses RBTreeTypes, U_DCValueInteger, U_DCValueObject, U_DCValueString,
  SysUtils, U_DCValue;

{ TDCRBTContainer }

constructor TDCRBTContainer.Create(AManager : TDCManagerBase; AHash : TDCHashBase);
begin
  FManager:=AManager;
  FHash:=AHash;
  FTree:=TDCTree.Create;
end;

destructor TDCRBTContainer.Destroy;
begin
  Clear;
  FTree.Free;
  if FHash <> nil then FHash.Free;
  FManager.Free;
  inherited;
end;

procedure TDCRBTContainer.Clear(AFreeObjects : boolean);
begin
  if AFreeObjects then
    FreeObjects;
  FTree.Clear;
  FManager.Clear;
end;

procedure TDCRBTContainer.FreeObjects;
var
  i : integer;
  v : TDCValue;
begin
  for i:=0 to FManager.Count - 1 do
  begin
    v:=FManager[i]^.Value;
    if (v is TDCValueObject) and (TDCValueObject(v).AsObject <> nil) then
      TDCValueObject(v).AsObject.Free;
  end;
end;

function TDCRBTContainer.CheckIsEmpty: boolean;
begin
  Result:=FManager.IsEmpty;
end;

function TDCRBTContainer.GetCount: Integer;
begin
  Result:=FManager.Count;
end;

function TDCRBTContainer.GetItem(AIndex: integer): PDCTreeKeyValue;
begin
  result:=FManager[AIndex];
end;

function TDCRBTContainer.IndexOf(AKVPtr: PDCTreeKeyValue): integer;
begin
  result:=FManager.IndexOf(AKVPtr);
end;

function TDCRBTContainer.IntAdd(AHashedKey, AValue: integer) : boolean;
begin
  result:=(FTree.Add(FManager.CreateObject(AHashedKey, AValue)) <> nil);
  if not result then
    FManager.DeleteObject(FManager[FManager.Count - 1]);
end;

function TDCRBTContainer.IntAdd(AHashedKey: integer;
  const AValue: string) : boolean;
begin
  result:=(FTree.Add(FManager.CreateObject(AHashedKey, AValue)) <> nil);
  if not result then
    FManager.DeleteObject(FManager[FManager.Count - 1]);
end;

function TDCRBTContainer.IntAdd(AHashedKey: integer; AValue: TObject) : boolean;
begin
  result:=(FTree.Add(FManager.CreateObject(AHashedKey, AValue)) <> nil);
  if not result then
    FManager.DeleteObject(FManager[FManager.Count - 1]);
end;

procedure TDCRBTContainer.FreeExistingValueObject(AKVPtr: PDCTreeKeyValue);
begin
  if AKVPtr^.Value <> nil then
    FreeAndNil(AKVPtr^.Value);
end;

procedure TDCRBTContainer.IntReplaceValue(AKVPtr: PDCTreeKeyValue;
  AValue: integer);
begin
  FreeExistingValueObject(AKVPtr);
  AKVPtr^.Value:=TDCValueInteger.Create(AValue);
end;

procedure TDCRBTContainer.IntReplaceValue(AKVPtr: PDCTreeKeyValue;
  const AValue: string);
begin
  FreeExistingValueObject(AKVPtr);
  AKVPtr^.Value:=TDCValueString.Create(AValue);
end;

procedure TDCRBTContainer.IntReplaceValue(AKVPtr: PDCTreeKeyValue;
  AValue: TObject);
begin
  FreeExistingValueObject(AKVPtr);
  if AValue <> nil then
    AKVPtr^.Value:=TDCValueObject.Create(AValue);
end;

function TDCRBTContainer.IntRemove(AHashedKey: integer; var VValue : TObject): boolean;
var
  node : TRBNodeP;
begin
  result:=false;
  VValue:=nil;
  node:=FTree.Find(AHashedKey);
  if node <> nil then
  begin
    if PDCTreeKeyValue(node^.k)^.Value is TDCValueObject then
      VValue:=PDCTreeKeyValue(node^.k)^.Value.AsObject;
    FManager.DeleteObject(PDCTreeKeyValue(node^.k));
    FTree.Delete(node);
    result:=true;
  end;
end;

function TDCRBTContainer.IntRemove(AHashedKey: integer): boolean;
var
  o : TObject;
begin
  result:=IntRemove(AHashedKey, o);
end;

function TDCRBTContainer.IntFind(AHashedKey: integer): PDCTreeKeyValue;
var
  node : TRBNodeP;
begin
  result:=nil;
  node:=FTree.Find(AHashedKey);
  if node <> nil then
    Result:=PDCTreeKeyValue(node^.k);
end;

procedure TDCRBTContainer.ShowTree(AStrings: TStrings);
begin
  FTree.ShowTree(AStrings);
end;

end.
