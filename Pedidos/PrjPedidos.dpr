program PrjPedidos;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uDados in 'uDados.pas' {Dados: TDataModule},
  cPedido in 'Classes\cPedido.pas',
  cItemPedido in 'Classes\cItemPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDados, Dados);
  Application.Run;
end.
