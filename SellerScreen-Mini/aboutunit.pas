unit AboutUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, LCLIntf;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    GitHubBtn: TButton;
    Image1: TImage;
    CopyrightLbl: TLabel;
    TitleLbl: TLabel;
    DevLbl: TLabel;
    InfoTxtLbl: TLabel;
    PublishLbl: TLabel;
    AboutS22Lbl: TLabel;
    procedure AboutS22LblClick(Sender: TObject);
    procedure GitHubBtnClick(Sender: TObject);
  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

{ TAboutForm }


procedure TAboutForm.AboutS22LblClick(Sender: TObject);
begin
  OpenURL('https://github.com/T-App-Germany/SellerScreen-2022');                //Öffnet Projektseite von SellerScreen-2022
end;

procedure TAboutForm.GitHubBtnClick(Sender: TObject);
begin
  OpenURL('https://github.com/tomo2403/SellerScreen-Mini');                     //Öffnet Projektseite von SellerScreen-Mini
end;

end.

