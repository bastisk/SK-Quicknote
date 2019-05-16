unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, ComCtrls, Buttons, FileUtil, StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageList1: TImageList;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Memo1EditingDone(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);

  private
    procedure ReloadFiles();
    procedure SaveFile();
    procedure DeleteFileSK();
    procedure NewFile();
  public

  end;

var
  Form1: TForm1;
  ExistingNotes: TStringList;
  DisplayNotes: TStringList;
  FilteredNotes: TStringList;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
 ExistingNotes := TStringList.Create;
 FilteredNotes := TStringList.Create;
 DisplayNotes := TStringList.Create;
 TrayIcon1.Visible := true;
 ListBox1.Items.Clear;
 Memo1.Text:= '';
 ReloadFiles();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 ExistingNotes.Free;
 FilteredNotes.Free;
 DisplayNotes.Free;
end;


procedure TForm1.ListBox1Click(Sender: TObject);
begin
 try
    if  ListBox1.ItemIndex > -1 then begin
       Memo1.Lines.LoadFromFile(FilteredNotes.Strings[ListBox1.ItemIndex]);
       end;
 finally
 end;
end;

procedure TForm1.Memo1EditingDone(Sender: TObject);
begin
 StatusBar1.SimpleText := FormatDateTime('dd.mm.yyyy, hh:nn:ss', now) + ' - Unsaved Changes';
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  SaveFile();
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
 ExistingNotes.Free;
 FilteredNotes.Free;
 DisplayNotes.Free;
 Close();
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  NewFile();
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
 DeleteFileSK();
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
 ExistingNotes.Free;
 FilteredNotes.Free;
 DisplayNotes.Free;
 Close();
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  Form1.WindowState:= wsNormal;
  NewFile();
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  NewFile();
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  SaveFile();
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  DeleteFileSK();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  NewFile();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 SaveFile();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 DeleteFileSK();
end;


procedure TForm1.ReloadFiles();
var
  i: Integer;
  fileExtension: String;
begin
 Form1.ListBox1.Items.Clear;
 ExistingNotes := TStringList.Create;
 FilteredNotes := TStringList.Create;
 DisplayNotes := TStringList.Create;

 FindAllFiles(ExistingNotes, ExtractFilePath(Application.ExeName), '*');
 DisplayNotes.Assign(ExistingNotes);

 for i:= 0 to DisplayNotes.Count - 1 do begin
     DisplayNotes.Strings[i] := ExtractFileName(ExistingNotes.Strings[i]);
     fileExtension := copy(DisplayNotes.Strings[i], DisplayNotes.Strings[i].Length -3, 4);
     if fileExtension = '.txt' then begin
        DisplayNotes.Strings[i] :=  copy(DisplayNotes.Strings[i], 0, DisplayNotes.Strings[i].Length -4);
        Form1.ListBox1.Items.Add(DisplayNotes.Strings[i]);
        FilteredNotes.Add(ExistingNotes.Strings[i]);
     end;
 end;
end;

procedure TForm1.SaveFile();
var UserString, lastSelection: String;
begin
if ListBox1.ItemIndex < 0 then begin
  if InputQuery('Name of new Note', 'Please enter a title for the new note:', FALSE, UserString) then begin
     Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + '/' + UserString + '.txt');
     lastSelection := UserString;
     ReloadFiles();
  end;
end else begin
     Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + '/' + ListBox1.GetSelectedText + '.txt');
     lastSelection:=  ListBox1.GetSelectedText;
     ReloadFiles();
end;
StatusBar1.SimpleText := FormatDateTime('dd.mm.yyyy, hh:nn:ss', now) + ' - File Saved';
ListBox1.ItemIndex := ListBox1.Items.IndexOf(lastSelection);
end;

procedure TForm1.DeleteFileSK();
begin
  if MessageDlg('Are you sure?', 'Do you want to delete this note?', mtConfirmation, [mbYes, mbNo],0) = mrYes then begin
    DeleteFile(ExtractFilePath(Application.ExeName) + '/' + ListBox1.GetSelectedText + '.txt');
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    Memo1.Clear;
    ReloadFiles();
    StatusBar1.SimpleText := FormatDateTime('dd.mm.yyyy, hh:nn:ss', now) + ' - File Deleted';
  end;
end;

procedure TForm1.NewFile();
var UserString: String;
begin
if InputQuery('Name of new Note', 'Please enter a title for the new note:', FALSE, UserString) then begin
   Memo1.Clear;
   Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + '/' + UserString + '.txt');
   ReloadFiles();
   ListBox1.ItemIndex := ListBox1.Items.IndexOf(UserString);
   StatusBar1.SimpleText := FormatDateTime('dd.mm.yyyy, hh:nn:ss', now) + ' - New File Created: ' + UserString;
end;
end;

end.

