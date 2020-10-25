unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ShellApi, DePack, Editing, FileCtrl, Math,
  CommCtrl, Projects, ActnList, ToolWin, Building, Settings, ImgList,
  ExtCtrls, StdCtrls, CompMods, EasyListView;

type
  TListView = class(ComCtrls.TListView)
  private
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
  end;

  TEasyListView = class(EasyListview.TEasyListView)
  public
    procedure SetItemCount(NewCount: Integer);
  end;

  TCustomViewReportItem = class(TEasyViewReportItem)
  public
    procedure PaintBefore(Item: TEasyItem; Column: TEasyColumn; const Caption: WideString;
      ACanvas: TCanvas; RectArray: TEasyRectArrayObject; var Handled: Boolean); override;
  end;

  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mOpen: TMenuItem;
    mSave: TMenuItem;
    mSaveAs: TMenuItem;
    N1: TMenuItem;
    Actions1: TMenuItem;
    mCompile: TMenuItem;
    N4: TMenuItem;
    mProjectOpts: TMenuItem;
    mEdit: TMenuItem;
    mSettings: TMenuItem;
    mDropExisting: TPopupMenu;
    Droppingonanexistingline1: TMenuItem;
    N5: TMenuItem;
    mDropReplaceLine: TMenuItem;
    mDropInsertLine: TMenuItem;
    mNew: TMenuItem;
    mListMenu: TPopupMenu;
    mClearCell: TMenuItem;
    mClearRows: TMenuItem;
    mDeleteRows: TMenuItem;
    mMoveToTop: TMenuItem;
    N6: TMenuItem;
    mMoveUp: TMenuItem;
    mMoveDown: TMenuItem;
    mMoveToBottom: TMenuItem;
    mSetBlank: TMenuItem;
    N7: TMenuItem;
    dlOpen: TOpenDialog;
    dlSave: TSaveDialog;
    tbMain: TToolBar;
    ToolButton1: TToolButton;
    ActionList1: TActionList;
    aOpenProject: TAction;
    aNewProject: TAction;
    aSaveProject: TAction;
    aSaveProjectAs: TAction;
    aProjectOptions: TAction;
    aBuildProject: TAction;
    N8: TMenuItem;
    mManualEdit: TMenuItem;
    mNewMenu: TPopupMenu;
    mAddRowNew: TMenuItem;
    mInsertRow: TMenuItem;
    aAddLine: TAction;
    aInsertLine: TAction;
    aSettings: TAction;
    mDropFillColumn: TMenuItem;
    N9: TMenuItem;
    MenuImages: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    aUndo: TAction;
    aRedo: TAction;
    N3: TMenuItem;
    Deleteselectedrows1: TMenuItem;
    N10: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    aDelSelected: TAction;
    mFragment: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    mOpenRecent: TMenuItem;
    paMain: TPanel;
    paFragments: TPanel;
    Label1: TLabel;
    lvFrags: TListView;
    spFragments: TSplitter;
    lvGrids: TListView;
    sbMain: TStatusBar;
    N2: TMenuItem;
    mRowDesc: TMenuItem;
    mDropAddLine: TMenuItem;
    mAddRow: TMenuItem;
    mSelBlank: TMenuItem;
    mmTest: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure lvGridsDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure lvGridsCustomDraw(Sender: TCustomListView; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure lvGridsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mDropInsertLineClick(Sender: TObject);
    procedure mClearCellClick(Sender: TObject);
    procedure lvGridsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mMoveToTopClick(Sender: TObject);
    procedure lvGridsResize(Sender: TObject);
    procedure aProjectOptionsClick(Sender: TObject);
    procedure mSettingsClick(Sender: TObject);
    procedure aOpenProjectClick(Sender: TObject);
    procedure aSaveProjectClick(Sender: TObject);
    procedure aSaveProjectAsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aNewProjectExecute(Sender: TObject);
    procedure aBuildProjectExecute(Sender: TObject);
    procedure aAddLineExecute(Sender: TObject);
    procedure aSettingsExecute(Sender: TObject);
    procedure aUndoExecute(Sender: TObject);
    procedure aRedoExecute(Sender: TObject);
    procedure aDelSelectedExecute(Sender: TObject);
    procedure mEditClick(Sender: TObject);
    procedure mManualEditClick(Sender: TObject);
    procedure mOpenRecentProjectClick(Sender: TObject);
    procedure spFragmentsMoved(Sender: TObject);
    procedure lvGridsDblClick(Sender: TObject);
    procedure mRowDescClick(Sender: TObject);
    procedure lvGridsEnter(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    lvTest: TEasyListView;
    procedure lvGridsItemGetCaption(Sender: TCustomEasyListview;
      Item: TEasyItem; Column: Integer; var Caption: WideString);
    procedure lvGridsItemCustomView(Sender: TCustomEasyListview;
      Item: TEasyItem; ViewStyle: TEasyListStyle; var View: TEasyViewItemClass);  
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure AppException(Sender: TObject; E: Exception);
    Procedure AppShowHint(var HintStr: String; var CanShow: Boolean;
     var HintInfo: THintInfo);
    procedure WMDropFiles(hDrop: THandle; hWindow: HWnd);
    procedure RefreshRecentMenu();
    procedure AddToRecent(path: String);
  end;

var
  fmMain: TfmMain;

function ProjectSaveAs(): Boolean;

implementation

uses Manual, Utils, Utils_Graph, ProgBar;

{$R *.dfm}

//Poprawka do TListView (by Tocbac & Pawe³ Maniawski, mod by Zink)
procedure TListView.WMNotify(var Message: TWMNotify);
var Item: Integer;
    NewWidth: LongInt;
    NMHdr: THDNotify;
begin
 fmMain.mmTest.Lines.Add(IntToStr(Message.NMHdr^.code));
 if ((Message.NMHdr^.code = HDN_ITEMCHANGEDW) or
     (Message.NMHdr^.code = HDN_ITEMCHANGEDA)) then begin
   Item := PHDNotify(Pointer(Message.NMHdr))^.Item;
   NewWidth := ListView_GetColumnWidth(Handle, Item);
   if ((Column[Item].MinWidth > 0) and (NewWidth < Column[Item].MinWidth)) then
     NewWidth := Column[Item].MinWidth;
   if ((Column[Item].MaxWidth > 0) and (NewWidth > Column[Item].MaxWidth)) then
     NewWidth := Column[Item].MaxWidth;
   Column[Item].Width := NewWidth;
 end;

 //On-the-fly updating while resizing columns:
 if ((Message.NMHdr^.code = HDN_TRACKW) or
     (Message.NMHdr^.code = HDN_TRACKA)) then begin
   Item := PHDNotify(Pointer(Message.NMHdr))^.Item;
   NewWidth := PHDNotify(Pointer(Message.NMHdr))^.PItem^.cxy;
   if ((Column[Item].MinWidth > 0) and (NewWidth < Column[Item].MinWidth)) then
     NewWidth := Column[Item].MinWidth;
   if ((Column[Item].MaxWidth > 0) and (NewWidth > Column[Item].MaxWidth)) then
     NewWidth := Column[Item].MaxWidth;
   Column[Item].Width := NewWidth;
 end else
   inherited;
end;

procedure TListView.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  ListViewLastColAutoSize(Self);
  inherited;
end;

procedure TEasyListView.SetItemCount(NewCount: Integer);
var sign, a: Integer;
begin
 sign:= NewCount - Items.Count;
 if sign <> 0 then begin
   BeginUpdate();
   try
     if sign > 0 then
       for a:= Items.Count + 1 to NewCount do
         Items.AddVirtual()
     else
       for a:= Items.Count - 1 downto NewCount do
         Items.Delete(a, False);
   finally
     EndUpdate();
   end;
 end;
end;

procedure TCustomViewReportItem.PaintBefore(Item: TEasyItem; Column: TEasyColumn;
  const Caption: WideString; ACanvas: TCanvas; RectArray: TEasyRectArrayObject;
  var Handled: Boolean);
var r: TRect;
    a, b: Integer;
    col: TEasyColumns;
begin
 if Column.Index = 0 then begin
   r:= Item.ViewRect;
   r.Right:= Item.OwnerListview.ClientRect.Right; //Workaround for a bug - before the first resize ViewRect does not account for vertical scrollbar!
   col:= (Item.OwnerListview as TEasyListView).Header.Columns;
   ACanvas.Pen.Color:= $E0E0E0;
   ACanvas.Pen.Style:= psSolid;
   ACanvas.MoveTo(r.Left, r.Bottom - 1);
   ACanvas.LineTo(r.Right, r.Bottom - 1);
   b:= r.Left;
   for a:= 0 to col.Count - 2 do begin
     Inc(b, col[a].Width);
     ACanvas.MoveTo(b, r.Top);
     ACanvas.LineTo(b, r.Bottom);
   end;
   if Item.OwnerListview.Focused and Item.Focused then begin
     ACanvas.Brush.Color:= (Item.OwnerListview as TEasyListView).Color;
     ACanvas.Font.Color:= clBlack;
     r.Bottom:= r.Bottom - 1;
     DrawFocusRect(ACanvas.Handle, r)
   end;
   if Item.Selected then begin
     tutaj
   end;

   //ACanvas.Brush.Color:= clRed;
   //ACanvas.FillRect(Item.ViewRect); //RectArray.BoundsRect);
 end;
 Handled:= True;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var Col: TEasyColumn;
    Item: TEasyItem;
    a: Integer;
begin
 Application.OnMessage:= AppMessage;
 Application.OnException:= AppException;
 Application.OnShowHint:= AppShowHint;
 DragAcceptFiles(fmMain.Handle,True);
 lvGrids.DoubleBuffered:= True;
 lvFrags.DoubleBuffered:= True;

 lvTest:= TEasyListView.Create(fmMain);
 lvTest.SetBounds(0, 0, 600, 300);
 lvTest.Parent:= paMain;
 lvTest.Align:= alClient;
 //AllocBy = 50
 lvTest.Header.Visible:= True;
 Col:= lvTest.Header.Columns.Add();
 Col.Caption:= 'ID';
 Col.Width:= 35;
 Col.Clickable:= False;
 Col:= lvTest.Header.Columns.Add();
 Col.Caption:= 'Grid';
 Col.Width:= 50;
 Col.Clickable:= False;
 Col:= lvTest.Header.Columns.Add();
 Col.Caption:= 'Library';
 Col.Width:= 50;
 Col.Clickable:= False;
 Col:= lvTest.Header.Columns.Add();
 Col.Caption:= 'Bricks';
 Col.Width:= 50;
 Col.Clickable:= False;
 Col:= lvTest.Header.Columns.Add();
 Col.Caption:= 'Scene';
 Col.Width:= 50;
 Col.Clickable:= False;
 Col:= lvTest.Header.Columns.Add();
 Col.Caption:= 'Description';
 Col.Clickable:= False;
 Col.AutoSpring:= True;
 lvTest.Header.Rebuild(True);
 Col.Width:= lvTest.ClientWidth - Col.ViewRect.Left;

 lvTest.Selection.Enabled:= True;
 lvTest.Selection.EnableDragSelect:= True;
 lvTest.Selection.FullRowSelect:= True;
 lvTest.Selection.MultiSelect:= True;

 lvTest.EditManager.Enabled:= False;
 {for a:= 0 to 20 do begin
   Item:= lvTest.Items.Add();
   Item.Caption:= 'test1';
   Item.Captions[1]:= 'test2';
   Item.Captions[2]:= 'test3';
 end;}
 //OwnerData = True
 //OwnerDraw = True
 //TabOrder = 1
 lvTest.View:= elsReport;
 lvTest.Selection.UseFocusRect:= False;
 //lvTest.PaintInfoItem.GridLines:= True;
 //lvTest.PaintInfoItem.GridLineColor:= $E0E0E0;
 lvTest.OnItemGetCaption:= lvGridsItemGetCaption;
 lvTest.OnItemCustomView:= lvGridsItemCustomView;
 //OnCustomDraw = lvGridsCustomDraw
 //OnDblClick = lvGridsDblClick
 //OnDrawItem = lvGridsDrawItem
 //OnEnter = lvGridsEnter
 //OnKeyDown = lvGridsKeyDown
 //OnMouseDown = lvGridsMouseDown
 //OnResize = lvGridsResize
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
 ListViewLastColAutoSize(lvGrids);
end;

function CheckModified(): Boolean;
begin
 Result:= True;
 If ProjectModified then
  Case MessageBox(fmMain.Handle,'Current Project has been modified. Save the changes?','Little Stage Designer',MB_ICONQUESTION + MB_YESNOCANCEL)
  of
   ID_YES: If CurrentProject = '' then Result:= ProjectSaveAs()
                                  else SaveProject(CurrentProject);
   ID_CANCEL: Result:= False;
  end;
end;

//obs³uga Drag & Drop

procedure TfmMain.WMDropFiles(hDrop: THandle; hWindow: HWnd);
var TotalNumberOfFiles, nFileLength, index: Integer;
    pszFileName: PChar;
    DropPoint, ListPoint: TPoint;
    Temp: TListItem;
    Target: TControl;
    Handled: Boolean;
begin
  //number of files dropped
  TotalNumberOfFiles:= DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
  If TotalNumberOfFiles = 1 then begin
    nFileLength:= DragQueryFile(hDrop, 0, nil, 0) + 1;
    GetMem(pszFileName, nFileLength);
    DragQueryFile(hDrop, 0, pszFileName, nFileLength);
    DragQueryPoint(hDrop, DropPoint);
    Handled:= False;

    //Target:= ControlAtPos(DropPoint, False, True);
    //if Assigned(Target) and (Target is TWinControl) then begin
     // ListPoint:= Target.ParentToClient(DropPoint);
      //Target:= (Target as TWinControl).ControlAtPos(ListPoint, False, True);
    Target:= paMain.ControlAtPos(paMain.ParentToClient(DropPoint, Self), False, True);
    if Target = lvGrids then begin
      ListPoint:= lvGrids.ParentToClient(DropPoint, Self);
      Temp:= lvGrids.GetItemAt(ListPoint.x, ListPoint.y);
      if Assigned(Temp) then begin
        index:= Temp.Index;
        XTemp:= ListPoint.x;
        PathTemp:= pszFileName;
        ListPoint:= ClientToScreen(DropPoint);
        lvGrids.ClearSelection();
        lvGrids.ItemIndex:= index;
        mDropExisting.Tag:= 0;
        mDropExisting.Popup(ListPoint.x, ListPoint.y);
      end else
        AddFileAuto(True, -1, ListPoint.x, pszFileName, 0);
      lvGrids.SetFocus();
      Handled:= True;
    end else begin
      Target:= paFragments.ControlAtPos(paFragments.ParentToClient(DropPoint, Self), False, True);
      if Target = lvFrags then begin
        ListPoint:= lvFrags.ParentToClient(DropPoint, Self);
        Temp:= lvFrags.GetItemAt(ListPoint.x, ListPoint.y);
        if Assigned(Temp) then begin
          index:= Temp.Index;
          XTemp:= ListPoint.x;
          PathTemp:= pszFileName;
          ListPoint:= ClientToScreen(DropPoint);
          lvFrags.ClearSelection();
          lvFrags.ItemIndex:= index;
          mDropExisting.Tag:= 1;
          mDropExisting.Popup(ListPoint.x, ListPoint.y);
        end else
          AddFileAuto(False, -1, ListPoint.x, pszFileName, 0);
        lvFrags.SetFocus();  
        Handled:= True;
      end;
    end;
    UpdateUndoButtons();
    if not Handled then begin
      try    //to make FreeMem execute if exception occurs
        If ExtIs(pszFileName, '.sdp') then begin
          CheckModified();
          LoadProject(pszFileName);
        end else
          Beep();
      except
      end;
    end;

    FreeMem(pszFileName,nFileLength);
  end else
    MessageBox(handle,'One file at a time, please.','Little Stage Designer',MB_ICONWARNING+MB_OK);

  DragFinish(hDrop);
end;

procedure TfmMain.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  case Msg.Message of
    WM_DROPFILES: WMDropFiles(Msg.wParam, Msg.hWnd);
  end;
end;

procedure TfmMain.AppException(Sender: TObject; E: Exception);
begin
 //If ProgBarForm.Visible then ProgBarForm.Close;
 //if fSettings.Visible then fSettings.Close;
 //if fExtract.Visible then fExtract.Close;

 Screen.Cursor:= crArrow;
 ErrorMsg('Little Stage Designer has risen an exception called: "'+E.Message
        + '" and may be unstable. Please save your work and restart the program as'
        + ' soon as possible.');
 ProgBarForm.CloseSpecial();
end;

Procedure TfmMain.AppShowHint(var HintStr: String; var CanShow: Boolean;
 var HintInfo: THintInfo);
var ARow, ACol: Integer;
    p: TPoint;
    s: String;
begin
 {If HintInfo.HintControl is TLabel then begin
  HintInfo.HintWindowClass:=THintLabel;
  HintInfo.HintPos.X:=HintInfo.HintControl.ClientOrigin.X-3;
  HintInfo.HintPos.Y:=HintInfo.HintControl.ClientOrigin.Y-1;
 end
 else if HintInfo.HintControl = FileList then begin
  p:=FileList.ScreenToClient(Mouse.CursorPos);
  FileList.MouseToCell(p.X,p.Y,ACol,ARow);
  CanShow:=False;
  If (FileList.ColCount>=ACol) and (FileList.RowCount>=ARow) then begin
   s:=FileList.Cells[ACol,ARow];
   If (s<>'') and ((ACol=7) or (ACol=8))
   and ((FileList.Canvas.TextWidth(s)>FileList.ColWidths[ACol]-2)
   or ((ACol=8) and (s<>Entries[DispMap[ARow]].Replace) and (s[1]<>'>'))) then begin
    HintInfo.HintWindowClass:=THintList;
    If ACol=8 then begin
     HintStr:=Entries[DispMap[ARow]].Replace;
     HintParam:=-1;
    end
    else begin
     HintStr:=s;
     HintParam:=Entries[DispMap[ARow]].ExtIndex;
    end;
    HintInfo.HintData:=@HintParam;
    p:=FileList.ClientToScreen(FileList.CellRect(ACol,ARow).TopLeft);
    HintInfo.HintPos.X:=p.X-1;
    HintInfo.HintPos.Y:=p.Y-1;
    HintInfo.ReshowTimeout:=100;
    CanShow:=True;
   end;
  end;
 end;}
end;

procedure TfmMain.lvGridsDblClick(Sender: TObject);
var Path: String;
    Fragment, Index: Integer;
    Sel: TListItem;
    Grid: Boolean;
begin
 Grid:= Sender = lvGrids;
 Sel:= (Sender as TListView).Selected;
 if Assigned(Sel) and (XTemp > 0) then begin
   if (Grid and (XTemp = 5)) or (not Grid and (XTemp = 4)) then begin
     mListMenu.Tag:= IfThen(Grid, 0, 1);
     mRowDescClick(mRowDesc);
   end else begin
     Index:= Sel.Index;
     if Grid then begin
       case XTemp of
         1: Path:= GridList[Index].MapPath;
         2: Path:= GridList[Index].LibPath;
         3: Path:= GridList[Index].BrickPath;
         4: Path:= GridList[Index].ScenePath;
       end;
     end else begin
       case XTemp of
         1: Path:= FragList[Index].MapPath;
         2: Path:= FragList[Index].LibPath;
         3: Path:= FragList[Index].BrickPath;
       end;
       Fragment:= FragList[Index].MapIndex;
     end;
     if TfmManual.ShowDialog(Grid, Index + 1, XTemp,
          ProjectOptions.Output.OutputLBA,
          (Sender as TListView).Columns[XTemp].Caption, Path, Fragment)
     then begin
       SetListItem(Grid, Index, XTemp, Path, Fragment, True);
       {SetUndo(Grid);
       SetProjectModified(True);
       if Grid then begin
         case XTemp of
           1: GridList[Index].GridPath:= Path;
           2: GridList[Index].LibPath:= Path;
           3: GridList[Index].BrickPath:= Path;
           4: GridList[Index].ScenePath:= Path;
         end;
       end else begin
         case XTemp of
           1: begin
                FragList[Index].FragmentPath:= Path;
                FragList[Index].FragmentIndex:= Fragment;
              end;
           2: FragList[Index].LibPath:= Path;
           3: FragList[Index].BrickPath:= Path;
         end;
       end;}
     end;
     (Sender as TListView).Repaint();
   end;
 end;
end;

procedure TfmMain.lvGridsDrawItem(Sender: TCustomListView; Item: TListItem;
  Rect: TRect; State: TOwnerDrawState);
var a, b, mw, stX, FragSpace, FragX, cc: Integer;
    ColX: array of Integer;
    Grids: Boolean;
    temp: String;
begin
 //Sender.Canvas.Brush.Style:= bsSolid;
 //Sender.Canvas.FillRect(Rect);
 stX:= Rect.Left;

 SetLength(ColX, (Sender as TListView).Columns.Count + 1);
 ColX[0]:= 0;
 for a:= 1 to High(ColX) do
   ColX[a]:= ColX[a-1] + Sender.Column[a-1].Width;

 Grids:= Sender = lvGrids;

 Sender.Canvas.Brush.Style:= bsSolid;
 if odSelected in State then begin
   if Sender.Focused then begin
     Sender.Canvas.Pen.Color:= clBlue;
     Sender.Canvas.Brush.Color:= clSkyBlue;
   end else begin
     Sender.Canvas.Pen.Color:= clMedGray;
     Sender.Canvas.Brush.Color:= $E0E0E0;
   end;
   Sender.Canvas.Rectangle(Rect);//.Left, Rect.Top - 1, Rect.Right, Rect.Bottom);
 end;

 a:= 0; b:= 0;
 if Grids then b:= 1 else a:= 1;

 Sender.Canvas.Brush.Color:= $00A0A0FF;
 if (Grids and not GridList[Item.Index].MapEx)
 or (not Grids and not FragList[Item.Index].MapEx) then
   Sender.Canvas.FillRect(Classes.Rect(ColX[1], Rect.Top,
     ColX[1] + Sender.Column[1].Width, Rect.Bottom - 1));
 if (Grids and not GridList[Item.Index].LibEx)
 or (not Grids and not FragList[Item.Index].LibEx) then
   Sender.Canvas.FillRect(Classes.Rect(ColX[2], Rect.Top,
     ColX[2] + Sender.Column[2].Width, Rect.Bottom - 1));
 if (Grids and not GridList[Item.Index].BrickEx)
 or (not Grids and not FragList[Item.Index].BrickEx) then
   Sender.Canvas.FillRect(Classes.Rect(ColX[3], Rect.Top,
     ColX[3] + Sender.Column[3].Width - a, Rect.Bottom - 1));
 if Grids and not GridList[Item.Index].SceneEx then
   Sender.Canvas.FillRect(Classes.Rect(ColX[4], Rect.Top,
     ColX[4] + Sender.Column[4].Width - b, Rect.Bottom - 1));

 Sender.Canvas.Brush.Style:= bsClear;
 If odSelected in State then begin
   Sender.Canvas.Rectangle(Rect);
   mw:= Sender.Column[0].Width;
   cc:= (Sender as TListView).Columns.Count;
   for a:= 1 to cc - 1 do begin
     if (a = 1) or (a = cc - 1) then begin
       Sender.Canvas.MoveTo(mw - 1, Rect.Top);
       Sender.Canvas.LineTo(mw - 1, Rect.Bottom);
     end;
     Inc(mw, Sender.Column[a].Width);
   end;
 end;

 Sender.Canvas.Font.Color:= clBlack;

 Sender.Canvas.TextOut(Rect.Left, Rect.Top,
   IntToStr(Item.Index + IfThen(MainSettings.StartZero, 0, 1)));
 if Grids then begin
   mw:= stX + ColX[1];
   if not SameText(GridList[Item.Index].LibPath, GridList[Item.Index].MapPath)
   then begin
     DrawMinimizedName(GridList[Item.Index].MapPath, Sender.Canvas,
       Classes.Rect(mw, Rect.Top, stX + ColX[2] - 1, Rect.Bottom));
     mw:= stX + ColX[2];
     Sender.Canvas.MoveTo(mw - 1, Rect.Top);
     Sender.Canvas.LineTo(mw - 1, Rect.Bottom);
   end;
   if not SameText(GridList[Item.Index].BrickPath, GridList[Item.Index].LibPath)
   then begin
     DrawMinimizedName(GridList[Item.Index].LibPath, Sender.Canvas,
       Classes.Rect(mw, Rect.Top, stX + ColX[3] - 1, Rect.Bottom));
     mw:= stX + ColX[3];
     Sender.Canvas.MoveTo(mw - 1, Rect.Top);
     Sender.Canvas.LineTo(mw - 1, Rect.Bottom);
   end;
   if not SameText(GridList[Item.Index].ScenePath, GridList[Item.Index].BrickPath)
   then begin
     DrawMinimizedName(GridList[Item.Index].BrickPath, Sender.Canvas,
       Classes.Rect(mw, Rect.Top, stX + ColX[4] - 1, Rect.Bottom));
     mw:= stX + ColX[4];
     Sender.Canvas.MoveTo(mw - 1, Rect.Top);
     Sender.Canvas.LineTo(mw - 1, Rect.Bottom);
   end;
   DrawMinimizedName(GridList[Item.Index].ScenePath, Sender.Canvas,
     Classes.Rect(mw, Rect.Top, stX + ColX[5] - 1, Rect.Bottom));
   DrawMinimizedName(GridList[Item.Index].Description, Sender.Canvas,
     Classes.Rect(stX + ColX[5], Rect.Top, stX + ColX[6] - 1, Rect.Bottom));
 end else begin
   if SameText(FragList[Item.Index].MapPath, '<B>')
   or not ExtIs(FragList[Item.Index].MapPath, '.hqs') then
     FragSpace:= 0
   else begin
     temp:= IntToStr(FragList[Item.Index].MapIndex);
     FragSpace:= Sender.Canvas.TextWidth(temp) + 4;
   end;

   mw:= stX + ColX[1];
   FragX:= stX + ColX[2] - 3;

   if SameText(FragList[Item.Index].LibPath, FragList[Item.Index].MapPath) then
     FragX:= stX + ColX[3] - 3
   else begin
     DrawMinimizedName(FragList[Item.Index].MapPath, Sender.Canvas,
       Classes.Rect(mw, Rect.Top, stX + ColX[2] - FragSpace - 1, Rect.Bottom));
     mw:= stX + ColX[2];
     Sender.Canvas.MoveTo(mw - 1, Rect.Top);
     Sender.Canvas.LineTo(mw - 1, Rect.Bottom);
     FragSpace:= 0;
   end;

   if SameText(FragList[Item.Index].BrickPath, FragList[Item.Index].LibPath)
   then begin
     if FragSpace > 0 then FragX:= stX + ColX[4] - 3;
   end else begin
     DrawMinimizedName(FragList[Item.Index].LibPath, Sender.Canvas,
       Classes.Rect(mw, Rect.Top, stX + ColX[3] - FragSpace - 1, Rect.Bottom));
     mw:= stX + ColX[3];
     Sender.Canvas.MoveTo(mw - 1, Rect.Top);
     Sender.Canvas.LineTo(mw - 1, Rect.Bottom);
     FragSpace:= 0;
   end;

   DrawMinimizedName(FragList[Item.Index].BrickPath, Sender.Canvas,
     Classes.Rect(mw, Rect.Top, stX + ColX[4] - FragSpace - 1, Rect.Bottom));

   TextOutRight(Sender.Canvas, FragX, Rect.Top, temp);

   DrawMinimizedName(FragList[Item.Index].Description, Sender.Canvas,
     Classes.Rect(stX + ColX[4], Rect.Top, stX + ColX[5] - 1, Rect.Bottom));
 end;

 //Siatka:
 //Sender.Canvas.Pen.Color:= clBtnFace;
 //Sender.Canvas.Brush.Style:= bsClear;
 //Sender.Canvas.Rectangle(Rect);
end;

procedure TfmMain.lvGridsEnter(Sender: TObject);
begin
 UpdateUndoButtons();
end;

procedure TfmMain.lvGridsCustomDraw(Sender: TCustomListView;
  const ARect: TRect; var DefaultDraw: Boolean);
var a, ih, mw, rows, cc: Integer;
    Temp: TRect;
begin
 Sender.Canvas.Brush.Style:= bsSolid;
 Sender.Canvas.FillRect(ARect);
 //Siatka:
 If (Sender as TListView).Items.Count > 0 then begin
   Sender.Canvas.Pen.Color:= clBtnFace;
   rows:= Min(Sender.VisibleRowCount, (Sender as TListView).Items.Count);
   cc:= (Sender as TListView).Columns.Count;
   Temp:= (Sender as TListView).Items.Item[0].DisplayRect(drBounds);
   ih:= Temp.Bottom - Temp.Top;
   mw:= 0;
   for a:= 0 to cc do begin
     if (a = 1) or (a >= cc - 1) then begin
       Sender.Canvas.MoveTo(mw - 1, ARect.Top);
       Sender.Canvas.LineTo(mw - 1, rows * ih + 19);
     end;
     if a < cc then Inc(mw, Sender.Column[a].Width);
   end;
   for a:= 0 to rows do begin
     Sender.Canvas.MoveTo(ARect.Left, a * ih + 18);
     Sender.Canvas.LineTo(mw - 1, a * ih + 18);
   end;
 end;
end;

procedure TfmMain.lvGridsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Grid: Boolean;
begin
 //sbMain.SimpleText:= IntToStr(Key);
 Grid:= Sender = lvGrids;
 case Key of
   46: DeleteSelectedFiles(Grid); //Del
   38: If ssCtrl in Shift then MoveSelectedUp(Grid); //Up
   40: If ssCtrl in Shift then MoveSelectedDown(Grid); //Down
 end;
end;

procedure TfmMain.lvGridsItemGetCaption(Sender: TCustomEasyListview;
      Item: TEasyItem; Column: Integer; var Caption: WideString);
var Id: Integer;
begin
 Id:= Item.Index;
 if (Id >= 0) and (Id < Length(GridList)) then begin
   case Column of
     0: Caption:= IntToStr(Id + IfThen(MainSettings.StartZero, 0, 1));
     1: Caption:= GridList[Id].MapPath;
     2: Caption:= GridList[Id].LibPath;
     3: Caption:= GridList[Id].BrickPath;
     4: Caption:= GridList[Id].ScenePath;
     5: Caption:= GridList[Id].Description;
   end;
 end else
   Caption:= '-';
end;

procedure TfmMain.lvGridsItemCustomView(Sender: TCustomEasyListview;
      Item: TEasyItem; ViewStyle: TEasyListStyle; var View: TEasyViewItemClass);
begin
 if ViewStyle = elsReport then View:= TCustomViewReportItem;
end;      

procedure TfmMain.mDropInsertLineClick(Sender: TObject);
var a, c, index: Integer;
    Grid: Boolean;
begin
 Grid:= mDropExisting.Tag = 0;
 index:= IfThen(Grid, lvGrids.ItemIndex, lvFrags.ItemIndex);
 if (Sender = mDropInsertLine) and (index > -1) then
   AddFileAuto(Grid, index, XTemp, PathTemp, 0)
 else if (Sender = mDropAddLine) then
   AddFileAuto(Grid, -1, XTemp, PathTemp, 0)
 else if (Sender = mDropReplaceLine) and (index > -1) then
   SetListItem(Grid, index, GetColumn(Grid, XTemp), PathTemp, 0, True)
 else if Sender = mDropFillColumn then begin
   SetUndo(Grid);
   c:= GetColumn(Grid, XTemp);
   for a:= 0 to IfThen(Grid, High(GridList), High(FragList)) do
     SetListItem(Grid, a, c, PathTemp, 0);
 end;
end;

procedure TfmMain.mClearCellClick(Sender: TObject);
var a, index: Integer;
    Grid: Boolean;
begin
 Grid:= mListMenu.Tag = 0;
 index:= IfThen(Grid, lvGrids.ItemIndex, lvFrags.ItemIndex);
 If (Sender = mClearCell) and (index > -1) then SetListItem(Grid, index, XTemp, '', 0, True)
 else if (Sender = mSetBlank) and (index > -1) then SetListItem(Grid, index, XTemp, '<B>', 0, True)
 else if Sender = mClearRows then begin
   if (Grid and (lvGrids.SelCount > 0))
   or (not Grid and (lvFrags.SelCount > 0)) then begin
     SetUndo(Grid);
     if Grid then begin
       for a:= 0 to lvGrids.Items.Count - 1 do
         if lvGrids.Items.Item[a].Selected then begin
           GridList[a].Description:= '';
           SetListItem(True, a, 0, '', 0);
         end;
     end else begin
       for a:= 0 to lvFrags.Items.Count - 1 do
         if lvFrags.Items.Item[a].Selected then begin
           FragList[a].Description:= '';
           SetListItem(False, a, 0, '', 0);
         end;
     end;
   end;
 end
 else if Sender = mSelBlank then begin
   if (Grid and (lvGrids.SelCount > 0))
   or (not Grid and (lvFrags.SelCount > 0)) then begin
     SetUndo(Grid);
     if Grid then begin
       for a:= 0 to lvGrids.Items.Count - 1 do
         if lvGrids.Items.Item[a].Selected then
           SetListItem(True, a, 0, '<B>', 0)
     end else begin
       for a:= 0 to lvFrags.Items.Count - 1 do
         if lvFrags.Items.Item[a].Selected then
           SetListItem(False, a, 0, '<B>', 0);
     end;
   end;
 end;
end;

procedure TfmMain.lvGridsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a: Integer;
    //Temp: TListItem;
    Grid, DescriptionRow: Boolean;
    p: TPoint;
begin
 Grid:= Sender = lvGrids;
 a:= GetColumn(Grid, X);
 p:= (Sender as TListView).ClientToScreen(Point(X, Y));
 //Temp:= lvList.GetItemAt(X, Y);
 if Assigned((Sender as TListView).Selected) and (a >= 1)
 and ((Grid and (a <= 5)) or (not Grid and (a <= 4))) then begin
   DescriptionRow:= (Grid and (a = 5)) or (not Grid and (a = 4));
   XTemp:= a;
   //lvList.ClearSelection;
   //lvList.Selected:= Temp;
   mEditClick(Self);
   mListMenu.Tag:= IfThen(Grid, 0, 1); //1 for Fragment List
   if Button = mbRight then begin
     mManualEdit.Enabled:= not DescriptionRow;
     mClearCell.Enabled:= not DescriptionRow;
     mSetBlank.Enabled:= not DescriptionRow;
     if DescriptionRow then mRowDesc.Default:= True
                       else mManualEdit.Default:= True;
     mListMenu.Popup(p.X, p.Y);
   end;
 end else begin
   XTemp:= 0;
   mNewMenu.Tag:= IfThen(Grid, 0, 1); //1 for Fragment List
   if Button = mbRight then
     mNewMenu.Popup(p.X, p.Y);
 end;
end;

procedure TfmMain.mMoveToTopClick(Sender: TObject);
var Grid: Boolean;
begin
 Grid:= mListMenu.Tag = 0;
 If Sender = mMoveToTop then MoveSelectedToTop(Grid)
 else if Sender = mMoveToBottom then MoveSelectedToBottom(Grid)
 else if Sender = mMoveUp then MoveSelectedUp(Grid)
 else if Sender = mMoveDown then MoveSelectedDown(Grid);
 if Grid then lvGrids.Repaint() else lvFrags.Repaint();
end;

procedure TfmMain.lvGridsResize(Sender: TObject);
begin
 //StatusBar1.SimpleText:= IntToStr(lvList.Columns.Items[0].Width);
 //lvList.Columns.Items.WidthType
end;

procedure TfmMain.aProjectOptionsClick(Sender: TObject);
begin
 fmProject.ShowOptions();
end;

procedure TfmMain.mSettingsClick(Sender: TObject);
begin
 fmSettings.ShowSettings();
end;

procedure TfmMain.aOpenProjectClick(Sender: TObject);
begin
 CheckModified();
 UnloadProject();
 dlOpen.InitialDir:= MainSettings.LastProjectDir;
 if dlOpen.Execute then
   LoadProject(dlOpen.FileName);
end;

function ProjectSaveAs(): Boolean;
begin
 Result:= False;
 fmMain.dlSave.InitialDir:= MainSettings.LastProjectDir;
 If fmMain.dlSave.Execute then begin
   If not ExtIs(fmMain.dlSave.FileName,'.sdp') then
     fmMain.dlSave.FileName:= fmMain.dlSave.FileName + '.sdp';
   SaveProject(fmMain.dlSave.FileName);
   Result:= True;
 end;
end;

procedure TfmMain.aSaveProjectClick(Sender: TObject);
begin
 If CurrentProject = '' then ProjectSaveAs() else SaveProject(CurrentProject);
end;

procedure TfmMain.aSaveProjectAsClick(Sender: TObject);
begin
 ProjectSaveAs();
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 If CheckModified() then UnloadProject()
                    else Action:= caNone;
end;

procedure TfmMain.aNewProjectExecute(Sender: TObject);
begin
 If CheckModified() then UnloadProject();
end;

procedure TfmMain.aBuildProjectExecute(Sender: TObject);
begin
 If ProjectModified and MainSettings.AutoSave
 and not ((CurrentProject = '') and MainSettings.NoASForce) then
   aSaveProject.Execute();
 BuildProject();
end;

procedure TfmMain.aAddLineExecute(Sender: TObject);
var index: Integer;
    Grid: Boolean;
begin
 Grid:= fmMain.ActiveControl = lvGrids;
 index:= IfThen(Grid, lvGrids.ItemIndex, lvFrags.ItemIndex);
 if Sender = aInsertLine then
   AddFileAuto(Grid, index, 0, '', 0)
 else if Sender = aAddLine then
   AddFileAuto(Grid, -1, 0, '', 0);
end;

procedure TfmMain.aSettingsExecute(Sender: TObject);
begin
 fmSettings.ShowSettings();
end;

procedure TfmMain.aUndoExecute(Sender: TObject);
begin
 DoUndo(fmMain.ActiveControl = lvGrids);
end;

procedure TfmMain.aRedoExecute(Sender: TObject);
begin
 DoRedo(fmMain.ActiveControl = lvGrids);
end;

procedure TfmMain.aDelSelectedExecute(Sender: TObject);
begin
 DeleteSelectedFiles(fmMain.ActiveControl = lvGrids);
end;

procedure TfmMain.mEditClick(Sender: TObject);
begin
 aDelSelected.Enabled:=
   ((fmMain.ActiveControl = lvGrids) and (lvGrids.SelCount > 0)
 or (fmMain.ActiveControl = lvFrags) and (lvFrags.SelCount > 0));
end;

procedure TfmMain.mManualEditClick(Sender: TObject);
begin
 if mListMenu.Tag = 0 then lvGridsDblClick(lvGrids)
                      else lvGridsDblClick(lvFrags);
end;

procedure TfmMain.RefreshRecentMenu();
var a: Integer;
    temp: TMenuItem;
begin
 mOpenRecent.Clear();
 for a:= 0 to MaxRecentProjects - 1 do
   if MainSettings.RecentProjects[a] <> '' then begin
     temp:= NewItem(MainSettings.RecentProjects[a], 0, False, True,
                    mOpenRecentProjectClick, 0, '');
     temp.Tag:= a;
     mOpenRecent.Add(temp);
     CompMods.UpdateComponent(temp);
   end;
 mOpenRecent.Enabled:= mOpenRecent.Count > 0;
end;

procedure TfmMain.AddToRecent(path: String);
var a, b, c: Integer;
begin
 path:= GetLongFileName(path);
 c:= MaxRecentProjects - 1; //High(..Sett.General.Recent...)
 for a:= 0 to MaxRecentProjects - 2 do
   if AnsiSameText(path, MainSettings.RecentProjects[a]) then begin
     c:= a;
     Break;
   end;
 for b:= c - 1 downto 0 do
   MainSettings.RecentProjects[b + 1]:= MainSettings.RecentProjects[b];
 MainSettings.RecentProjects[0]:= path;
 RefreshRecentMenu();
end;

procedure TfmMain.mOpenRecentProjectClick(Sender: TObject);
var fname: String;
begin
 CheckModified();
 UnloadProject();
 fname:= MainSettings.RecentProjects[(Sender as TMenuItem).Tag];
 MainSettings.LastProject:= fname;
 LoadProject(fname);
end;

procedure TfmMain.mRowDescClick(Sender: TObject);
var index: Integer;
    temp: String;
    Grid: Boolean;
    List: TMapList;
begin
 Grid:= mListMenu.Tag = 0;
 index:= IfThen(Grid, lvGrids.ItemIndex, lvFrags.ItemIndex);
 if index > -1 then begin
   if Grid then List:= GridList else List:= FragList;
   temp:= List[index].Description;
   if InputQuery('Row description', 'Type in a description for the row.'
        + ' Description will be used for your information and for HQD files generation.'#13
        + 'Max 80 characters:', temp)
   then begin
     SetProjectModified(True);
     if Length(temp) > 80 then SetLength(temp, 80);
     List[index].Description:= temp;
     if Grid then lvGrids.Repaint()
             else lvFrags.Repaint();
   end;
 end;
end;

procedure TfmMain.spFragmentsMoved(Sender: TObject);
begin
 if lvFrags.Height = 0 then
   lvFrags.Height:= Max(paFragments.Height - lvFrags.Top, 0);
end;

end.
