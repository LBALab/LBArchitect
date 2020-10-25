unit Unit1;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, EasyListview, ImgList, ExtCtrls,
  EasyScrollFrame, StdCtrls, FileCtrl, MPCommonUtilities, Jpeg,
  MPCommonObjects;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    EasyScrollButton2: TEasyScrollButton;
    EasyScrollButton3: TEasyScrollButton;
    EasyListview1: TEasyListview;
    Image1: TImage;
    Panel2: TPanel;
    Button1: TButton;
    Label1: TLabel;
    procedure EasyListview1ItemThumbnailDraw(Sender: TCustomEasyListview;
      Item: TEasyItem; ACanvas: TCanvas; ARect: TRect;
      AlphaBlender: TEasyAlphaBlender; var DoDefault: Boolean);
    procedure EasyScrollButton3Click(Sender: TObject);
    procedure EasyScrollButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EasyListview1ItemFreeing(Sender: TCustomEasyListview;
      Item: TEasyItem);
    procedure EasyListview1ItemSelectionChanged(
      Sender: TCustomEasyListview; Item: TEasyItem);
  private
    { Private declarations }
  public
    { Public declarations }
    Dir: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ReadMemoryStreamFromStream(ST: TStream; MS: TMemoryStream): Boolean;
var
  L: Integer;
begin
  Result := false;
  ST.ReadBuffer(L, SizeOf(L));
  if L > 0 then begin
    MS.Size := L;
    ST.ReadBuffer(MS.Memory^, L);
    Result := true;
  end;
end;

procedure WriteMemoryStreamToStream(ST: TStream; MS: TMemoryStream);
var
  L: Integer;
begin
  L := MS.Size;
  ST.WriteBuffer(L, SizeOf(L));
  ST.WriteBuffer(MS.Memory^, L);
end;

function ReadBitmapFromStream(ST: TStream; B: TBitmap): Boolean;
var
  MS: TMemoryStream;
begin
  Result := false;
  MS := TMemoryStream.Create;
  try
    if ReadMemoryStreamFromStream(ST, MS) then
      if Assigned(B) then begin
        B.LoadFromStream(MS);
        Result := true;
      end;
  finally
    MS.Free;
  end;
end;

procedure WriteBitmapToStream(ST: TStream; B: TBitmap);
var
  L: Integer;
  MS: TMemoryStream;
begin
  if Assigned(B) then begin
    MS := TMemoryStream.Create;
    try
      B.SaveToStream(MS);
      WriteMemoryStreamToStream(ST, MS);
    finally
      MS.Free;
    end;
  end
  else begin
    L := 0;
    ST.WriteBuffer(L, SizeOf(L));
  end;
end;

procedure ConvertBitmapStreamToJPGStream(MS: TMemoryStream; CompressionQuality: TJPEGQualityRange);
var
  B: TBitmap;
  J: TJPEGImage;
begin
  B := TBitmap.Create;
  J := TJPEGImage.Create;
  try
    MS.Position := 0;
    B.LoadFromStream(MS);
    //WARNING, first set the JPEG options
    J.CompressionQuality := CompressionQuality; //90 is the default, 60 is the best setting
    //Now assign the Bitmap
    J.Assign(B);
    J.Compress;
    MS.Clear;
    J.SaveToStream(MS);
    MS.Position := 0;
  finally
    B.Free;
    J.Free;
  end;
end;

procedure ConvertJPGStreamToBitmapStream(MS: TMemoryStream);
var
  B: TBitmap;
  J: TJPEGImage;
begin
  B := TBitmap.Create;
  J := TJPEGImage.Create;
  try
    MS.Position := 0;
    J.LoadFromStream(MS);
    B.Assign(J);
    MS.Clear;
    B.SaveToStream(MS);
    MS.Position := 0;
  finally
    B.Free;
    J.Free;
  end;
end;

procedure ConvertJPGStreamToBitmap(MS: TMemoryStream; OutBitmap: TBitmap);
var
  B: TMemoryStream;
begin
  B := TMemoryStream.Create;
  try
    MS.Position := 0;
    B.LoadFromStream(MS);
    MS.Position := 0;
    ConvertJPGStreamToBitmapStream(B);
    OutBitmap.LoadFromStream(B);
  finally
    B.Free;
  end;
end;

procedure TForm1.EasyListview1ItemThumbnailDraw(
  Sender: TCustomEasyListview; Item: TEasyItem; ACanvas: TCanvas;
  ARect: TRect; AlphaBlender: TEasyAlphaBlender; var DoDefault: Boolean);
var
  Picture: TPicture;
  Bitmap: TBitmap;
  Stream: TMemoryStream;
begin
  Screen.Cursor := crHourGlass;
  if FileExists(Item.Captions[1]) then
  begin
    Bitmap := TBitmap.Create;
    try
      if Item.Tag = 0 then
      begin
        Stream := TMemoryStream.Create;
        Picture := TPicture.Create;
        try
          try
            Picture.RegisterFileFormat('jpg', 'Jpg File', Jpeg.TJPEGImage);
            Picture.LoadFromFile(Item.Captions[1]);
            Bitmap.Width := RectWidth(ARect);
            Bitmap.Height := RectHeight(ARect);
            Bitmap.Canvas.StretchDraw(Rect(0, 0, Bitmap.Width, Bitmap.Height), Picture.Graphic);
            WriteBitmapToStream(Stream, Bitmap);
            Item.Tag := Integer(Stream);
            Stream := nil;
          except
          end
        finally
          Stream.Free;
          Picture.Free;

        end
      end;
      if Item.Tag <> 0 then
      begin
        Stream := TMemoryStream( Item.Tag);
        Stream.Seek(0, soBeginning);
        ReadBitmapFromStream(Stream, Bitmap);
        ACanvas.Draw(ARect.Left, ARect.Top, Bitmap);
      end
    finally
      Bitmap.Free;
    end;
    Screen.Cursor := crDefault;
  end
end;

procedure TForm1.EasyScrollButton3Click(Sender: TObject);
begin
  EasyListview1.Scrollbars.OffsetX := EasyListview1.Scrollbars.OffsetX + EasyListview1.CellSizes.Thumbnail.Width;
end;

procedure TForm1.EasyScrollButton2Click(Sender: TObject);
begin
  EasyListview1.Scrollbars.OffsetX := EasyListview1.Scrollbars.OffsetX - EasyListview1.CellSizes.Thumbnail.Width;
end;

procedure TForm1.Button1Click(Sender: TObject);

   procedure Add(Data: TWin32FindData);
   var
     Item: TEasyItem;
     Ext: string;
   begin
     Ext := LowerCase(ExtractFileExt(Data.cFileName));
    if (string(Data.cFileName) <> '.') and (string(Data.cFileName) <> '..') and
    not(DirectoryExists(Data.cFileName)) and ((Ext = '.jpg') or (Ext = '.jpeg') or
    (Ext = '.jif') or  (Ext = '.bmp') or (Ext = '.wmf') or (Ext = '.emf') or
    (Ext = '.ico')) then
    begin
      Item := EasyListview1.Items.Add();
      Item.Caption := ExtractFileName(Data.cFileName);
      Item.Captions[1] := Dir + '\' + Data.cFileName;
    end;
   end;

var
  FindData: TWin32FindData;
  FindHandle: THandle;
begin
  if SelectDirectory('Browse for Picture Folder', '', Dir) then
  begin
    EasyListview1.BeginUpdate;
    try
      EasyListview1.Items.Clear;
      FindHandle := FindFirstFile(PChar(Dir + '\*.*'), FindData);
      if FindHandle <> INVALID_HANDLE_VALUE then
      begin
        Add(FindData);
        while FindNextFile(FindHandle, FindData) do
          Add(FindData);
        Windows.FindClose(FindHandle);
      end
    finally
      EasyListview1.EndUpdate();
    end
  end
end;

procedure TForm1.EasyListview1ItemFreeing(Sender: TCustomEasyListview;
  Item: TEasyItem);
begin
  if Item.Tag <> 0 then
    TObject( Item.Tag).Free;
end;

procedure TForm1.EasyListview1ItemSelectionChanged(
  Sender: TCustomEasyListview; Item: TEasyItem);
begin
  if FileExists(Item.Captions[1]) then
    Image1.Picture.LoadFromFile(Item.Captions[1])
end;

end.
