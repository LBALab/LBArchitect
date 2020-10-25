unit SceneObj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, Scene, Engine, SceneLib,
  SceneLibConst, Math, DFSClrBn, ScriptEd, SpinMod, ActorInfo, ComboMod, DePack,
  SceneUndo, Utils, Clipbrd, ActorTpl, BetterSpin, ActnList, Menus, ActnPopup,
  ImgList;
                                
type
  TfrSceneObj = class(TFrame)
    lbObjType: TLabel;
    abActions: TPopupActionBar;
    acActions: TActionList;
    acNew: TAction;
    acClone: TAction;
    acDelete: TAction;
    acTemplate: TAction;
    btActions: TBitBtn;
    New1: TMenuItem;
    Clone1: TMenuItem;
    Delete1: TMenuItem;
    emplate1: TMenuItem;
    lbTotal: TLabel;
    btObjFind: TBitBtn;
    Bevel2: TBevel;
    acAutoFind: TAction;
    N1: TMenuItem;
    Autofind1: TMenuItem;
    btSelect: TBitBtn;
    sbScrollBox: TScrollBox;
    paZoneProp: TPanel;
    lbZSX: TLabel;
    lbZSY: TLabel;
    lbZSZ: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    lbZPX: TLabel;
    lbZPY: TLabel;
    lbZPZ: TLabel;
    cbZType: TComboBox;
    pcZType: TPageControl;
    tsZType0: TTabSheet;
    lbZ0Id: TLabel;
    lbZ0X: TLabel;
    lbZ0Y: TLabel;
    lbZ0Z: TLabel;
    Label8: TLabel;
    btZ0Copy: TBitBtn;
    btZ0Paste: TBitBtn;
    tsZType1: TTabSheet;
    lbZ1X: TLabel;
    lbZ1Y: TLabel;
    lbZ1Z: TLabel;
    Label9: TLabel;
    tsZType2: TTabSheet;
    lbZ2Id: TLabel;
    Label54: TLabel;
    tsZType3: TTabSheet;
    lbZ3Id: TLabel;
    lbFragmentInfo: TLabel;
    Label16: TLabel;
    Label20: TLabel;
    cbZ3Fragment: TComboBox;
    BitBtn1: TBitBtn;
    tsZType4: TTabSheet;
    lbZ4Num: TLabel;
    cbZ4Enabled: TCheckBox;
    cbZ4Money: TCheckBox;
    cbZ4Life: TCheckBox;
    cbZ4Magic: TCheckBox;
    cbZ4Key: TCheckBox;
    cbZ4Clover: TCheckBox;
    tsZType5: TTabSheet;
    lbZ5Id: TLabel;
    tsZType6: TTabSheet;
    btZCopy: TBitBtn;
    btZPaste: TBitBtn;
    btZSCopy: TBitBtn;
    btZSPaste: TBitBtn;
    paPointProp: TPanel;
    lbPX: TLabel;
    lbPY: TLabel;
    lbPZ: TLabel;
    paActorProp: TPanel;
    lbAX: TLabel;
    lbAY: TLabel;
    lbAZ: TLabel;
    imgActions: TImageList;
    cbAColObj: TCheckBox;
    cbAColBrk: TCheckBox;
    cbAZonable: TCheckBox;
    cbAClipped: TCheckBox;
    cbAPushable: TCheckBox;
    cbALowCol: TCheckBox;
    cbAStanding: TCheckBox;
    cbAHidden: TCheckBox;
    cbASprite: TCheckBox;
    cbACanFall: TCheckBox;
    cbANoShadow: TCheckBox;
    cbABackgrnd: TCheckBox;
    cbACarrier: TCheckBox;
    cbAMiniZV: TCheckBox;
    Label1: TLabel;
    Label19: TLabel;
    cbAMode: TComboBox;
    pcClipMode: TPageControl;
    tsClipping: TTabSheet;
    lbAClipping: TLabel;
    lbAInfo2: TLabel;
    lbAInfo3: TLabel;
    lbAInfo1: TLabel;
    lbAInfo0: TLabel;
    tsFollow: TTabSheet;
    lbAFollow: TLabel;
    Label22: TLabel;
    lbAHit: TLabel;
    Label28: TLabel;
    lbAArm: TLabel;
    lbALife: TLabel;
    lbARot: TLabel;
    lbAAng: TLabel;
    Label7: TLabel;
    lbAAngle: TLabel;
    cbACol: TComboBox;
    pcBody: TPageControl;
    ts3DBody: TTabSheet;
    lbAEntityT: TLabel;
    lbAEntity: TLabel;
    cbAEntity: TComboBox;
    lbABodyT: TLabel;
    lbABody: TLabel;
    cbABody: TComboBox;
    lbAAnimT: TLabel;
    lbAAnim: TLabel;
    cbAAnim: TComboBox;
    tsSpriteBody: TTabSheet;
    lbASprite: TLabel;
    lbASpriteT: TLabel;
    cbASprites: TComboBox;
    lbABon: TLabel;
    cbAMoney: TCheckBox;
    cbALife: TCheckBox;
    cbAMagic: TCheckBox;
    cbAKey: TCheckBox;
    cbAClover: TCheckBox;
    Label23: TLabel;
    tsClipNone: TTabSheet;
    tsRandomInt: TTabSheet;
    lbARnd: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    acScripts: TAction;
    N2: TMenuItem;
    acScripts1: TMenuItem;
    lbObjName: TLabel;
    edObjName: TEdit;
    lbADebug: TLabel;
    lbZDebug: TLabel;
    tsZType9: TTabSheet;
    lbZ8Id: TLabel;
    tsZType7: TTabSheet;
    tsZType8: TTabSheet;
    procedure seTXChange(Sender: TObject);
    procedure seAXChange(Sender: TObject);
    procedure seObjIdChange(Sender: TObject);
    procedure cbAModeChange(Sender: TObject);
    procedure cbAColDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbAStaticFlagChange(Sender: TObject);
    procedure seZXChange(Sender: TObject);
    procedure pcZTypeChange(Sender: TObject);
    procedure seZ0TargetIdChange(Sender: TObject);
    procedure btObjFindClick(Sender: TObject);
    procedure cbAAutoFindMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btZ0CopyClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acCloneExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acTemplateExecute(Sender: TObject);
    procedure btActionsClick(Sender: TObject);
    procedure acAutoFindExecute(Sender: TObject);
    procedure pcClipModeChange(Sender: TObject);
    procedure acScriptsExecute(Sender: TObject);
    procedure btSelectClick(Sender: TObject);
    procedure edObjNameChange(Sender: TObject);
  private
    procedure EnableBonusControls(Prefix: String; Ena: Boolean);
    Procedure EnableActorControls(id: Byte; DisAll: Boolean = False);
    procedure EnableTrackControls(Ena: Boolean);
    procedure EnableZoneControls(Ena: Boolean);
    Procedure GetStaticFlags(Flags: Word);
    function SetStaticFlags(): Word;
    Procedure GetBonusFlags(Bonus: Word; Prefix: String);
    Function SetBonusFlags(Prefix: String): Word;
    procedure LoadcbAMode(Lba: Integer);
    procedure LoadcbZType(Lba: Integer);
  public
    seObjId: TfrBetterSpin;
    seAClip: array[0..3] of TfrBetterSpin;
    seAFollow: TfrBetterSpin;
    seARandom: TfrBetterSpin;
    seAPower: TfrBetterSpin;
    seAArmour: TfrBetterSpin;
    seALife: TfrBetterSpin;
    seASpeed: TfrBetterSpin;
    seAAngle: TfrBetterSpin;
    seABonusAmnt: TfrBetterSpin;
    seAX, seAY, seAZ: TfrBetterSpin;
    seTX, seTY, seTZ: TfrBetterSpin;
    seZX, seZY, seZZ: TfrBetterSpin;
    seZSX, seZSY, seZSZ: TfrBetterSpin;
    seZ0TargetId: TfrBetterSpin;
    seZ0X, seZ0Y, seZ0Z: TfrBetterSpin;
    seZ1X, seZ1Y, seZ1Z: TfrBetterSpin;
    seZ2ZoneId: TfrBetterSpin;
    seZ3GridId: TfrBetterSpin;
    seZ4Amount: TfrBetterSpin;
    seZ5TextId: TfrBetterSpin;
    seZ9RailId: TfrBetterSpin;

    NoSpinChange: Boolean;
    constructor Create(AOwner: TComponent); override;
    Procedure ChangeSceneObj();
    procedure InitSceneObj();
    procedure UpdateBodyAndAnimLists(entity: Integer);
    procedure EnableBodyAndAnimLists(Ena: Boolean);
    procedure SetBodyCombo(entity, body: Integer);
    procedure SetAnimCombo(entity, anim: Integer);
  end;

implementation

uses Main, Open, Settings, Hints, Globals, Select;

var
 Selecting: Boolean = False;

{$R *.dfm}

constructor TfrSceneObj.Create(AOwner: TComponent);
var a: Integer;
begin
 inherited;
 seObjId:= TfrBetterSpin.Create(Self);
 seObjId.Name:= 'seObjId';  seObjId.Parent:= Self;  seObjId.TabOrder:= 0;
 seObjId.SetBounds(39, 1, 41, 22);
 seObjId.Hint:= 'Selected object index';
 seObjId.Setup(0, 10, 1);  seObjId.OnChange:= seObjIdChange;
 for a:= 0 to 3 do begin
   seAClip[a]:= TfrBetterSpin.Create(Self);
   seAClip[a].Name:= 'seAClip' + IntToStr(a);  seAClip[a].Parent:= tsClipping;
   seAClip[a].SetBounds(lbAInfo3.Left + lbAInfo3.Width + 2, lbAInfo0.Top - 4 + a*22, 62, 22);
   seAClip[a].Setup(-32768, 32767, 1);  seAClip[a].OnChange:= cbAModeChange;
 end;
 seAFollow:= TfrBetterSpin.Create(Self);
 seAFollow.Name:= 'seAFollow';  seAFollow.Parent:= tsFollow;
 seAFollow.SetBounds(lbAFollow.Left, lbAFollow.Top + lbAFollow.Height + 2, 62, 22);
 seAFollow.Setup(0, 255, 1);  seAFollow.OnChange:= cbAModeChange;
 seARandom:= TfrBetterSpin.Create(Self);
 seARandom.Name:= 'seARandom';  seARandom.Parent:= tsRandomInt;
 seARandom.SetBounds(lbARnd.Left, lbARnd.Top + lbARnd.Height + 2, 62, 22);
 seARandom.Setup(0, 32767, 1);  seARandom.OnChange:= cbAModeChange;
 seAPower:= TfrBetterSpin.Create(Self);
 seAPower.Name:= 'seAPower';  seAPower.Parent:= paActorProp;
 seAPower.SetBounds(cbACol.Left, lbAHit.Top - 4, 62, 22);
 seAPower.Setup(0, 255, 1);  seAPower.OnChange:= cbAModeChange;
 seAArmour:= TfrBetterSpin.Create(Self);
 seAArmour.Name:= 'seAArmour';  seAArmour.Parent:= paActorProp;
 seAArmour.SetBounds(cbACol.Left, lbAArm.Top - 4, 62, 22);
 seAArmour.Setup(0, 255, 1);  seAArmour.OnChange:= cbAModeChange;
 seALife:= TfrBetterSpin.Create(Self);
 seALife.Name:= 'seALife';  seALife.Parent:= paActorProp;
 seALife.SetBounds(cbACol.Left, lbALife.Top - 4, 62, 22);
 seALife.Setup(0, 255, 1);  seALife.OnChange:= cbAModeChange;
 seASpeed:= TfrBetterSpin.Create(Self);
 seASpeed.Name:= 'seASpeed';  seASpeed.Parent:= paActorProp;
 seASpeed.SetBounds(cbACol.Left, lbARot.Top - 4, 62, 22);
 seASpeed.Setup(0, 65535, 1);  seASpeed.OnChange:= cbAModeChange;
 seAAngle:= TfrBetterSpin.Create(Self);
 seAAngle.Name:= 'seAAngle';  seAAngle.Parent:= paActorProp;
 seAAngle.SetBounds(cbACol.Left, lbAAng.Top - 4, 62, 22);
 seAAngle.Setup(0, 359, 1, 45);  seAAngle.OnChange:= cbAModeChange;
 seABonusAmnt:= TfrBetterSpin.Create(Self);
 seABonusAmnt.Name:= 'seABonusAmnt';
 seABonusAmnt.Parent:= paActorProp;  seABonusAmnt.TabOrder:= 0;
 seABonusAmnt.SetBounds(lbABon.Left + lbABon.Width + 2, lbABon.Top - 4, 62, 22);
 seABonusAmnt.Setup(0, 65535, 1, 10);  seABonusAmnt.OnChange:= cbAModeChange;
 seAX:= TfrBetterSpin.Create(Self);
 seAX.Name:= 'seAX';  seAX.Parent:= paActorProp;  seAX.TabOrder:= 1;
 seAX.SetBounds(lbAX.Left + lbAX.Width + 2, lbAX.Top - 4, 74, 22);
 seAX.Color:= $FFBE00;
 seAX.Setup(-32768, 32767, 1, 256);  seAX.OnChange:= seAXChange;
 seAY:= TfrBetterSpin.Create(Self);
 seAY.Name:= 'seAY';  seAY.Parent:= paActorProp;  seAY.TabOrder:= 2;
 seAY.SetBounds(lbAY.Left + lbAY.Width + 2, lbAY.Top - 4, 74, 22);
 seAY.Color:= clYellow;
 seAY.Setup(-32768, 32767, 1, 256);  seAY.OnChange:= seAXChange;
 seAZ:= TfrBetterSpin.Create(Self);
 seAZ.Name:= 'seAZ';  seAZ.Parent:= paActorProp;  seAZ.TabOrder:= 3;
 seAZ.SetBounds(lbAZ.Left + lbAZ.Width + 2, lbAZ.Top - 4, 74, 22);
 seAZ.Color:= clLime;
 seAZ.Setup(-32768, 32767, 1, 256);  seAZ.OnChange:= seAXChange;

 seTX:= TfrBetterSpin.Create(Self);
 seTX.Name:= 'seTX';  seTX.Parent:= paPointProp;  seTX.TabOrder:= 1;
 seTX.SetBounds(lbPX.Left + lbPX.Width + 2, lbPX.Top - 4, 74, 22);
 seTX.Color:= $FFBE00;
 seTX.Setup(-32768, 32767, 1, 256);  seTX.OnChange:= seTXChange;
 seTY:= TfrBetterSpin.Create(Self);
 seTY.Name:= 'seTY';  seTY.Parent:= paPointProp;  seTY.TabOrder:= 2;
 seTY.SetBounds(lbPY.Left + lbPY.Width + 2, lbPY.Top - 4, 74, 22);
 seTY.Color:= clYellow;
 seTY.Setup(-32768, 32767, 1, 256);  seTY.OnChange:= seTXChange;
 seTZ:= TfrBetterSpin.Create(Self);
 seTZ.Name:= 'seTZ';  seTZ.Parent:= paPointProp;  seTZ.TabOrder:= 3;
 seTZ.SetBounds(lbPZ.Left + lbPZ.Width + 2, lbPZ.Top - 4, 74, 22);
 seTZ.Color:= clLime;
 seTZ.Setup(-32768, 32767, 1, 256);  seTZ.OnChange:= seTXChange;

 seZX:= TfrBetterSpin.Create(Self);
 seZX.Name:= 'seZX';  seZX.Parent:= paZoneProp;
 seZX.SetBounds(lbZPX.Left + lbZPX.Width + 2, lbZPX.Top - 4, 74, 22);
 seZX.Color:= $FFBE00;
 seZX.Setup(-32768, 32767, 1, 256);  seZX.OnChange:= seZXChange;
 seZY:= TfrBetterSpin.Create(Self);
 seZY.Name:= 'seZY';  seZY.Parent:= paZoneProp;
 seZY.SetBounds(lbZPY.Left + lbZPY.Width + 2, lbZPY.Top - 4, 74, 22);
 seZY.Color:= clYellow;
 seZY.Setup(-32768, 32767, 1, 256);  seZY.OnChange:= seZXChange;
 seZZ:= TfrBetterSpin.Create(Self);
 seZZ.Name:= 'seZZ';  seZZ.Parent:= paZoneProp;
 seZZ.SetBounds(lbZPZ.Left + lbZPZ.Width + 2, lbZPZ.Top - 4, 74, 22);
 seZZ.Color:= clLime;
 seZZ.Setup(-32768, 32767, 1, 256);  seZZ.OnChange:= seZXChange;
 seZSX:= TfrBetterSpin.Create(Self);
 seZSX.Name:= 'seZSX';  seZSX.Parent:= paZoneProp;
 seZSX.SetBounds(lbZSX.Left + lbZSX.Width + 2, lbZSX.Top - 4, 74, 22);
 seZSX.Color:= $FFBE00;
 seZSX.Setup(-32768, 32767, 1, 256);  seZSX.OnChange:= seZXChange;
 seZSY:= TfrBetterSpin.Create(Self);
 seZSY.Name:= 'seZSY';  seZSY.Parent:= paZoneProp;
 seZSY.SetBounds(lbZSY.Left + lbZSY.Width + 2, lbZSY.Top - 4, 74, 22);
 seZSY.Color:= clYellow;
 seZSY.Setup(-32768, 32767, 1, 256);  seZSY.OnChange:= seZXChange;
 seZSZ:= TfrBetterSpin.Create(Self);
 seZSZ.Name:= 'seZSZ';  seZSZ.Parent:= paZoneProp;
 seZSZ.SetBounds(lbZSZ.Left + lbZSZ.Width + 2, lbZSZ.Top - 4, 74, 22);
 seZSZ.Color:= clLime;
 seZSZ.Setup(-32768, 32767, 1, 256);  seZSZ.OnChange:= seZXChange;
 seZ0TargetId:= TfrBetterSpin.Create(Self);
 seZ0TargetId.Name:= 'seZ0TargetId';  seZ0TargetId.Parent:= tsZType0;
 seZ0TargetId.SetBounds(lbZ0Id.Left, lbZ0Id.Top + lbZ0Id.Height + 2, 62, 22);
 seZ0TargetId.Setup(0, 255, 1);  seZ0TargetId.OnChange:= seZ0TargetIdChange;
 seZ0X:= TfrBetterSpin.Create(Self);
 seZ0X.Name:= 'seZ0X';  seZ0X.Parent:= tsZType0;
 seZ0X.SetBounds(lbZ0X.Left + lbZ0X.Width + 2, lbZ0X.Top - 4, 74, 22);
 seZ0X.Color:= $FFBE00;
 seZ0X.Setup(-32768, 32767, 1, 256);  seZ0X.OnChange:= seZ0TargetIdChange;
 seZ0Y:= TfrBetterSpin.Create(Self);
 seZ0Y.Name:= 'seZ0Y';  seZ0Y.Parent:= tsZType0;
 seZ0Y.SetBounds(lbZ0Y.Left + lbZ0Y.Width + 2, lbZ0Y.Top - 4, 74, 22);
 seZ0Y.Color:= clYellow;
 seZ0Y.Setup(-32768, 32767, 1, 256);  seZ0Y.OnChange:= seZ0TargetIdChange;
 seZ0Z:= TfrBetterSpin.Create(Self);
 seZ0Z.Name:= 'seZ0Z';  seZ0Z.Parent:= tsZType0;
 seZ0Z.SetBounds(lbZ0Z.Left + lbZ0Z.Width + 2, lbZ0Z.Top - 4, 74, 22);
 seZ0Z.Color:= clLime;
 seZ0Z.Setup(-32768, 32767, 1, 256);  seZ0Z.OnChange:= seZ0TargetIdChange;
 seZ1X:= TfrBetterSpin.Create(Self);
 seZ1X.Name:= 'seZ1X';  seZ1X.Parent:= tsZType1;
 seZ1X.SetBounds(lbZ1X.Left + lbZ1X.Width + 2, lbZ1X.Top - 4, 74, 22);
 seZ1X.Color:= $FFBE00;
 seZ1X.Setup(-32768, 32767, 1, 256);  seZ1X.OnChange:= seZ0TargetIdChange;
 seZ1Y:= TfrBetterSpin.Create(Self);
 seZ1Y.Name:= 'seZ1Y';  seZ1Y.Parent:= tsZType1;
 seZ1Y.SetBounds(lbZ1Y.Left + lbZ1Y.Width + 2, lbZ1Y.Top - 4, 74, 22);
 seZ1Y.Color:= clYellow;
 seZ1Y.Setup(-32768, 32767, 1, 256);  seZ1Y.OnChange:= seZ0TargetIdChange;
 seZ1Z:= TfrBetterSpin.Create(Self);
 seZ1Z.Name:= 'seZ1Z';  seZ1Z.Parent:= tsZType1;
 seZ1Z.SetBounds(lbZ1Z.Left + lbZ1Z.Width + 2, lbZ1Z.Top - 4, 74, 22);
 seZ1Z.Color:= clLime;
 seZ1Z.Setup(-32768, 32767, 1, 256); seZ1Z.OnChange:= seZ0TargetIdChange;
 seZ2ZoneId:= TfrBetterSpin.Create(Self);
 seZ2ZoneId.Name:= 'seZ2ZoneId';  seZ2ZoneId.Parent:= tsZType2;
 seZ2ZoneId.SetBounds(lbZ2Id.Left, lbZ2Id.Top + lbZ2Id.Height + 2, 62, 22);
 seZ2ZoneId.Setup(0, 65535, 1); seZ2ZoneId.OnChange:= seZ0TargetIdChange;
 seZ3GridId:= TfrBetterSpin.Create(Self);
 seZ3GridId.Name:= 'seZ3GridId';  seZ3GridId.Parent:= tsZType3;
 seZ3GridId.SetBounds(lbZ3Id.Left, lbZ3Id.Top + lbZ3Id.Height + 2, 62, 22);
 seZ3GridId.Setup(0, 255, 1); seZ3GridId.OnChange:= seZ0TargetIdChange;
 seZ4Amount:= TfrBetterSpin.Create(Self);
 seZ4Amount.Name:= 'seZ4Amount';  seZ4Amount.Parent:= tsZType4;
 seZ4Amount.SetBounds(lbZ4Num.Left, lbZ4Num.Top + lbZ4Num.Height + 2, 74, 22);
 seZ4Amount.Setup(0, 65535, 1, 10);  seZ4Amount.OnChange:= seZ0TargetIdChange;
 seZ5TextId:= TfrBetterSpin.Create(Self);
 seZ5TextId.Name:= 'seZ5TextId';  seZ5TextId.Parent:= tsZType5;
 seZ5TextId.SetBounds(lbZ5Id.Left, lbZ5Id.Top + lbZ5Id.Height + 2, 62, 22);
 seZ5TextId.Setup(0, 65535, 1);  seZ5TextId.OnChange:= seZ0TargetIdChange;
 seZ9RailId:= TfrBetterSpin.Create(Self);
 seZ9RailId.Name:= 'seZ9RailId';  seZ9RailId.Parent:= tsZType9;
 seZ9RailId.SetBounds(lbZ5Id.Left, lbZ8Id.Top + lbZ8Id.Height + 2, 62, 22);
 seZ9RailId.Setup(0, 255, 1);  seZ9RailId.OnChange:= seZ0TargetIdChange;
end;

procedure TfrSceneObj.EnableBonusControls(Prefix: String; Ena: Boolean);
begin
 (FindComponent(Prefix+'Money')  as TCheckBox).Enabled:= Ena;
 (FindComponent(Prefix+'Life')   as TCheckBox).Enabled:= Ena;
 (FindComponent(Prefix+'Magic')  as TCheckBox).Enabled:= Ena;
 (FindComponent(Prefix+'Key')    as TCheckBox).Enabled:= Ena;
 (FindComponent(Prefix+'Clover') as TCheckBox).Enabled:= Ena;
end;

Procedure TfrSceneObj.EnableActorControls(id: Byte; DisAll: Boolean = False);
var IsSprite, Clipped: Boolean;
    Mode: Integer;
begin
 if id < High(VScene.Actors) then begin
   IsSprite:= (VScene.Actors[id].StaticFlags and sfSprite) <> 0;
   Clipped:=  (VScene.Actors[id].StaticFlags and sfClipped) <> 0;
   Mode:= IfThen(DisAll, 0, VScene.Actors[id].CtrlMode);
 end else begin
   IsSprite:= False;
   Clipped:= False;
   Mode:= 0;
 end;
 seAAngle.Enabled:=     not DisAll {and not IsSprite};
 seAPower.Enabled:=     not DisAll and not IsSprite;
 //seAAnim.Enabled:=      not DisAll and not IsSprite;
 cbAAnim.Enabled:=      not DisAll and not IsSprite;
 lbAAnim.Enabled:=      cbAAnim.Enabled;
 lbAAnimT.Enabled:=     cbAAnim.Enabled;
 seAArmour.Enabled:=    not DisAll {and not IsSprite};
 seALife.Enabled:=      not DisAll {and not IsSprite};
 EnableBonusControls('cbA', not DisAll {and not IsSprite});
 seABonusAmnt.Enabled:= not DisAll {and not IsSprite};
 seASpeed.Enabled:=     not DisAll {and not IsSprite};
 cbACol.Enabled:=       not DisAll and not IsSprite;
 //seABody.Enabled:=      not DisAll and not IsSprite;
 cbABody.Enabled:=      not DisAll and not IsSprite;
 lbABody.Enabled:=      cbABody.Enabled;
 lbABodyT.Enabled:=     cbABody.Enabled;
 //seAEntity.Enabled:=    not DisAll and not IsSprite;
 cbAEntity.Enabled:=    not DisAll and not IsSprite;
 lbAEntity.Enabled:=    cbAEntity.Enabled;
 lbAEntityT.Enabled:=   cbAEntity.Enabled;
 //seASprite.Enabled:=    not DisAll and IsSprite;
 cbASprites.Enabled:=   not DisAll and IsSprite;
 lbASprite.Enabled:=    cbASprites.Enabled;
 lbASpriteT.Enabled:=   cbASprites.Enabled;

 {seAClip[0].Enabled:=   not DisAll;
 seAClip[1].Enabled:=   not DisAll;
 seAClip[2].Enabled:=   not DisAll;
 seAClip[3].Enabled:=   not DisAll;
 seAFollow.Enabled:=    not DisAll;
 seARandom.Enabled:=    not DisAll;}
 if DisAll then
   pcClipMode.ActivePage:= tsClipNone
 else begin
   if Mode in [2, 6] then
     pcClipMode.ActivePage:= tsFollow
   else if Mode = 7 then
     pcClipMode.ActivePage:= tsRandomInt
   else if Clipped then
     pcClipMode.ActivePage:= tsClipping
   else
     pcClipMode.ActivePage:= tsClipNone;
   pcClipModeChange(Self);
 end;

 seObjId.Enabled:=      not DisAll;
 btObjFind.Enabled:=    not DisAll;
 acScripts.Enabled:=    not DisAll;
 seAX.Enabled:=         not DisAll;
 seAY.Enabled:=         not DisAll;
 seAZ.Enabled:=         not DisAll;
 acClone.Enabled:=      not DisAll;
 acDelete.Enabled:=     not DisAll and (id > 0);
 acTemplate.Enabled:=   not DisAll and (id > 0);
 cbAMode.Enabled:=      not DisAll;
 cbAColObj.Enabled:=    not DisAll;
 cbAColBrk.Enabled:=    not DisAll;
 cbAZonable.Enabled:=   not DisAll;
 cbAClipped.Enabled:=   not DisAll;
 cbAPushable.Enabled:=  not DisAll;
 cbALowCol.Enabled:=    not DisAll;
 cbAStanding.Enabled:=  not DisAll;
 cbAHidden.Enabled:=    not DisAll;
 cbASprite.Enabled:=    not DisAll;
 cbACanFall.Enabled:=   not DisAll;
 cbANoShadow.Enabled:=  not DisAll;
 cbABackgrnd.Enabled:=  not DisAll;
 cbACarrier.Enabled:=   not DisAll;
 cbAMiniZV.Enabled:=    not DisAll;
end;

procedure TfrSceneObj.EnableTrackControls(Ena: Boolean);
begin
 seTX.Enabled:=     Ena;
 seTY.Enabled:=     Ena;
 seTZ.Enabled:=     Ena;
 acClone.Enabled:=  Ena;
 acDelete.Enabled:= Ena;
 acTemplate.Enabled:= False;
 acScripts.Enabled:= False;
end;

procedure TfrSceneObj.EnableZoneControls(Ena: Boolean);
begin
 seZX.Enabled:=         Ena;
 seZY.Enabled:=         Ena;
 seZZ.Enabled:=         Ena;
 seZSX.Enabled:=        Ena;
 seZSY.Enabled:=        Ena;
 seZSZ.Enabled:=        Ena;
 acClone.Enabled:=      Ena;
 acDelete.Enabled:=     Ena;
 acTemplate.Enabled:=   False;
 acScripts.Enabled:=    False;
 cbZType.Enabled:=      Ena;
 //eZInfo0.Enabled:=      Ena;
 //eZInfo1.Enabled:=      Ena;
 //eZInfo2.Enabled:=      Ena;
 //eZInfo3.Enabled:=      Ena;
 //eZInfo4.Enabled:=      Ena;
 //eZInfo5.Enabled:=      Ena;
 //eZInfo6.Enabled:=      Ena;
 //eZSnap.Enabled:=       Ena;
 seZ0TargetId.Enabled:= Ena;
 seZ0X.Enabled:=        Ena;
 seZ0Y.Enabled:=        Ena;
 seZ0Z.Enabled:=        Ena;
 seZ1X.Enabled:=        Ena;
 seZ1Y.Enabled:=        Ena;
 seZ1Z.Enabled:=        Ena;
 seZ2ZoneId.Enabled:=   Ena;
 seZ3GridId.Enabled:=   Ena;
 cbZ3Fragment.Enabled:= Ena;
 EnableBonusControls('cbZ4', Ena);
 seZ4Amount.Enabled:=   Ena;
 cbZ4Enabled.Enabled:=  Ena;
 seZ5TextId.Enabled:=   Ena;
end;

Procedure TfrSceneObj.GetStaticFlags(Flags: Word);
begin
 cbAColObj.Checked:=   (Flags and sfColObj)   <> 0;
 cbAColBrk.Checked:=   (Flags and sfColBrk)   <> 0;
 cbAZonable.Checked:=  (Flags and sfZonable)  <> 0;
 cbAClipped.Checked:=  (Flags and sfClipped)  <> 0;
 cbAPushable.Checked:= (Flags and sfPushable) <> 0;
 cbALowCol.Checked:=   (Flags and sfLowCol)   <> 0;
 cbAStanding.Checked:= (Flags and sfFloorTst) <> 0;
 cbAHidden.Checked:=   (Flags and sfHidden)   <> 0;
 cbASprite.Checked:=   (Flags and sfSprite)   <> 0;
 cbACanFall.Checked:=  (Flags and sfCanFall)  <> 0;
 cbANoShadow.Checked:= (Flags and sfNoShadow) <> 0;
 cbABackgrnd.Checked:= (Flags and sfBackgrnd) <> 0;
 cbACarrier.Checked:=  (Flags and sfCarrier)  <> 0;
 cbAMiniZV.Checked:=   (Flags and sfMiniZV)   <> 0;
end;

function TfrSceneObj.SetStaticFlags(): Word;
begin
 Result:= 0;
 If cbAColObj.Checked    then Result:= Result or sfColObj;
 If cbAColBrk.Checked    then Result:= Result or sfColBrk;
 If cbAZonable.Checked   then Result:= Result or sfZonable;
 If cbAClipped.Checked   then Result:= Result or sfClipped;
 If cbAPushable.Checked  then Result:= Result or sfPushable;
 If cbALowCol.Checked    then Result:= Result or sfLowCol;
 If cbAStanding.Checked  then Result:= Result or sfFloorTst;
 If cbAHidden.Checked    then Result:= Result or sfHidden;
 If cbASprite.Checked    then Result:= Result or sfSprite;
 If cbACanFall.Checked   then Result:= Result or sfCanFall;
 If cbANoShadow.Checked  then Result:= Result or sfNoShadow;
 If cbABackgrnd.Checked  then Result:= Result or sfBackgrnd;
 If cbACarrier.Checked   then Result:= Result or sfCarrier;
 If cbAMiniZV.Checked    then Result:= Result or sfMiniZV;
end;

Procedure TfrSceneObj.GetBonusFlags(Bonus: Word; Prefix: String);
begin
 (FindComponent(Prefix+'Money')  as TCheckBox).Checked:= (bonus and bfMoney)    <> 0;
 (FindComponent(Prefix+'Life')   as TCheckBox).Checked:= (bonus and bfLife)     <> 0;
 (FindComponent(Prefix+'Magic')  as TCheckBox).Checked:= (bonus and bfMagic)    <> 0;
 (FindComponent(Prefix+'Key')    as TCheckBox).Checked:= (bonus and bfKey)      <> 0;
 (FindComponent(Prefix+'Clover') as TCheckBox).Checked:= (bonus and bfClover)   <> 0;
end;

Function TfrSceneObj.SetBonusFlags(Prefix: String): Word;
begin
 Result:= 0;
 If (FindComponent(Prefix+'Money') as TCheckBox).Checked then Result:= Result or bfMoney;
 If (FindComponent(Prefix+'Life') as TCheckBox).Checked then Result:= Result or bfLife;
 If (FindComponent(Prefix+'Magic') as TCheckBox).Checked then Result:= Result or bfMagic;
 If (FindComponent(Prefix+'Key') as TCheckBox).Checked then Result:= Result or bfKey;
 If (FindComponent(Prefix+'Clover') as TCheckBox).Checked then Result:= Result or bfClover;
end;



Procedure TfrSceneObj.ChangeSceneObj();
var PActor: ^TSceneActor;
begin
 paActorProp.Visible:= SelType = otActor;
 paPointProp.Visible:= SelType = otPoint;
 paZoneProp.Visible:=  SelType = otZone;
 lbTotal.Visible:= SelType <> otNone;
 seObjId.Visible:= SelType <> otNone;
 btActions.Visible:= SelType <> otNone;
 btObjFind.Visible:= SelType <> otNone;
 lbObjName.Visible:= SelType <> otNone;
 edObjName.Visible:= SelType <> otNone;
 case SelType of
   otNone:  lbObjType.Caption:= 'Nothing selected';
   otPoint: begin
              lbObjType.Caption:= 'Point';
              NoSpinChange:= True;
              seObjId.Value:= SelId;
              edObjName.Text:= VScene.Points[SelId].Name;
              seTX.Value:= VScene.Points[SelId].X;
              seTY.Value:= VScene.Points[SelId].Y;
              seTZ.Value:= VScene.Points[SelId].Z;
              NoSpinChange:= False;
            end;
   otZone:  begin
              lbObjType.Caption:= 'Zone';
              NoSpinChange:= True;
              seObjId.Value:= SelId;
              edObjName.Text:= VScene.Zones[SelId].Name;
              seZX.Value:= VScene.Zones[SelId].X1;
              seZY.Value:= VScene.Zones[SelId].Y1;
              seZZ.Value:= VScene.Zones[SelId].Z1;
              seZSX.Value:= VScene.Zones[SelId].X2 - VScene.Zones[SelId].X1;
              seZSY.Value:= VScene.Zones[SelId].Y2 - VScene.Zones[SelId].Y1;
              seZSZ.Value:= VScene.Zones[SelId].Z2 - VScene.Zones[SelId].Z1;
              cbZType.ItemIndex:= Byte(VScene.Zones[SelId].RealType);
              seZXChange(cbZType);
              NoSpinChange:= False;
              lbZDebug.Caption:=
                Format('Type: 0x%.4X', [VScene.Zones[SelId].ZType]) + #13
              + Format('Info 0: 0x%.8X', [VScene.Zones[SelId].Info[0]]) + #13
              + Format('Info 1: 0x%.8X', [VScene.Zones[SelId].Info[1]]) + #13
              + Format('Info 2: 0x%.8X', [VScene.Zones[SelId].Info[2]]) + #13
              + Format('Info 3: 0x%.8X', [VScene.Zones[SelId].Info[3]]) + #13
              + Format('Info 4: 0x%.8X', [VScene.Zones[SelId].Info[4]]) + #13
              + Format('Info 5: 0x%.8X', [VScene.Zones[SelId].Info[5]]) + #13
              + Format('Info 6: 0x%.8X', [VScene.Zones[SelId].Info[6]]) + #13
              + Format('Info 7: 0x%.8X', [VScene.Zones[SelId].Info[7]]) + #13
              + Format('Snap: 0x%.4X', [VScene.Zones[SelId].Snap]);
            end;
   otActor: begin
              PActor:= @(VScene.Actors[SelId]);
              if SelId = 0 then
                paActorProp.Height:= 85
              else
                paActorProp.Height:= 1300; //925;
              lbObjType.Caption:= 'Actor';
              NoSpinChange:= True;
              seObjId.Value:= SelId;
              edObjName.Text:= PActor^.Name;
              seAX.Value:= PActor^.X;
              seAY.Value:= PActor^.Y;
              seAZ.Value:= PActor^.Z;
              cbAMode.ItemIndex:= PActor^.CtrlMode;
              //seAEntity.Value:= PActor^.Entity;
              if PActor^.Entity < cbAEntity.Items.Count then begin
                cbAEntity.ItemIndex:= PActor^.Entity + 1;
                lbAEntity.Font.Color:= clWindowText;
              end
              else begin
                cbAEntity.ItemIndex:= -1;
                lbAEntity.Font.Color:= clRed;
              end;
              UpdateBodyAndAnimLists(PActor^.Entity);
              EnableBodyAndAnimLists(PActor^.Entity < cbAEntity.Items.Count);
              lbAEntity.Caption:= IntToStr(PActor^.Entity);
              seAAngle.Value:= SceneAngleToDegrees(PActor^.Angle);
              lbAAngle.Caption:= Format('= %d in Scene Units', [PActor^.Angle]);
              //seAAnim.Value:= Actor.Animation;
              SetAnimCombo(PActor^.Entity, PActor^.Anim);
              seAPower.Value:= PActor^.HitPower;
              seAArmour.Value:= PActor^.Armour;
              seALife.Value:= PActor^.LifePoints;
              seASpeed.Value:= PActor^.RotSpeed;
              cbACol.ItemIndex:= PActor^.TalkColor;
              //seABody.Value:= PActor^.Body;
              SetBodyCombo(PActor^.Entity, PActor^.Body);
              //seASprite.Value:= PActor^.SpriteEntry;
              if PActor^.Sprite < cbASprites.Items.Count then begin
                cbASprites.ItemIndex:= PActor^.Sprite;
                lbASprite.Font.Color:= clWindowText;
              end
              else begin
                cbASprites.ItemIndex:= -1;
                lbASprite.Font.Color:= clRed;
              end;
              lbASprite.Caption:= IntToStr(PActor^.Sprite);
              GetStaticFlags(PActor^.StaticFlags);
              GetBonusFlags(PActor^.BonusType,'cbA');
              seABonusAmnt.Value:= PActor^.BonusAmount;
              EnableActorControls(SelId);
              NoSpinChange:= False;
              lbADebug.Caption:=
                Format('Static Flags: 0x%.4X', [PActor^.StaticFlags]) + #13
              + Format('LBA2 Unknown: 0x%.4X', [PActor^.Unknown]) + #13
              + Format('LBA2 Body Flag: 0x%.2X', [PActor^.BodyAdd]) + #13
              + Format('Bonus Type: 0x%.4X', [PActor^.BonusType]) + #13
              + Format('Ctrl Unk: 0x%.2X', [PActor^.CtrlUnk]) + #13
              + Format('Info 0: 0x%.4X', [Word(PActor^.Info0)]) + #13
              + Format('Info 1: 0x%.4X', [Word(PActor^.Info1)]) + #13
              + Format('Info 2: 0x%.4X', [Word(PActor^.Info2)]) + #13
              + Format('Info 3: 0x%.4X', [Word(PActor^.Info3)]);
            end;
 end;
end;

procedure TfrSceneObj.InitSceneObj();
begin
  LoadcbAMode(LbaMode);
  LoadcbZType(LbaMode);
  Visible:= (ProgMode = pmScene) and (SceneTool in [stSelect, stHand]);
  //tsTracks.Caption:= 'Points (' + IntToStr(Length(VScene.Points)) + ')';
  EnableTrackControls(Length(VScene.Points) > 0);
  //tsActors.Caption:= 'Actors (' + IntToStr(Length(VScene.Actors)) + ')';
  EnableActorControls(0, Length(VScene.Actors) <= 0);
  //seASprite.MaxValue:= High(Sprites);
  //tsZones.Caption:= 'Zones (' + IntToStr(Length(VScene.Zones)) + ')';
  EnableZoneControls(Length(VScene.Zones) > 0);

  case SelType of
    otActor: seObjId.MaxValue:= High(VScene.Actors);
    otPoint: seObjId.MaxValue:= High(VScene.Points);
    otZone:  seObjId.MaxValue:= High(VScene.Zones);
  end;
  lbTotal.Caption:= '/ ' + IntToStr(seObjId.MaxValue);

  ChangeSceneObj();
end;

procedure TfrSceneObj.LoadcbAMode(Lba: Integer);
begin
  if Lba = 1 then
    cbAMode.Items.Text:= '0. No move'#13
                       + '1. Manual (controlled by the player)'#13
                       + '2. Follow Actor'#13
                       + '3. Move along track'#13
                       + '4. (unused)'#13
                       + '5. (unused)'#13
                       + '6. Follow Actor in X and Z'#13
                       + '7. Move randomly'
  else
    cbAMode.Items.Text:= '0. No move'#13
                       + '1. Manual (controlled by the player)'#13
                       + '2. Follow Actor'#13
                       + '3. (unused)'#13
                       + '4. (unused)'#13
                       + '5. (unused)'#13
                       + '6. Follow Actor in X and Z'#13
                       + '7. Move randomly'#13
                       + '8. Move along rail'#13
                       + '9. DIRMODE9 (unknown)'#13
                       + '10. DIRMODE10 (unknown)'#13
                       + '11. DIRMODE11 (unknown)'#13
                       + '12. DIRMODE12 (unknown)'#13
                       + '13. DIRMODE13 (unknown)';
end;

procedure TfrSceneObj.LoadcbZType(Lba: Integer);
begin
  if Lba = 1 then begin
    cbZType.Items.Text:= '0. Cube Zone (changes cube and Scene)'#13
                       + '1. Camera Zone (binds camera view)'#13
                       + '2. Sceneric Zone (for use in Life Script)'#13
                       + '3. Fragment Zone (sets disappearing Grid fragment)'#13
                       + '4. Bonus Zone (gives a bonus)'#13
                       + '5. Text Zone (displays a text message)'#13
                       + '6. Ladder Zone (the Hero can climb on it)';
    lbFragmentInfo.Caption:= 'This index is relative to the first Fragment Grid, starting with 0.';
  end else begin
    cbZType.Items.Text:= '0. Cube Zone (changes cube and Scene)'#13
                       + '1. Camera Zone (binds camera view)'#13
                       + '2. Sceneric Zone (for use in Life Script)'#13
                       + '3. Fragment Zone (sets disappearing Grid fragment)'#13
                       + '4. Bonus Zone (gives a bonus)'#13
                       + '5. Text Zone (displays a text message)'#13
                       + '6. Ladder Zone (the Hero can climb on it)'#13
                       + '7. Conveyor zone (creates a conveyor belt)'#13
                       + '8. Spike Zone (hurts when stood on)'#13
                       + '9. Rail Zone (changes Rail)';
    lbFragmentInfo.Caption:= 'This index is relative to the Fragment Index param of the Grid.';
  end;
end;

procedure TfrSceneObj.seTXChange(Sender: TObject);
var x, y, z: Integer;
begin
 if NoSpinChange then Exit;
 if seTX.TryReadValue(x) and seTY.TryReadValue(y) and seTZ.TryReadValue(z)
 then begin
   SceneUndoSetPoint(VScene, UNDO_GROUP_POINT_X
     + ChoiceId([Sender=seTX, Sender=seTY, Sender=seTZ], UNDO_GROUP_NONE),
     otPoint, SelId);
   SetTrack(SelId, x, y, z);
 end;
end;

procedure TfrSceneObj.seAXChange(Sender: TObject);
var x, y, z: Integer;
begin
 If NoSpinChange then Exit;
 If seAX.TryReadValue(x) and seAY.TryReadValue(y) and seAZ.TryReadValue(z) then begin
   SceneUndoSetPoint(VScene, UNDO_GROUP_ACTOR_X
     + ChoiceId([Sender=seAX, Sender=seAY, Sender=seAZ], UNDO_GROUP_NONE),
     otActor, SelId);
   SetActor(SelId, x, y, z);
 end
end;

procedure TfrSceneObj.seObjIdChange(Sender: TObject);
var nid: Integer;
begin
 if NoSpinChange then Exit;
 if seObjId.TryReadValue(nid) then begin
   SelectObject(SelType, nid);
   acDelete.Enabled:= (SelType <> otActor) or (nid > 0);
   if Sett.Controls.SObjAutoFind then btObjFindClick(nil);
 end;
end;

procedure TfrSceneObj.edObjNameChange(Sender: TObject);
begin
  if NoSpinChange then Exit;
  case SelType of
    otActor: VScene.Actors[SelId].Name:= edObjName.Text;
    otZone:  VScene.Zones[SelId].Name:= edObjName.Text;
    otPoint: VScene.Points[SelId].Name:= edObjName.Text;
  end;  
end;

procedure TfrSceneObj.UpdateBodyAndAnimLists(entity: Integer);
begin
 GetBodiesAndAnims(entity, cbABody.Items, cbAAnim.Items);
 UpdateComboBox(cbABody);
 UpdateComboBox(cbAAnim);
end;

procedure TfrSceneObj.EnableBodyAndAnimLists(Ena: Boolean);
begin
 lbABodyT.Enabled:= Ena;
 lbABody.Enabled:= Ena;
 cbABody.Enabled:= Ena;
 lbAAnimT.Enabled:= Ena;
 lbAAnim.Enabled:= Ena;
 cbAAnim.Enabled:= Ena;
end;

procedure TfrSceneObj.cbAModeChange(Sender: TObject);
var temp: Integer;
begin
 if NoSpinChange then Exit;
 if Sender is TfrBetterSpin then begin
   if (Sender as TfrBetterSpin).TryReadValue(temp) then begin
     SceneUndoSetPoint(VScene,
       UNDO_GROUP_ACTOR_CL + ChoiceId([Sender=seAClip[0], Sender=seAClip[1],
         Sender=seAClip[2], Sender=seAClip[3], Sender=seAFollow, Sender=seARandom,
         Sender=seAPower, Sender=seAArmour,
         Sender=seALife, Sender=seAAngle, Sender=seASpeed, Sender=seABonusAmnt],
         UNDO_GROUP_NONE),
       otActor, SelId);

     If Sender = seAAngle then begin
       VScene.Actors[SelId].Angle:= DegreesToSceneAngle(temp);
       lbAAngle.Caption:= Format('= %d in Scene Units', [VScene.Actors[SelId].Angle]);
       RedrawActor(SelId, True);
       RedrawActor(SelId, False); //Force redraw the arrow too
     end
     //else if Sender = seAAnim then VScene.Actors[SelId].Animation:= temp
     else if Sender = seAPower then VScene.Actors[SelId].HitPower:= temp
     else if Sender = seAArmour then VScene.Actors[SelId].Armour:= temp
     else if Sender = seALife then VScene.Actors[SelId].LifePoints:= temp
     else if Sender = seABonusAmnt then VScene.Actors[SelId].BonusAmount:= temp
     else if Sender = seASpeed then VScene.Actors[SelId].RotSpeed:= temp
     //else if Sender = seAEntity then VScene.Actors[SelId].Entity:= temp
     //else if Sender = seABody then VScene.Actors[SelId].Body:= temp
     //else if Sender = seASprite then ChangeActorSprite(SelId, temp)
     else if Sender = seAClip[0] then VScene.Actors[SelId].Info0:= temp
     else if (Sender = seAClip[1]) then
       VScene.Actors[SelId].Info1:= temp
     else if Sender = seAClip[2] then VScene.Actors[SelId].Info2:= temp
     else if (Sender = seAClip[3]) or (Sender = seARandom) then
       VScene.Actors[SelId].Info3:= temp
     else if Sender = seAFollow then
       VScene.Actors[SelId].FollowId:= temp;

     if (Sender = seAClip[0]) or (Sender = seAClip[1])
     or (Sender = seAClip[2]) or (Sender = seAClip[3]) then
       RedrawActor(SelId, False);
   end else
     if Sender = seAAngle then lbAAngle.Caption:= '';
 end
 else begin //ComboBox & CheckBox
   SceneUndoSetPoint(VScene,
     UNDO_GROUP_ACTOR_TC + ChoiceId([Sender=cbACol, Sender=cbAEntity,
       Sender=cbABody, Sender=cbAAnim, Sender=cbASprite,
       (Sender=cbAMoney) or (Sender=cbALife) or (Sender=cbAMagic)
        or (Sender=cbAKey) or (Sender=cbAClover)], UNDO_GROUP_NONE),
     otActor, SelId);

   if Sender = cbAMode then begin
     VScene.Actors[SelId].CtrlMode:= cbAMode.ItemIndex;
     EnableActorControls(SelId);
   end
   else if Sender = cbACol then VScene.Actors[SelId].TalkColor:= cbACol.ItemIndex
   else if Sender = cbAEntity then begin
     VScene.Actors[SelId].Entity:= cbAEntity.ItemIndex - 1;
     UpdateBodyAndAnimLists(VScene.Actors[SelId].Entity);
     SetBodyCombo(VScene.Actors[SelId].Entity, VScene.Actors[SelId].Body);
     SetAnimCombo(VScene.Actors[SelId].Entity, VScene.Actors[SelId].Anim);
     lbAEntity.Caption:= IntToStr(VScene.Actors[SelId].Entity);
   end
   else if Sender = cbABody then begin
     If cbABody.ItemIndex = 0 then begin
       If NumberDialog('Custom Body value', 'Enter value between 0 and 255:', 255, temp)
       then
         VScene.Actors[SelId].Body:= temp;
       SetBodyCombo(VScene.Actors[SelId].Entity, VScene.Actors[SelId].Body);
     end
     else begin
       VScene.Actors[SelId].Body:=
         ActorEntities[VScene.Actors[SelId].Entity].Bodies[cbABody.ItemIndex - 1].VirtualIndex;
       lbABody.Caption:= IntToStr(VScene.Actors[SelId].Body);
       lbABody.Font.Color:= clWindowText;
     end;
   end
   else if Sender = cbAAnim then begin
     If cbAAnim.ItemIndex = 0 then begin
       If NumberDialog('Custom Animation value', 'Enter value between 0 and 255:', 255, temp)
       then
         VScene.Actors[SelId].Anim:= temp;
       SetAnimCombo(VScene.Actors[SelId].Entity, VScene.Actors[SelId].Anim);
     end
     else begin
       VScene.Actors[SelId].Anim:=
         ActorEntities[VScene.Actors[SelId].Entity].Anims[cbAAnim.ItemIndex - 1].VirtualIndex;
       lbAAnim.Caption:= IntToStr(VScene.Actors[SelId].Anim);
       lbAAnim.Font.Color:= clWindowText;
     end;
   end
   else if Sender = cbASprites then begin
     VScene.Actors[SelId].Sprite:= cbASprites.ItemIndex;
     lbASprite.Caption:= IntToStr(VScene.Actors[SelId].Sprite);
     lbASprite.Font.Color:= clWindowText;
     ChangeActorSprite(SelId, VScene.Actors[SelId].Sprite);
   end else
     VScene.Actors[SelId].BonusType:= SetBonusFlags('cbA');
 end;
 
 SetSceneModified();
end;

procedure TfrSceneObj.cbAColDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
 (Control as TComboBox).Canvas.Brush.Color:= clWindow;
 (Control as TComboBox).Canvas.FillRect(Rect);
 if LbaMode = 1 then begin
   case Index of
      0: (Control as TComboBox).Canvas.Brush.Color:= clWhite; //pal 12
      1: (Control as TComboBox).Canvas.Brush.Color:= clWhite; //pal 28
      2: (Control as TComboBox).Canvas.Brush.Color:= $87af63; //pal 44
      3: (Control as TComboBox).Canvas.Brush.Color:= $abd7e7; //pal 60
      4: (Control as TComboBox).Canvas.Brush.Color:= $cba767; //pal 76
      5: (Control as TComboBox).Canvas.Brush.Color:= $633fff; //pal 92
      6: (Control as TComboBox).Canvas.Brush.Color:= $93bbeb; //pal 108
      7: (Control as TComboBox).Canvas.Brush.Color:= $8fcb87; //pal 124
      8: (Control as TComboBox).Canvas.Brush.Color:= $6f8fb3; //pal 140
      9: (Control as TComboBox).Canvas.Brush.Color:= $77e3ff; //pal 156
     10: (Control as TComboBox).Canvas.Brush.Color:= $c3c34f; //pal 172
     11: (Control as TComboBox).Canvas.Brush.Color:= $a39f77; //pal 188
     12: (Control as TComboBox).Canvas.Brush.Color:= $8bb7b7; //pal 204
     13: (Control as TComboBox).Canvas.Brush.Color:= $c7bfd3; //pal 220
     14: (Control as TComboBox).Canvas.Brush.Color:= $cf93ff; //pal 236
     15: (Control as TComboBox).Canvas.Brush.Color:= $cfd3d3; //pal 252
   end;
 end else begin //LBA 2
   case Index of
      0: (Control as TComboBox).Canvas.Brush.Color:= $df007f; //pal 12
      1: (Control as TComboBox).Canvas.Brush.Color:= $3f5b83; //pal 28
      2: (Control as TComboBox).Canvas.Brush.Color:= $abdbeb; //pal 44
      3: (Control as TComboBox).Canvas.Brush.Color:= $b7bbbb; //pal 60
      4: (Control as TComboBox).Canvas.Brush.Color:= $6367d7; //pal 76
      5: (Control as TComboBox).Canvas.Brush.Color:= $93bbfb; //pal 92
      6: (Control as TComboBox).Canvas.Brush.Color:= $6fc7f7; //pal 108
      7: (Control as TComboBox).Canvas.Brush.Color:= $7bab9b; //pal 124
      8: (Control as TComboBox).Canvas.Brush.Color:= $7fb777; //pal 140
      9: (Control as TComboBox).Canvas.Brush.Color:= $8ba743; //pal 156
     10: (Control as TComboBox).Canvas.Brush.Color:= $b3af47; //pal 172
     11: (Control as TComboBox).Canvas.Brush.Color:= $a39f77; //pal 188
     12: (Control as TComboBox).Canvas.Brush.Color:= $cba767; //pal 204
     13: (Control as TComboBox).Canvas.Brush.Color:= $af9ba3; //pal 220
     14: (Control as TComboBox).Canvas.Brush.Color:= $a3a7b3; //pal 236
     15: (Control as TComboBox).Canvas.Brush.Color:= $ffffff; //pal 252
   end;
 end;
 InflateRect(Rect,-2,-2);
 (Control as TComboBox).Canvas.FillRect(Rect);
 (Control as TComboBox).Canvas.Brush.Style:= bsClear;
 (Control as TComboBox).Canvas.Font.Color:= clBlack;
 (Control as TComboBox).Canvas.TextOut(Rect.Left+1,Rect.Top-2,IntToStr(Index));
 (Control as TComboBox).Canvas.Brush.Style:= bsSolid;
 (Control as TComboBox).Canvas.Rectangle(0,0,0,0); //Workaround for focus rect problem
end;

procedure TfrSceneObj.cbAStaticFlagChange(Sender: TObject);
begin
 if NoSpinChange then Exit;
 VScene.Actors[SelId].StaticFlags:= SetStaticFlags();
 VScene.Actors[SelId].IsSprite:= (VScene.Actors[SelId].StaticFlags and sfSprite) <> 0;
 EnableActorControls(SelId);
 if Sender = cbASprite then
   ChangeActorSprite(SelId, VScene.Actors[SelId].Sprite);
 SetSceneModified();
end;

procedure TfrSceneObj.btActionsClick(Sender: TObject);
var pt: TPoint;
begin
  pt:= btActions.ClientToScreen(Point(0, btActions.Height));
  abActions.Popup(pt.X, pt.Y);
end;

procedure TfrSceneObj.seZXChange(Sender: TObject);
var x, y, z, sx, sy, sz: Integer;
begin
 if Sender = cbZType then begin
   pcZType.ActivePageIndex:= cbZType.ItemIndex;
   pcZTypeChange(Self);
 end;
 if NoSpinChange then Exit;
 if seZX.TryReadValue(x) and seZY.TryReadValue(y) and seZZ.TryReadValue(z)
 and seZSX.TryReadValue(sx) and seZSY.TryReadValue(sy) and seZSZ.TryReadValue(sz)
 then begin
   if x + sx > High(SmallInt) then seZX.Value:= High(SmallInt) - sx //Avoid range check error near screen edges
   else if y + sy > High(SmallInt) then seZY.Value:= High(SmallInt) - sy //Fix the value and exit, because it will call the function again automatically
   else if z + sz > High(SmallInt) then seZZ.Value:= High(SmallInt) - sz
   else begin
     SceneUndoSetPoint(VScene, UNDO_GROUP_ZONE_X
       + ChoiceId([Sender=seZX, Sender=seZY, Sender=seZZ, Sender=seZSX, Sender=seZSY,
                   Sender=seZSZ], UNDO_GROUP_NONE),
       otZone, SelId);
     SetZone(SelId, x, y, z, sx + x, sy + y, sz + z, TZoneType(cbZType.ItemIndex));
   end;
 end;
end;

procedure TfrSceneObj.pcClipModeChange(Sender: TObject);
begin
  case pcClipMode.ActivePageIndex of
    0: begin
         seAClip[0].Value:= VScene.Actors[SelId].Info0;
         seAClip[1].Value:= VScene.Actors[SelId].Info1;
         seAClip[2].Value:= VScene.Actors[SelId].Info2;
         seAClip[3].Value:= VScene.Actors[SelId].Info3;
       end;
    1: begin
         seAFollow.MaxValue:= IfThen(LbaMode = 1, 255, 32767); 
         seAFollow.Value:= VScene.Actors[SelId].FollowId;
       end;
    2: seARandom.Value:= VScene.Actors[SelId].Info3;
  end;  
end;

procedure TfrSceneObj.pcZTypeChange(Sender: TObject);
var a: Integer;
begin
 case pcZType.ActivePageIndex of
   0: begin
        seZ0TargetId.Value:= VScene.Zones[SelId].TargetCube;
        seZ0X.Value:= VScene.Zones[SelId].TargetPoint.x;
        seZ0Y.Value:= VScene.Zones[SelId].TargetPoint.y;
        seZ0Z.Value:= VScene.Zones[SelId].TargetPoint.z;
      end;
   1: begin
        seZ1X.Value:= VScene.Zones[SelId].TargetPoint.x;
        seZ1Y.Value:= VScene.Zones[SelId].TargetPoint.y;
        seZ1Z.Value:= VScene.Zones[SelId].TargetPoint.z;
      end;
   2: seZ2ZoneId.Value:= VScene.Zones[SelId].VirtualID;
   3: begin
        seZ3GridId.Value:= Byte(VScene.Zones[SelId].Info[0]);
        cbZ3Fragment.Items.Clear();
        cbZ3Fragment.Items.Add('None'); //Can't assign Main Grid
        for a:= 1 to High(LdMaps) do
          cbZ3Fragment.Items.Add(LdMaps[a].Name);
        UpdateComboBox(cbZ3Fragment);
        //cbZ3Fragment.Items.Assign(fmMain.cbFragment.Items);
        //if cbZ3Fragment.Items.Count > 0 then
        //  cbZ3Fragment.Items[0]:= 'None'; //Can't assign Main Grid
        cbZ3Fragment.ItemIndex:= cbZ3Fragment.Items.IndexOf(VScene.Zones[SelId].FragmentName);
        if cbZ3Fragment.ItemIndex < 0 then cbZ3Fragment.ItemIndex:= 0;
      end;
   4: begin
        GetBonusFlags(VScene.Zones[SelId].BonusType, 'cbZ4');
        seZ4Amount.Value:= Word(VScene.Zones[SelId].BonusQuant);
        cbZ4Enabled.Checked:= VScene.Zones[Selid].BonusEna;
      end;
   5: seZ5TextId.Value:= VScene.Zones[SelId].TextID;
   9: seZ9RailId.Value:= VScene.Zones[SelId].Snap;
 end;
end;

procedure TfrSceneObj.seZ0TargetIdChange(Sender: TObject);
var temp: Integer;
begin
 if NoSpinChange then Exit;
 if Sender is TfrBetterSpin then begin
   if (Sender as TfrBetterSpin).TryReadValue(temp) then begin

     SceneUndoSetPoint(VScene, UNDO_GROUP_ZONE_0TID
       + ChoiceId([Sender=seZ0TargetId, Sender=seZ0X, Sender=seZ0Y, Sender=seZ0Z,
                   Sender=seZ1X, Sender=seZ1Y, Sender=seZ1Z,
                   Sender=seZ2ZoneId, Sender=seZ3GridId, Sender=seZ4Amount,
                   Sender=seZ5TextId], UNDO_GROUP_NONE),
       otZone, SelId);

     case pcZType.ActivePageIndex of
       0: if Sender = seZ0TargetId then VScene.Zones[SelId].TargetCube:= temp
          else if Sender = seZ0X then VScene.Zones[SelId].TargetPoint.x:= temp
          else if Sender = seZ0Y then VScene.Zones[SelId].TargetPoint.y:= temp
          else if Sender = seZ0Z then VScene.Zones[SelId].TargetPoint.z:= temp;
       1: if Sender = seZ1X then VScene.Zones[SelId].TargetPoint.x:= temp
          else if Sender = seZ1Y then VScene.Zones[SelId].TargetPoint.y:= temp
          else if Sender = seZ1Z then VScene.Zones[SelId].TargetPoint.z:= temp;
       2: if Sender = seZ2ZoneId then begin
            VScene.Zones[SelId].VirtualID:= Word(temp);
            ComputeZoneDispInfo(VScene.Zones[SelId], SelId);
            RedrawZone(SelId, True);
            RedrawZone(SelId, False);
          end;
       3: if Sender = seZ3GridId then VScene.Zones[SelId].Info[0]:= Word(temp);
       4: if Sender = seZ4Amount then VScene.Zones[SelId].BonusQuant:= Word(temp);
       5: if Sender = seZ5TextId then VScene.Zones[SelId].TextID:= temp;
       9: if Sender = seZ9RailId then VScene.Zones[SelId].Snap:= temp;
     end;
   end;
 end
 else if Sender is TComboBox then begin
   if cbZ3Fragment.ItemIndex > 0 then
     VScene.Zones[SelId].FragmentName:= LdMaps[cbZ3Fragment.ItemIndex].Name
   else
     VScene.Zones[SelId].FragmentName:= '';
 end
 else if pcZType.ActivePageIndex = 4 then begin
   if Sender = cbZ4Enabled then
     VScene.Zones[SelId].BonusEna:= cbZ4Enabled.Checked
   else
     VScene.Zones[SelId].BonusType:= SetBonusFlags('cbZ4');
 end;
 SetSceneModified();
end;

procedure TfrSceneObj.btZ0CopyClick(Sender: TObject);
begin
 if Sender = btZ0Copy then CopyCoords(seZ0X, seZ0Y, seZ0Z)
 else if Sender = btZ0Paste then PasteCoords(seZ0X, seZ0Y, seZ0Z)
 else if Sender = btZCopy then CopyCoords(seZX, seZY, seZZ)
 else if Sender = btZPaste then PasteCoords(seZX, seZY, seZZ)
 else if Sender = btZSCopy then CopyCoords(seZSX, seZSY, seZSZ)
 else if Sender = btZSPaste then PasteCoords(seZSX, seZSY, seZSZ)
end;

procedure TfrSceneObj.btObjFindClick(Sender: TObject);
begin
  case SelType of
    otActor: HighlightActor(SelId);
    otPoint: HighlightTrack(SelId);
     otZone: HighlightZone(SelId);
  end;   
end;

procedure TfrSceneObj.btSelectClick(Sender: TObject);
var tType: TObjType;
    tId: Integer;
begin
  tType:= SelType;
  tId:= SelId;
  if TfmSelect.ShowSceneSelector(tType, tId) then
    SelectObject(tType, tId);
end;

procedure TfrSceneObj.cbAAutoFindMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 //Form1.btHandMouseMove(Sender, Shift, X, Y); //Display a hint
end;

procedure TfrSceneObj.SetBodyCombo(entity, body: Integer);
begin
 lbABody.Font.Color:= clWindowText;
 if body = 255 then
   lbABody.Caption:= '-1'
 else
   lbABody.Caption:= IntToStr(body);
 cbABody.ItemIndex:= 0;
 if (entity >= 0) and (entity <= High(ActorEntities)) then begin
   cbABody.ItemIndex:= FindBodyVirtualIndex(ActorEntities[entity].Bodies, body) + 1;
   if cbABody.ItemIndex < 1 then
     lbABody.Font.Color:= clRed; //set body index is out of the list
 end;
end;

procedure TfrSceneObj.SetAnimCombo(entity, anim: Integer);
begin
 lbAAnim.Font.Color:= clWindowText;
 lbAAnim.Caption:= IntToStr(anim);
 cbAAnim.ItemIndex:= 0;
 if (entity >= 0) and (entity <= High(ActorEntities)) then begin
   cbAAnim.ItemIndex:= FindAnimVirtualIndex(ActorEntities[entity].Anims, anim) + 1;
   if cbAAnim.ItemIndex < 1 then
     lbAAnim.Font.Color:= clRed; //set anim index is out of the list
 end;
end;

procedure TfrSceneObj.acAutoFindExecute(Sender: TObject);
begin
  Sett.Controls.SObjAutoFind:= acAutoFind.Checked;
end;

procedure TfrSceneObj.acCloneExecute(Sender: TObject);
begin
  if SelType = otActor then begin
    if Length(VScene.Actors) < 256 then begin
      SceneUndoSetPoint(VScene);
      SetLength(VScene.Actors, Length(VScene.Actors) + 1);
      VScene.Actors[High(VScene.Actors)]:= VScene.Actors[SelId];
      VScene.Actors[High(VScene.Actors)].DispInfo.Sprite:= nil; //to create a new instance
      SetActor(High(VScene.Actors), VScene.Actors[SelId].X, VScene.Actors[SelId].Y,
        VScene.Actors[SelId].Z);
      SelectObject(otActor, High(VScene.Actors));
    end else
      WarningMsg('No more Actors can be created!');
  end
  else if SelType = otPoint then begin
    if Length(VScene.Points) < 256 then begin
      SceneUndoSetPoint(VScene);
      SetLength(VScene.Points, Length(VScene.Points) + 1);
      VScene.Points[High(VScene.Points)]:= VScene.Points[SelId];
      SetTrack(High(VScene.Points), VScene.Points[SelId].X, VScene.Points[SelId].Y,
        VScene.Points[SelId].Z);
      SelectObject(otPoint, High(VScene.Points));
    end else
      WarningMsg('No more Points can be created!');
  end
  else if SelType = otZone then begin
    SceneUndoSetPoint(VScene);
    SetLength(VScene.Zones, Length(VScene.Zones) + 1);
    VScene.Zones[High(VScene.Zones)]:= VScene.Zones[SelId];
    SetZone(High(VScene.Zones),VScene.Zones[SelId].X1, VScene.Zones[SelId].Y1,
      VScene.Zones[SelId].Z1, VScene.Zones[SelId].X2, VScene.Zones[SelId].Y2,
      VScene.Zones[SelId].Z2, VScene.Zones[SelId].RealType);
    SelectObject(otZone, High(VScene.Zones));
  end;
end;

procedure TfrSceneObj.acDeleteExecute(Sender: TObject);
begin
  if SelType = otActor then begin
    if SelId = 0 then
      ErrorMsg('The Hero cannot be deleted!')
    else begin
      SceneUndoSetPoint(VScene);
      SelType:= otNone;
      DeleteActor(SelId);
    end;
  end  
  else if SelType = otPoint then begin
    SceneUndoSetPoint(VScene);
    SelType:= otNone;
    DeleteTrack(SelId);
  end
  else if SelType = otZone then begin
    SceneUndoSetPoint(VScene);
    SelType:= otNone;
    DeleteZone(SelId);
  end;
  InitSceneObj();
end;

procedure TfrSceneObj.acNewExecute(Sender: TObject);
begin
  if SelType = otActor then
    CreateActor(0, 0, 0)
  else if SelType = otPoint then begin
    if Length(VScene.Points) < 256 then begin
      SceneUndoSetPoint(VScene);
      SetLength(VScene.Points, Length(VScene.Points) + 1);
      SetTrack(High(VScene.Points), 0, 0, 0);
      SelectObject(otPoint, High(VScene.Points));
    end else
      WarningMsg('No more Points can be created!');
  end
  else if SelType = otZone then begin
    SceneUndoSetPoint(VScene);
    SetLength(VScene.Zones, Length(VScene.Zones) + 1);
    SetZone(High(VScene.Zones), 0, 0, 0, 512, 256, 512, ztCube);
    SelectObject(otZone,High(VScene.Zones));
  end;
end;

procedure TfrSceneObj.acScriptsExecute(Sender: TObject);
begin
  fmScriptEd.OpenScripts(SelId);
  fmScriptEd.BringToFront();
end;

procedure TfrSceneObj.acTemplateExecute(Sender: TObject);
begin
  if SelType = otActor then
    SaveActorToTemplate(VScene.Actors[SelId]);
end;

procedure TfrSceneObj.BitBtn1Click(Sender: TObject);
begin
 InfoMsg('Here you can define Fragment for the Automatic Fragment Creation feature in Builder. This value can be saved in a Scenario only!'#13#13
       + 'This feature makes Designer to automatically add necessary Fragments after Grids in the HQR file '
       + 'based on the specific Scenario data (this value and SET_GRM parameter value in the Scripts).'#13#13
       + 'Without that you would have to add Fragments manually and plan everything to set up Fragment indexes '
       + 'correctly during writing the Scripts and editing Scenes.'#13#13
       + 'Manual Fragment setting up is still possible of course (in such case this value will be ignored).');
end;

end.
