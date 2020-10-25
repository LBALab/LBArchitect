unit Utils_Graph;

interface

uses Windows, Graphics, Controls, Utils, Classes, Math, StdCtrls,
     SysUtils, ExtCtrls, StrUtils;

const
  clOrange = $0080ff;
  clDarkOrange = $0060C0;
  clLightOrange = $91C8FF;
  clLightRed = $B8B8FF;
  clLightPurple = $FFB8FF;
  clLightGreen = $00C000;

//Rysuje tekst wyr�wnany do prawej
procedure TextOutRight(Canvas: TCanvas; x, y: Integer; Text: String);

//Rysuje tekst wy�rodkowany w poziomie
procedure TextOutCenter(Canvas: TCanvas; x, y: Integer; Text: String);

//Rysuje tekst w �rodku prostok�ta (mo�e by� wieloliniowy), zawija linie i
//  dodaje kropki, jesli tekst si� nie mie�ci
//procedure DrawTextCenter(DC: hDC; r: TRect; text: String);

//Rysuje tekst w podanym obszarze z zawijaniem linii
//Tekst jest zawsze rysowany przy g�rnej kraw�dzi (nie na �rodku)
procedure TextOutRect(Canvas: TCanvas; R: TRect; Text: String;
  Alignment: TAlignment);
//Oblicza faktyczn� wysoko�� i szeroko�� tekstu, kt�ry by�by narysowany przy u�ycu
//  funkcji TextOutRect
function TextSizeRect(Canvas: TCanvas; R: TRect; Text: String): TPoint;

//x podaje �rodek kontrolki
//procedure PaintDiode(Canvas: TCanvas; x, y, w, h: Integer;
//  Colour: TDiodeColour; Text: String; Ena: Boolean);

procedure DrawCheckBox(Canvas: TCanvas; x, y: Integer; Checked: Boolean);
//Rysuje prostok�t wypuk�y lub wkl�s�y (Convex = wypuk�y)
procedure DrawBevel(Canvas: TCanvas; x, y, width, height: Integer;
  Convex: Boolean; Edges: TBevelEdges);

//Sprawdza czy mo�na prztyciemni� i rozja�ni� dany kolor o podan� warto��
//Zwraca maksymaln� warto��, o kt�r� si� da przyciemni� i rozja�ni�
//val to warto��, przez kt�r� zostanie pomno�ona i podzielona ka�da
//  sk�adowa koloru. Powinna by� to warto�� > 1 (rozja�nienie), inaczej
//  funkcja mo�e nie dzia�a� poprawnie.
function ColourMaxChange(col: TColor; v: Single): Single;
//Przyciemnianie i rozja�nianie kolor�w o podan� warto��
//Je�li sk�adowe RGB wynikowego koloru nie mieszcz� si� w zakresie, to
//  b�d� one obci�te 255
//val nie mo�e by� ujemne! 
function ChangeLight(col: TColor; v: Single): TColor;


//Rysuje tekst ze znakami formatowania
//Znaki formatowania maj� posta� {znak1,znak1}, np.
//  {b,i,red} oznacza, �e tekst ma by� pogrubiony, pochylony i w kolorze czerwonym
//Zamkni�cie znak�w nast�puje przez / przed znakiem, np.
//  {/b} oznacza, �e dalszy tekst ju� nie b�dzie pogrubiony.
//Dost�pne znaki:
//  b, i, u, s - pogrubienie, pochylenie, podkre�lenie i przekre�lenie
//  kolory: red, blue, green, black, white, maroon, olive, navy, purple, teal,
//    gray, silver, lime, yellow, fuchsia, aqua
//  oraz kody kolor�w delphi, np. $102030
//Znaki { i } mo�na wypisa� przez \{ oraz \} .
//Funkcja obs�uguje zawijanie wierszy (automatyczne i r�czne), ale zawijanie automatyczne
//  nie zwraca uwagi na s�owa (zawija tam, gdzie mu pasuje)
//Zwraca faktyczn� wysoko�� i szeroko�� tekstu (mo�na wtedy dopasowa� obrazek, je�li
//  tekst wychodzi poza obszar).
function DrawFormattedText(Canvas: TCanvas; txt: String; r: TRect;
  AutoWrap: Boolean): TPoint;

//Ustawia rozmiar obrazka TImage oraz jego wewn�trznej pami�ci
//  (samo ustawienie rozmiaru obrazka nie dzia�a)
procedure SetImgSize(img: TImage; Width, Height: Integer);

//Rysuje wykres warto�ci w czasie weg�ug podanych danych. Automatycznie dopasowuje
//  skal� osi Y do warto�ci. Skala czasu jest sta�a - wynosi 1 piksel na jedn� dan�.
//Kolejno�� danych: najstarsze z indeksem 0
//TStart - pocz�tek skali czasu, podawany po to, �eby siatka czasu przesuwa�a si� przy
//  dodawaniu danych; wi�ksze liczby powoduj� przesuni�cie siatki w lewo.
//Funkcja obs�uguje MAX. 4 WYKRESY JEDNOCZE�NIE
//W aktualnej wersji wszystkie zestawy danych MUSZ� MIE� identyczne rozmiary
//Je�li Legenda jest pusta, to si� nie pokazuje
procedure DrawTimeGraph(C: TCanvas; R: TRect; BackG: TColor; TStart: Integer;
  YName: String; YData: array of TDoubleDynAr; Legend: array of String);

implementation

procedure TextOutRight(Canvas: TCanvas; x, y: Integer; Text: String);
begin
 Canvas.TextOut(x - (Canvas.TextWidth(Text) - 1), y, Text);
end;

procedure TextOutCenter(Canvas: TCanvas; x, y: Integer; Text: String);
begin
 Canvas.TextOut(x - ((Canvas.TextWidth(Text) - 1) div 2), y, Text);
end;

{procedure DrawTextCenter(DC: hDC; r: TRect; text: String);
var r2: TRect;   co� nie dzia�a
begin
 DrawText(DC, PChar(text), Length(text), r2,
   DT_CENTER or DT_END_ELLIPSIS or DT_NOPREFIX or DT_WORDBREAK or DT_CALCRECT);
 r.Top:= r.Top + (((r.Bottom - r.Top) - (r2.Bottom - r2.Top)) div 2);
 DrawText(DC, PChar(text), Length(text), r,
   DT_CENTER or DT_END_ELLIPSIS or DT_NOPREFIX or DT_WORDBREAK);
end;}

procedure TextOutRect(Canvas: TCanvas; R: TRect; Text: String;
  Alignment: TAlignment);
begin
 DrawText(Canvas.Handle, PChar(Text), -1, R,
   DT_WORDBREAK or IfThen(Alignment = taLeftJustify, DT_LEFT,
   IfThen(Alignment = taCenter, DT_CENTER, DT_RIGHT)));
end;

function TextSizeRect(Canvas: TCanvas; R: TRect; Text: String): TPoint;
begin
 DrawText(Canvas.Handle, PChar(Text), -1, R, DT_WORDBREAK or DT_LEFT or DT_CALCRECT);
 Result.X:= R.Right - R.Left;
 Result.Y:= R.Bottom - R.Top;
end;

{procedure PaintDiode(Canvas: TCanvas; x, y, w, h: Integer;
  Colour: TDiodeColour; Text: String; Ena: Boolean);
begin
 case Colour of
   dcRed: begin
     Canvas.Brush.Color:= IfThen(Ena, clRed, clGray);//clMaroon);
     Canvas.Font.Color:=  IfThen(Ena, clWhite, clSilver);
   end;
   dcBlue: begin
     Canvas.Brush.Color:= IfThen(Ena, clBlue, clGray);//clNavy);
     Canvas.Font.Color:=  IfThen(Ena, clWhite, clSilver);
   end;
   dcLightBlue: begin
     Canvas.Brush.Color:= IfThen(Ena, clSkyBlue, clGray);//clNavy);
     Canvas.Font.Color:=  IfThen(Ena, clBlack, clSilver);
   end;
   dcGreen: begin
     Canvas.Brush.Color:= IfThen(Ena, clLime, clGray);//clGreen);
     Canvas.Font.Color:=  IfThen(Ena, clBlack, clSilver);
   end;
   dcYellow: begin
     Canvas.Brush.Color:= IfThen(Ena, clYellow, clGray);//clOlive);
     Canvas.Font.Color:=  IfThen(Ena, clBlack, clSilver);
   end;
   dcOrange: begin
     Canvas.Brush.Color:= IfThen(Ena, clOrange, clGray);//$004080);
     Canvas.Font.Color:=  IfThen(Ena, clWhite, clSilver);
   end;
 end;
 Canvas.Rectangle(Bounds(x - (w div 2), y, w, h));
 If Canvas.TextWidth(Text) <= w - 3 then
   TextOutCenter(Canvas, x, y + (h - Canvas.TextHeight(Text)) div 2, Text);
end;}

procedure DrawCheckBox(Canvas: TCanvas; x, y: Integer; Checked: Boolean);
begin
 Canvas.Pen.Width:= 2;
 Canvas.Pen.Color:= clBlack;
 Canvas.Rectangle(Bounds(x, y, 12, 12));
 If Checked then begin
   Canvas.Pen.Width:= 1;
   Canvas.Pen.Color:= clBlue;
   //Canvas.Rectangle(Bounds(x+4, y+4, 4, 4));
   Canvas.MoveTo(x + 2, y + 4);
   Canvas.LineTo(x + 4, y + 6);
   Canvas.LineTo(x + 8, y + 2);
   Canvas.LineTo(x + 8, y + 3);
   Canvas.LineTo(x + 4, y + 7);
   Canvas.LineTo(x + 2, y + 5);
   Canvas.LineTo(x + 2, y + 6);
   Canvas.LineTo(x + 4, y + 8);
   Canvas.LineTo(x + 9, y + 3);
 end;
end;

procedure DrawBevel(Canvas: TCanvas; x, y, width, height: Integer;
  Convex: Boolean; Edges: TBevelEdges);
begin
 Canvas.Brush.Color:= clBtnFace;
 Canvas.FillRect(Bounds(x, y, width, height));
 Canvas.Pen.Width:= 1;
 Canvas.Pen.Color:= IfThen(Convex, clBtnHighlight, clBtnShadow);
 if beLeft in Edges then begin
   Canvas.MoveTo(x, y + height);
   Canvas.LineTo(x, y - 1);
 end;
 if beTop in Edges then begin
   Canvas.MoveTo(x, y);
   Canvas.LineTo(x + width + 1, y);
 end;
 Canvas.Pen.Color:= IfThen(Convex, clBtnShadow, clBtnHighlight);
 if beRight in Edges then begin
   Canvas.MoveTo(x + width, y);
   Canvas.LineTo(x + width, y + height + 1);
 end;
 if beBottom in Edges then begin
   Canvas.MoveTo(x + width, y + height);
   Canvas.LineTo(x - 1, y + height);
 end;
end;

function ColourMaxChange(col: TColor; v: Single): Single;
var r, g, b: Single;
begin
 r:= 255 / Max((col and $0000FF), 0.1);
 g:= 255 / Max(((col and $00FF00) shr 8), 0.1);
 b:= 255 / Max(((col and $FF0000) shr 16), 0.1);
 Result:= MinValue([v, r, g, b]);
end;

function ChangeLight(col: TColor; v: Single): TColor;
var r, g, b: Byte;
begin
 r:= SRound(Min((col and $0000FF) * v, 255));
 g:= SRound(Min(((col and $00FF00) shr 8) * v, 255));
 b:= SRound(Min(((col and $FF0000) shr 16) * v, 255));
 Result:= r or (g shl 8) or (b shl 16);
end;

procedure ApplyFormatting(Canvas: TCanvas; tagstr: String);
var a: Integer;
    idents: TStrDynAr;
begin
 idents:= ParseCSVLine(tagstr, ',');
 for a:= 0 to High(idents) do begin
   if SameText(idents[a], 'b') then Canvas.Font.Style:= Canvas.Font.Style + [fsBold]
   else if SameText(idents[a], '/b') then Canvas.Font.Style:= Canvas.Font.Style - [fsBold]
   else if SameText(idents[a], 'i') then Canvas.Font.Style:= Canvas.Font.Style + [fsItalic]
   else if SameText(idents[a], '/i') then Canvas.Font.Style:= Canvas.Font.Style - [fsItalic]
   else if SameText(idents[a], 'u') then Canvas.Font.Style:= Canvas.Font.Style + [fsUnderline]
   else if SameText(idents[a], '/u') then Canvas.Font.Style:= Canvas.Font.Style - [fsUnderline]
   else if SameText(idents[a], 's') then Canvas.Font.Style:= Canvas.Font.Style + [fsStrikeOut]
   else if SameText(idents[a], '/s') then Canvas.Font.Style:= Canvas.Font.Style - [fsStrikeOut]
   else if SameText(idents[a], 'black') then Canvas.Font.Color:= clBlack
   else if SameText(idents[a], 'red') then Canvas.Font.Color:= clRed
   else if SameText(idents[a], 'orange') then Canvas.Font.Color:= clOrange
   else if SameText(idents[a], 'maroon') then Canvas.Font.Color:= clMaroon
   else if SameText(idents[a], 'darkorange') then Canvas.Font.Color:= clDarkOrange
   else if SameText(idents[a], 'green') then Canvas.Font.Color:= clGreen
   else if SameText(idents[a], 'olive') then Canvas.Font.Color:= clOlive
   else if SameText(idents[a], 'navy') then Canvas.Font.Color:= clNavy
   else if SameText(idents[a], 'purple') then Canvas.Font.Color:= clPurple
   else if SameText(idents[a], 'teal') then Canvas.Font.Color:= clTeal
   else if SameText(idents[a], 'gray') then Canvas.Font.Color:= clGray
   else if SameText(idents[a], 'silver') then Canvas.Font.Color:= clSilver
   else if SameText(idents[a], 'lime') then Canvas.Font.Color:= clLime
   else if SameText(idents[a], 'yellow') then Canvas.Font.Color:= clYellow
   else if SameText(idents[a], 'blue') then Canvas.Font.Color:= clBlue
   else if SameText(idents[a], 'fuchsia') then Canvas.Font.Color:= clFuchsia
   else if SameText(idents[a], 'aqua') then Canvas.Font.Color:= clAqua
   else if SameText(idents[a], 'white') then Canvas.Font.Color:= clWhite
 end;
end;

function DrawFormattedText(Canvas: TCanvas; txt: String; r: TRect;
  AutoWrap: Boolean): TPoint;
var a, lh, cw, tx, ty, blst: Integer;
    forstart, backslash, drawchar: Boolean;
    LastBrushStyle: TBrushStyle;
begin
 forstart:= False;
 backslash:= False;
 lh:= Canvas.TextHeight('W');
 tx:= r.Left;
 ty:= r.Top;
 Result:= Point(0, 0);
 LastBrushStyle:= Canvas.Brush.Style;
 Canvas.Brush.Style:= bsClear;

 for a:= 1 to Length(txt) do begin
   drawchar:= false;
   case txt[a] of
     '{': if backslash then drawchar:= True
          else begin
            forstart:= True;
            blst:= a + 1;
          end;
     '}': if backslash then drawchar:= True
          else if forstart then begin
            forstart:= False;
            ApplyFormatting(Canvas, Copy(txt, blst, a - blst));
          end;
     '\': if backslash then drawchar:= True else backslash:= True;
     #13: begin
            if tx > Result.X then Result.X:= tx;
            tx:= r.Left;
            Inc(ty, lh);
          end;
     else begin
       if not forstart then drawchar:= True;
     end;
   end;

   if drawchar then begin
     backslash:= False;
     cw:= Canvas.TextWidth(txt[a]);
     if AutoWrap and (tx + cw >= r.Right) then begin //Zawijanie wierszy
       if tx > Result.X then Result.X:= tx;
       tx:= r.Left;
       Inc(ty, lh);
     end;
     Canvas.TextOut(tx, ty, txt[a]);
     Inc(tx, cw);
   end;
 end;

 if tx > Result.X then Result.X:= tx;
 Result.X:= Result.X - r.Left;
 Result.Y:= ty + lh - r.Top;

 Canvas.Brush.Style:= LastBrushStyle;
end;

procedure SetImgSize(img: TImage; Width, Height: Integer);
begin
 img.Width:= Width;
 img.Height:= Height;
 img.Picture.Bitmap.Width:= Width;
 img.Picture.Bitmap.Height:= Height;
end;

procedure DrawTimeGraph(C: TCanvas; R: TRect; BackG: TColor; TStart: Integer;
  YName: String; YData: array of TDoubleDynAr; Legend: array of String);
var a, b, PXStart, DXStart, dl, GridYD: Integer;
    d, MaxY, MinY, ppuy {Pixels Per Unit}, GridY, MinG: Single;
const MinValGrid = 7; //minimalny skok siatki warto�ci (w pikselach)
      Margin = 4; //minimalny odst�p wykresu od g�ry i do�u (w pikselach)
      LineColours: array[0..3] of TColor = (clBlue, clRed, clGreen, clTeal);
begin
 C.Brush.Color:= BackG;
 C.FillRect(R);
 Dec(R.Right, 25); //Miejsce na opisy
 if Length(Legend) > 0 then Dec(R.Bottom, 10); //Miejsce na legend�
 C.Pen.Color:= clBlack;
 C.Brush.Color:= clWhite;
 C.Rectangle(R);

 //Siatka czasu
 TStart:= TStart mod 20; //siatka czasu co 20 pikseli
 C.Pen.Color:= clSilver;
 for a:= 0 to (R.Right - R.Left - TStart - 2) div 20 do begin
   b:= R.Right - 2 - a * 20 - TStart;
   C.MoveTo(b, R.Top + 1);
   C.LineTo(b, R.Bottom - 1);
 end;

 dl:= Length(YData[0]);
 if dl > 0 then begin
   {MaxY:= Low(Integer);
   MinY:= High(Integer);
   for a:= 0 to dl - 1 do begin
     if YData[a] > MaxY then MaxY:= YData[a];
     if YData[a] < MinY then MinY:= YData[a];
   end;}
   MaxY:= MaxValue(YData[0]);
   MinY:= MinValue(YData[0]);
   for a:= 1 to High(YData) do begin
     MaxY:= Max(MaxY, MaxValue(YData[a]));
     MinY:= Min(MinY, MinValue(YData[a]));
   end;
   if MaxY = MinY then begin
     MaxY:= MaxY + 1;
     MinY:= MinY - 1;
   end;
   //Trzeba pami�ta�, �e Rectangle() rysuje prostok�t o 1px w�szy i ni�szy, ni�
   //  to wynika z parametru (tak jak LineTo() nie rysuje ostatniego piksela).
   ppuy:= (R.Bottom - R.Top - Margin*2 - 1) / (MaxY - MinY); //luz z g�ry i z do�u

   //Siatka warto�ci
   Assert(ppuy <> 0, 'DrawTimeGraph');
   GridYD:= Ceil(Log10(MinValGrid / ppuy));  //SRound(Log10(ppuy));
   GridY:= Power(10, GridYD); //skok siatki w jednostkach warto�ci Y
   MinG:= MinY - Margin / ppuy; //Najmniejsza widoczna warto��
   SetRoundMode(rmUp);
   d:= RoundTo(MinG, GridYD); //zaokr�glona do siatki
   SetRoundMode(rmNearest);
   C.Font.Name:= 'Arial'; //Ma�e cyferki �adniej wygl�daj� t� czcionk�
   C.Font.Height:= -8; //Size = 6
   C.Font.Color:= clBlack;
   C.Brush.Color:= BackG;
   a:= R.Bottom - SRound((d - MinG) * ppuy);
   while a > R.Top do begin
     C.MoveTo(R.Right - 2, a);
     C.LineTo(R.Left, a);
     if (a > R.Top + 2) and (a < R.Bottom - 2) then //�eby opisy nie wychodzi�y poza obrys
       C.TextOut(R.Right + 1, a - 5,
         Format('%.' + IntToStr(Max(0, -GridYD)) + 'f', [d]));
     d:= d + GridY;
     a:= R.Bottom - SRound((d - MinG) * ppuy);
   end;
   C.Font.Name:= 'Tahoma';
   C.Font.Height:= -10;
   //C.Font.Orientation:= 90 * 10; //Przekr�cenie o 90 stopni
   C.TextOut(R.Right + 15, R.Bottom - (R.Bottom - R.Top - C.TextWidth(YName) - 1) div 2, YName);
   //C.Font.Orientation:= 0; //Powr�t do poziomu

   PXStart:= Max(R.Right - dl - 1, R.Left + 1); //Pocz�tek wykresu w pikselach
   DXStart:= Max(0, dl - (R.Right - R.Left - 2)); //Perwsza dana do wy�wietlenia

   for b:= 0 to High(YData) do begin
     C.Pen.Color:= LineColours[b];
     //Rysujemy od ko�ca po to, �eby prawa strona zawsze dotyka�a do brzegu
     C.MoveTo(R.Right - 2, R.Bottom - SRound((YData[b, dl-1] - MinY) * ppuy) - Margin);
     for a:= dl - 2 - DXStart downto 0 do
       C.LineTo(PXStart + a, R.Bottom - SRound((YData[b, DXStart + a] - MinY) * ppuy) - Margin);
   end;

   //Legenda
   dl:= High(Legend);
   b:= R.Left;
   for a:= 0 to dl do begin
     C.Pen.Color:= LineColours[a];
     C.MoveTo(b, R.Bottom + 5);
     C.LineTo(b + 15, R.Bottom + 5);
     C.TextOut(b + 18, R.Bottom, Legend[a] + IfThen(a < dl, ';'));
     Inc(b, 18 + C.TextWidth(Legend[a]) + 10);
   end;
 end;

 C.Pen.Color:= clBlack;
 C.MoveTo(R.Left, R.Top);    //Rysujemy drugi raz lini�, �eby zas�oni� ko�c�wk�
 C.LineTo(R.Left, R.Bottom); //  wykresu, kt�ra mog�a na ni� wej��
end;

end.
