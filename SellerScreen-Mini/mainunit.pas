unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  StdCtrls, ButtonPanel, ComCtrls, Menus, LCLIntf;

type

  { TMainForm }

  TMainForm = class(TForm)
    CancelBtn: TButton;
    FlowPanel10: TFlowPanel;
    Label8: TLabel;
    MenuItem10: TMenuItem;
    OpenStorageMI: TMenuItem;
    ShowStaticsMI: TMenuItem;
    OpenSettingsMI: TMenuItem;
    AboutMI: TMenuItem;
    GitHubMI: TMenuItem;
    DocsMI: TMenuItem;
    ReloadMI: TMenuItem;
    SaveMI: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PayBtn: TButton;
    RetourBtn: TButton;
    NewCustomerBtn: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ButtonPanel1: TButtonPanel;
    FlowPanel1: TFlowPanel;
    FlowPanel2: TFlowPanel;
    FlowPanel3: TFlowPanel;
    FlowPanel4: TFlowPanel;
    FlowPanel5: TFlowPanel;
    FlowPanel6: TFlowPanel;
    FlowPanel7: TFlowPanel;
    FlowPanel8: TFlowPanel;
    FlowPanel9: TFlowPanel;
    Shoppinglist: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    CancelPurchaseBtn: TButton;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    procedure AboutMIClick(Sender: TObject);
    procedure GitHubMIClick(Sender: TObject);
    procedure DocsMIClick(Sender: TObject);
    procedure OpenStorageMIClick(Sender: TObject);
    procedure SaveMIClick(Sender: TObject);
    procedure ReloadMIClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

uses
  AboutUnit, StorageUnit;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.GitHubMIClick(Sender: TObject);
begin
  OpenURL('https://github.com/tomo2403/SellerScreen-Mini');
end;

procedure TMainForm.DocsMIClick(Sender: TObject);
begin

end;

procedure TMainForm.OpenStorageMIClick(Sender: TObject);
begin
  StorageForm.Show;
end;

procedure TMainForm.SaveMIClick(Sender: TObject);
begin

end;

procedure TMainForm.ReloadMIClick(Sender: TObject);
begin

end;

procedure TMainForm.AboutMIClick(Sender: TObject);
begin
  AboutForm.Show;
end;

end.

