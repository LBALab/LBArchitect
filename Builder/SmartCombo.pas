unit SmartCombo;

interface

uses stdctrls,classes,messages,controls,windows,sysutils;

type
  TSmartComboBox = class(TComboBox)
    // Usage:
    //   Same as TComboBox, just invoke InitSmartCombo after Items list is filled with data.
    //   After InitSmartCombo is invoked, StoredItems is assigned and combo starts to behave as a smart combo.
    //   If InitSmartCombo is not invoked it acts as standard TComboBox, it is safe to bulk replace all TComboBox in application with TSmartComboBox
  private
    FStoredItems: TStringList;
    dofilter:boolean;
    storeditemindex:integer;
    procedure FilterItems;
    procedure StoredItemsChange(Sender: TObject);
    procedure SetStoredItems(const Value: TStringList);
    procedure CNCommand(var AMessage: TWMCommand); message CN_COMMAND;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure CloseUp; override;
    procedure Click; override;
    function GetItemIndex: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property StoredItems: TStringList read FStoredItems write SetStoredItems;
    procedure InitSmartCombo;
  end;

implementation

procedure TSmartComboBox.KeyPress(var Key: Char);    // combo dropdown must be done in keypress, if its done on CBN_EDITUPDATE it messes up whole message processing mumbo-jumbo
    begin
      inherited;
      if dofilter and not (ord(key) in [13,27]) then begin
        if (items.Count<>0) and not droppeddown then SendMessage(Handle, CB_SHOWDROPDOWN, 1, 0)   // something matched -> dropdown combo to display results
      end;
    end;

procedure TSmartComboBox.CloseUp;     // ugly workaround for some wierd combobox/modified code interactions
var x:string;
    begin
      if dofilter then begin
        if (items.count=1) and (itemindex=0) then text:=items[itemindex]
        else if ((text<>'') and (itemindex<>-1) and (text<>items[itemindex])) or ((text='') and(itemindex=0)) then begin
          storeditemindex:=itemindex;
          x:=text;
          itemindex:=items.indexof(text);
          if itemindex=-1 then text:=x;
        end
        else storeditemindex:=-1;
      end;
      inherited;
    end;

procedure TSmartComboBox.Click;       // ugly workaround for some weird combobox/modified code interactions
    begin
      if dofilter then begin
        if storeditemindex<>-1 then itemindex:=storeditemindex;
        storeditemindex:=-1;
      end;
      inherited;
    end;

procedure TSmartComboBox.InitSmartCombo;
    begin
      FStoredItems.OnChange:=nil;
      StoredItems.Assign(Items);
      AutoComplete := False;
      FStoredItems.OnChange := StoredItemsChange;
      dofilter:=true;
      storeditemindex:=-1;
    end;

constructor TSmartComboBox.Create(AOwner: TComponent);
    begin
      inherited;
      FStoredItems := TStringList.Create;
      dofilter:=false;
    end;

destructor TSmartComboBox.Destroy;
    begin
      FStoredItems.Free;
      inherited;
    end;

procedure TSmartComboBox.CNCommand(var AMessage: TWMCommand);
    begin
      // we have to process everything from our ancestor
      inherited;
      // if we received the CBN_EDITUPDATE notification
      if (AMessage.NotifyCode = CBN_EDITUPDATE) and dofilter then begin
        // fill the items with the matches
        FilterItems;
      end;
    end;

function TSmartComboBox.GetItemIndex: Integer;
begin
  if dofilter then begin
    if inherited GetItemIndex > -1 then
      Result:= StoredItems.IndexOf(Items[inherited GetItemIndex])
    else
      Result:= StoredItems.IndexOf(Text);
  end else
    Result:= inherited GetItemIndex;
end;

procedure TSmartComboBox.FilterItems;
var
  I: Integer;
  Selection: TSelection;
    begin
      // store the current combo edit selection
      SendMessage(Handle, CB_GETEDITSEL, WPARAM(@Selection.StartPos), LPARAM(@Selection.EndPos));

      // begin with the items update
      Items.BeginUpdate;
      try
        // if the combo edit is not empty, then clear the items
        // and search through the FStoredItems
       if Text <> '' then begin
          // clear all items
          Items.Clear;
          // iterate through all of them
          for I := 0 to FStoredItems.Count - 1 do begin
            // check if the current one contains the text in edit, case insensitive
            if (Pos( uppercase(Text), uppercase(FStoredItems[I]) )>0) then begin
              // and if so, then add it to the items
              Items.Add(FStoredItems[I]);
            end;
          end;
        end else begin
          // else the combo edit is empty
          // so then we'll use all what we have in the FStoredItems
          Items.Assign(FStoredItems);
        end;
      finally
        // finish the items update
        Items.EndUpdate;
      end;
      // and restore the last combo edit selection

      SendMessage(Handle, CB_SETEDITSEL, 0, MakeLParam(Selection.StartPos, Selection.EndPos));
    end;

procedure TSmartComboBox.StoredItemsChange(Sender: TObject);
    begin
      if Assigned(FStoredItems) then
      FilterItems;
    end;

procedure TSmartComboBox.SetStoredItems(const Value: TStringList);
    begin
      if Assigned(FStoredItems) then
        FStoredItems.Assign(Value)
      else
        FStoredItems := Value;
    end;

procedure Register;
begin
  RegisterComponents('Standard', [TSmartComboBox]);
end;

end.
