unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.DBCtrls,
  System.UITypes, FireDAC.Comp.Client, FireDAC.DApt;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    dbgrd_Produtos: TDBGrid;
    btn_Gravar_Pedido: TBitBtn;
    StatusBar: TStatusBar;
    edt_Cli_codigo: TEdit;
    Label1: TLabel;
    btn_Novo_Pedido: TBitBtn;
    btn_Carregar_Pedido: TBitBtn;
    btn_Cancelar_Pedido: TBitBtn;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Panel2: TPanel;
    Label2: TLabel;
    edt_Prod_codigo: TEdit;
    btn_Incluir_Produto: TBitBtn;
    edt_Quantidade: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edt_Vl_unitario: TEdit;
    DBText1: TDBText;
    Label5: TLabel;
    DBText2: TDBText;
    Label6: TLabel;
    Label7: TLabel;
    DBText3: TDBText;
    DBText4: TDBText;
    Label8: TLabel;
    lbl_Descricao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_Novo_PedidoClick(Sender: TObject);
    procedure edt_Vl_unitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edt_Prod_codigoKeyPress(Sender: TObject; var Key: Char);
    procedure btn_Incluir_ProdutoClick(Sender: TObject);
    procedure btn_Carregar_PedidoClick(Sender: TObject);
    procedure btn_Gravar_PedidoClick(Sender: TObject);
    procedure dbgrd_ProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_Prod_codigoExit(Sender: TObject);
    procedure btn_Cancelar_PedidoClick(Sender: TObject);
    procedure edt_Cli_codigoExit(Sender: TObject);
  private
    procedure ZerarTela;
    procedure AjustarTelaItensPedido(modo: Char);
    procedure AtualizarTotaldoPedido(numpedido: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uDados, cPedido, cItemPedido;

function  Retorma_Numero(Key: Char; Texto: string; EhDecimal: Boolean = False): Char;
begin
  if  not EhDecimal then
  begin
    { Chr(8) = Back Space }
    if  not (Key in ['0'..'9', ',','.', Chr(8)]) then
        Key := #0
  end
  else
  begin
    if  (Key = #46) or (Key = #44) then
      Key := FormatSettings.DecimalSeparator;
    if  not (Key in ['0'..'9', Chr(8), FormatSettings.DecimalSeparator]) then
      Key := #0
    else
      if (Key = FormatSettings.DecimalSeparator) and (Pos( Key, Texto) > 0) then
        Key := #0;
  end;
  Result := Key;
end;

procedure TfrmPrincipal.ZerarTela;
begin
  //Limpa os Edit's
  edt_Cli_codigo.Text := '';
  edt_Prod_codigo.Text := '';
  lbl_Descricao.Caption := '';
  edt_Quantidade.Text := '';
  edt_Vl_unitario.Text := '';

  //Habilita Edit do código do Cliente
  edt_Cli_codigo.Enabled := True;
  //Desabilita os Edit's dos produtos
  edt_Prod_codigo.Enabled := False;
  edt_Quantidade.Enabled := False;
  edt_Vl_unitario.Enabled := False;

  //Habilita/Desabilita botões
  btn_Carregar_Pedido.Enabled := True;
  btn_Novo_Pedido.Enabled := False;
  btn_Cancelar_Pedido.Enabled := True;
  btn_Gravar_Pedido.Enabled := False;

  btn_Incluir_Produto.Enabled := False;
  btn_Incluir_Produto.Caption := 'Incluir Produto';

  //Seta tag do botão: 0-Inclusão, 1 - Alteração
  btn_Incluir_Produto.Tag := 0;

  //Deixa como zero o valor total do pedido
  StatusBar.Panels[1].Text := '0,00';

  //Se o form estiver ativo, fecha as tabelas
  if frmPrincipal.Active then
  begin
    Dados.qrItem_pedido.Close;
    Dados.qrPedido.Close;
    edt_Cli_codigo.SetFocus;
  end;

end;

procedure TfrmPrincipal.btn_Cancelar_PedidoClick(Sender: TObject);
var erro:String;
  numpedido :Integer;
  ped : TPedido;
begin
  try
    //Solicita do usuário o número do pedido
    numpedido := StrToIntDef(Trim(inputBox('Cancelar/Excluir Pedido',
                                           ' Digite o número do pedido:','')), 0);
    if numpedido = 0 then
      raise Exception.Create('Número de pedido inválido');

    with Dados do
    begin
    //Nesta parte do código estou usando propositalmente a FDQuery do DataModule
    //para mostrar as informações do pedido quando o MessageDlg abrir
    //Localizar o pedido pelo número digitado
      qrItem_pedido.Close;
      qrPedido.Close;
      qrPedido.ParamByName('NUM_PEDIDO').Value := numpedido;
      qrPedido.Open;
      qrItem_pedido.Open;
      if qrPedido.RecordCount = 0 then
        raise Exception.Create('Número de pedido não encontrado!!');
      edt_Cli_codigo.Text := qrPedidoCli_codigo.AsString;

    //Pergunta se quer apagar o pedido informado
      if MessageDlg('Confirma exclusão do pedido: '+chr(13) +
           'Nro ' + IntToStr(numpedido) + ' Cliente: ' + qrPedidoNome.AsString,
           mtWarning, [mbYes, mbCancel], 0) = mrYes then
      begin
    //Excluir o Pedido utilizando a classe TPedido
        ped := TPedido.Create(Dados.FDConn);
        ped.NUM_PEDIDO := numpedido;
        if ped.Excluir(erro) = False then
        begin
          MessageDlg(erro, mtError, [mbOk], 0);
          Exit;
        end;

    //Faz o commit da transação
        if Transacao.Active then
          Transacao.Commit;
      end;
    //Fecha as tabelas
        if qrPedido.Active then
        begin
          qrItem_pedido.Close;
          qrPedido.Close;
        end;

    //Coloca o foco no Edit do Código do Cliente
      edt_Cli_codigo.Text := '';
      edt_Cli_codigo.SetFocus;
    end;
  finally
    FreeAndNil(ped);
  end;
end;

procedure TfrmPrincipal.btn_Carregar_PedidoClick(Sender: TObject);
var
  numpedido :String;
begin
  numpedido := Trim(inputBox('Carregar Pedido', ' Digite o número do pedido:',''));
  if StrToIntDef(numpedido,0) = 0 then
    raise Exception.Create('Código do pedido inválido');
    //Busca o pedido digitado
  with Dados do
  begin
    qrItem_pedido.Close;
    qrPedido.Close;
    qrPedido.ParamByName('NUM_PEDIDO').Value := StrToInt(numpedido);
    qrPedido.Open;
    if qrPedido.RecordCount = 0 then
      raise Exception.Create('Número de pedido não encontrado!!');

    edt_Cli_codigo.Text := qrPedidoCli_codigo.AsString;
    StatusBar.Panels[1].Text := qrPedidoVl_total.DisplayText;
    qrItem_pedido.Close;
    qrItem_pedido.Open;

    //Habilita/Desabilita componente
    edt_Cli_codigo.Enabled := False;
    btn_Carregar_Pedido.Enabled := False;
    btn_Novo_Pedido.Enabled := True;
    btn_Cancelar_Pedido.Enabled := False;
    btn_Gravar_Pedido.Enabled := False;//Dados.Transacao.Active;
    btn_Incluir_Produto.Enabled := False;
    btn_Incluir_Produto.Caption := 'Incluir Produto';

    //Habilita os Edit's dos produtos
    AjustarTelaItensPedido('I');
    //Coloca o foco no Edit do Código do Cliente
    edt_Prod_codigo.SetFocus;
  end;
end;

procedure TfrmPrincipal.btn_Gravar_PedidoClick(Sender: TObject);
begin
  Dados.Transacao.Commit;
  //Habilitar o botão de 'Gravar' e 'Novo' de acordo com o status da Transacao
  btn_Gravar_Pedido.Enabled := Dados.Transacao.Active;
  btn_Novo_Pedido.Enabled := not Dados.Transacao.Active;

  //Posiciona o cursor no Edit do código do produto
  edt_Prod_codigo.SetFocus;
end;

procedure TfrmPrincipal.btn_Incluir_ProdutoClick(Sender: TObject);
var codproduto, numpedido, iditem:Integer;
    vlunitario, qtde: Double;
    erro: String;
    iped: TItemPedido;
begin
  try
    //Carrega as variáveis com as informações do Item do Pedido
    numpedido := Dados.qrPedidoNum_Pedido.Value;
    codproduto := StrToInt(edt_Prod_codigo.Text);
    iditem := edt_Prod_codigo.Tag;
    qtde := StrToFloatDef(edt_Quantidade.Text, -1);
    vlunitario := StrToFloatDef(edt_Vl_unitario.Text, -1);

    //Valida se a quantidade ou o valor unitário são válidos
    if (qtde < 0) or (vlunitario < 0) then
      raise Exception.Create('Verifique se quantidade ou o valor unitário estão corretos.'+
        chr(13) + 'Pode ser necessário trocar ''.'' por '','' ou vice-versa ');

    if btn_Incluir_Produto.Tag = 0 then
    begin
    //Insere o produto usando a clase TItemPedido
      iped := TItemPedido.Create(Dados.FDConn);
      iped.NUM_PEDIDO := numpedido;
      iped.PROD_CODIGO := codproduto;
      iped.QUANTIDADE := qtde;
      iped.VL_UNITARIO := vlunitario;
      iped.VL_TOTAL := qtde * vlunitario;
      if iped.Inserir(erro) = False then
      begin
        MessageDlg(erro, mtError, [mbOk], 0);
        Exit
      end;
    end
    else
    begin
    //Altera o produto usando a clase TItemPedido
      iped := TItemPedido.Create(Dados.FDConn);
      iped.ID_ITEM := iditem;
      iped.QUANTIDADE := qtde;
      iped.VL_UNITARIO := vlunitario;
      iped.VL_TOTAL := qtde * vlunitario;
      if iped.Alterar(erro) = False then
      begin
        MessageDlg(erro, mtError, [mbOk], 0);
        Exit
      end;

    //Voltar a Tag e o Caption padrões do botão btn_Incluir_Produto
      btn_Incluir_Produto.Tag := 0;
      btn_Incluir_Produto.Caption := 'Incluir Produto';
    end;

    //Atualiza Valor Total do Pedido
    AtualizarTotaldoPedido(numpedido);

    //Zera informações da tela dos produtos
    AjustarTelaItensPedido('I');
    edt_Prod_codigo.SetFocus;

    //Habilitar o botão de 'Gravar' e 'Novo' de acordo com o status da Transacao
    btn_Gravar_Pedido.Enabled := Dados.Transacao.Active;
    btn_Novo_Pedido.Enabled := not Dados.Transacao.Active;
  finally
    FreeAndNil(iped)
  end;
end;

procedure TfrmPrincipal.AtualizarTotaldoPedido (numpedido:Integer);
var erro: String;
     ped: TPedido;
begin
  try
    //atualizar o grid dos itens
    Dados.qrItem_pedido.Refresh;

    //Usa a clase TPedido para atualizar o total do pedido
    ped := TPedido.Create(Dados.FDConn);
    ped.NUM_PEDIDO := numpedido;
    if ped.Alterar(erro) = False then
    begin
      MessageDlg(erro, mtError, [mbOk],0);
      Exit;
    end;

    //Atualiza a tabela dos Pedidos
    Dados.qrPedido.Refresh;

    //Altera o rodapé com o novo valor
    StatusBar.Panels[1].Text := Dados.qrPedidoVl_total.DisplayText;
  finally
     FreeAndNil(ped);
  end;
end;

Procedure TfrmPrincipal.AjustarTelaItensPedido(modo: Char);
begin
  if modo = 'I' then
  begin
    edt_Prod_codigo.Enabled := True;
    edt_Prod_codigo.Tag := 0;
    edt_Prod_codigo.Text := '';
    lbl_Descricao.Caption := '';
    edt_Quantidade.Enabled := False;
    edt_Quantidade.Text := '';
    edt_Vl_unitario.Enabled := False;
    edt_Vl_unitario.Text := '';
    btn_Incluir_Produto.Enabled := False;
    btn_Incluir_Produto.Tag := 0;
    btn_Incluir_Produto.Caption := 'Incluir Produto';
  end
  else if modo = 'A' then
  begin
    edt_Prod_codigo.Enabled := False;
    edt_Quantidade.Enabled := True;
    edt_Vl_unitario.Enabled := True;
    btn_Incluir_Produto.Enabled := True;
    btn_Incluir_Produto.Caption := 'Atualizar Produto';
  end;
end;

procedure TfrmPrincipal.btn_Novo_PedidoClick(Sender: TObject);
begin
  ZerarTela;
end;

procedure TfrmPrincipal.dbgrd_ProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var numpedido:Integer;
  erro: String;
  iped: TItemPedido;
begin
  //Pressionou a tecla Enter
  if Key = VK_RETURN then
  begin
    //Desabilita o Edit do Códio e habilita os edits da Quantidade e Valor Unitário
    AjustarTelaItensPedido('A');

    //Preenche os edits com as informações do item do pedido
    edt_Prod_codigo.Text := Dados.qrItem_pedidoProd_codigo.AsString;
    edt_Prod_codigo.Tag := Dados.qrItem_pedidoId_item.Value;
    lbl_Descricao.Caption := Dados.qrItem_pedidoDescricao.Value;
    edt_Quantidade.Text := Dados.qrItem_pedidoQuantidade.AsString;
    edt_Vl_unitario.Text := Dados.qrItem_pedidoVl_unitario.AsString;
    edt_Quantidade.SetFocus;

    //Habilita e muda tag do botão para alteração
    btn_Incluir_Produto.Tag := 1;
    btn_Incluir_Produto.Enabled := True;

  end
  else //Pressionou a tecla Del ou Delete
  if Key = VK_DELETE then
  begin
    //Pergunta se quer excluir o item, monstrando o Código e Descrição
    if MessageDlg('Tem certeza que deseja excluir o item atual?' + Chr(13)+
      Dados.qrItem_pedidoProd_codigo.AsString + '-' +
      Dados.qrItem_pedidoDescricao.AsString, mtWarning, [mbYes, mbNo],0) = mrYes then
    begin
    //Utiliza a classe TItemPedido para excluir o item
      numpedido := Dados.qrPedidoNum_pedido.Value;
      iped := TItemPedido.Create(Dados.FDConn);
      iped.ID_ITEM := Dados.qrItem_pedidoId_item.Value;
      if iped.Excluir(erro) = False then
      begin
        MessageDlg(erro, mtError, [mbOk], 0);
        Exit
      end;

    //Atualiza o total do Pedido
      AtualizarTotaldoPedido(numpedido);
    end;
  end;

end;

procedure TfrmPrincipal.edt_Cli_codigoExit(Sender: TObject);
var nome, erro: String;
    numpedido, codcliente: Integer;
    ped : TPedido;
begin
  try
    if Trim(edt_Cli_codigo.Text) <> '' then
    begin
      with Dados do
      begin
        codcliente := StrToIntDef(edt_Cli_codigo.Text,0);
      //Pesquisa cliente pelo código para verificar se existe
        qrExecutar.Close;
        qrExecutar.SQL.Clear;
        qrExecutar.SQL.Add('SELECT * FROM clientes ');
        qrExecutar.SQL.Add('WHERE Cli_Codigo = :CLI_CODIGO');
        qrExecutar.ParamByName('CLI_CODIGO').Value := codcliente;
        qrExecutar.Open;

      //Se retornar query vazia, manda mensagem para o usuário
        if qrExecutar.RecordCount = 0 then
        begin
          edt_Cli_codigo.Text := '';
          edt_Cli_codigo.SetFocus;
          raise Exception.Create('Código de Cliente não encontrado!!');
        end;

      //Gera um novo pedido para o código de cliente informado
        nome := qrExecutar.FieldByName('Nome').AsString;

        if MessageDlg('Confirmar novo pedido para o cliente' + Chr(13) + ' ('+ IntToStr(codcliente) +
           ') - ' + nome + '?', mtConfirmation, [mbYes, mbCancel],0) = mrYes  then
        begin

      //Usar a classe para inserir o Pedido
          ped := TPedido.Create(Dados.FDConn);
          ped.CLI_CODIGO := codcliente;

          numpedido := ped.Inserir(erro);
      //Posiciona o registro no novo pedido
          qrPedido.Close;
          qrPedido.ParamByName('NUM_PEDIDO').Value := numpedido;
          qrPedido.Open;
          StatusBar.Panels[1].Text := qrPedidoVl_total.DisplayText;
          qrItem_pedido.Close;
          qrItem_pedido.Open;

      //Habilita/Desabilita componente
          edt_Cli_codigo.Enabled := False;
          btn_Carregar_Pedido.Enabled := False;
          btn_Novo_Pedido.Enabled := False;
          btn_Cancelar_Pedido.Enabled := False;
          btn_Gravar_Pedido.Enabled := Dados.Transacao.Active;

      //Ajusta Componentes dos Itens do Pedido
          AjustarTelaItensPedido('I');
          edt_Prod_codigo.SetFocus;

        end
        else
        begin
      //Zera o Edit para digitar novo código do cliente
          edt_Cli_codigo.Text := '';
          edt_Cli_codigo.SetFocus;
        end;
      end;
    end;
  finally
    FreeAndNil(ped);
  end;

end;

procedure TfrmPrincipal.edt_Prod_codigoExit(Sender: TObject);
begin
  if Trim(edt_Prod_codigo.Text) <> '' then
  begin
    with Dados do
    begin
      qrExecutar.Close;
      qrExecutar.SQL.Clear;
      qrExecutar.SQL.Add('SELECT * FROM produtos');
      qrExecutar.SQL.Add('WHERE Prod_codigo = :PROD_CODIGO ');
      qrExecutar.ParamByName('PROD_CODIGO').Value := Trim(edt_Prod_codigo.Text);
      qrExecutar.Open;
      if qrExecutar.RecordCount = 0 then
      begin
        edt_Prod_codigo.Text := '';
        lbl_Descricao.Caption := '';
        btn_Incluir_Produto.Enabled := False;
        edt_Quantidade.Enabled := False;
        edt_Vl_unitario.Enabled := False;
        edt_Prod_codigo.SetFocus;
        raise Exception.Create('Código de produto não encontrado!!');
      end;

      lbl_Descricao.Caption := qrExecutar.FieldByName('Descricao').AsString;

      edt_Quantidade.Enabled := True;
      edt_Vl_unitario.Enabled := True;

      btn_Incluir_Produto.Enabled := True;
      edt_Quantidade.SetFocus;

    end;
  end
  else
  begin
    lbl_Descricao.Caption := '';
    btn_Incluir_Produto.Enabled := False;
    edt_Quantidade.Enabled := False;
    edt_Vl_unitario.Enabled := False;

  end;

end;

procedure TfrmPrincipal.edt_Prod_codigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(ActiveControl as TWinControl,True,True);
    Key := #0;
  end;

end;

procedure TfrmPrincipal.edt_Vl_unitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(ActiveControl as TWinControl,True,True);
    Key := #0;
  end;
  Key := Retorma_Numero(Key, (Sender as TEdit).Text);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  ZerarTela;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  Dados.qrPedido.Close;
  Dados.qrItem_pedido.Close;
  edt_Cli_codigo.SetFocus;

end;

end.
