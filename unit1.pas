unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, FileUtil, StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private

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
var
  i: Integer;
  fileExtension: String;
begin
 ExistingNotes := TStringList.Create;
 FilteredNotes := TStringList.Create;
 DisplayNotes := TStringList.Create;
 TrayIcon1.Visible := true;
 ListBox1.Items.Clear;
 Memo1.Text:= '';

 FindAllFiles(ExistingNotes, ExtractFilePath(Application.ExeName), '*');
 DisplayNotes.Assign(ExistingNotes);

 for i:= 0 to DisplayNotes.Count - 1 do begin
     DisplayNotes.Strings[i] := ExtractFileName(ExistingNotes.Strings[i]);
     fileExtension := copy(DisplayNotes.Strings[i], DisplayNotes.Strings[i].Length -3, 4);
     if fileExtension = '.txt' then begin
        DisplayNotes.Strings[i] :=  copy(DisplayNotes.Strings[i], 0, DisplayNotes.Strings[i].Length -4);
        ListBox1.Items.Add(DisplayNotes.Strings[i]);
        FilteredNotes.Add(ExistingNotes.Strings[i]);
     end;
 end;

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

procedure TForm1.Button1Click(Sender: TObject);
var UserString, fileExtension: string;
  i: Integer;
begin

    if InputQuery('Name of new Note', 'Please enter a title for the new note:', TRUE, UserString)
  then  begin
     ListBox1.Items.Add(UserString);
     Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + '/' + UserString + '.txt');
     FindAllFiles(ExistingNotes, ExtractFilePath(Application.ExeName), '*');
     DisplayNotes.Assign(ExistingNotes);
      ListBox1.Items.Clear;

 for i:= 0 to DisplayNotes.Count - 1 do begin
     DisplayNotes.Strings[i] := ExtractFileName(ExistingNotes.Strings[i]);
     fileExtension := copy(DisplayNotes.Strings[i], DisplayNotes.Strings[i].Length -3, 4);
     if fileExtension = '.txt' then begin
        DisplayNotes.Strings[i] :=  copy(DisplayNotes.Strings[i], 0, DisplayNotes.Strings[i].Length -4);
        ListBox1.Items.Add(DisplayNotes.Strings[i]);
        FilteredNotes.Add(ExistingNotes.Strings[i]);
     end;
 end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + '/' + ListBox1.GetSelectedText + '.txt');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DeleteFile(ExtractFilePath(Application.ExeName) + '/' + ListBox1.GetSelectedText + '.txt');
  ListBox1.Items.Delete(ListBox1.ItemIndex);


end;

end.

