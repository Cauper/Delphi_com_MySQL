unit cItemPedido;

interface

uses FireDAC.DApt, FireDAC.Comp.Client, System.SysUtils;

type
  TItemPedido = Class
  private
    FConnection: TFDConnection;
    FID_ITEM: Integer;
    FNUM_PEDIDO: Integer;
    FPROD_CODIGO: Integer;
    FQUANTIDADE: Double;
    FVL_UNITARIO: Double;
    FVL_TOTAL: Double;
  public
    constructor Create(conn: TFDConnection);
    property ID_ITEM: Integer read FID_ITEM write FID_ITEM;
    property NUM_PEDIDO: Integer read FNUM_PEDIDO write FNUM_PEDIDO;
    property PROD_CODIGO: Integer read FPROD_CODIGO write FPROD_CODIGO;
    property QUANTIDADE: Double read FQUANTIDADE write FQUANTIDADE;
    property VL_UNITARIO: Double read FVL_UNITARIO write FVL_UNITARIO;
    property VL_TOTAL: Double read FVL_TOTAL write FVL_TOTAL;

    function Inserir(out erro: string): Boolean;
    function Excluir(out erro: string): Boolean;
    function Alterar(out erro: string): Boolean;


end;

implementation
{TItemPedido}

function TItemPedido.Alterar(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  // Validacoes
  if ID_ITEM <= 0 then
  begin
      erro := 'Informe o Código do Item do pedido';
      Result := False;
      exit;
  end;
  if QUANTIDADE <= 0 then
  begin
      erro := 'Informe a Quantidade  do produto';
      Result := False;
      exit;
  end;
  if VL_UNITARIO <= 0 then
  begin
      erro := 'Informe o Valor Unitário do produto';
      Result := False;
      exit;
  end;
  if VL_TOTAL <= 0 then
  begin
      erro := 'Informe o Valor Total do produto';
      Result := False;
      exit;
  end;


  try
    try
      //Cria o componente qry e atribui a conexão atual
      qry := TFDQuery.Create(nil);
      qry.Connection := FConnection;

      //Monta a query e insere o novo pedido
      with qry do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE db_teste_wk.item_pedido');
        SQL.Add('SET Quantidade = :QTDE, Vl_unitario = :VALORUNIT,');
        SQL.Add('Vl_total = :TOTAL');
        SQL.Add('WHERE Id_item = :ID_ITEM');
        ParamByName('QTDE').Value := QUANTIDADE;
        ParamByName('VALORUNIT').Value := VL_UNITARIO;
        ParamByName('TOTAL').Value := VL_TOTAL;
        ParamByName('ID_ITEM').Value := ID_ITEM;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
      begin
        Result := False;
        erro := 'Erro ao alterar item do pedido: ' + ex.Message;
      end;
    end;

  finally
    FreeAndNil(qry);
  end;
end;

constructor TItemPedido.Create(conn: TFDConnection);
begin
  FConnection := conn;
end;


function TItemPedido.Excluir(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  // Validacoes
  if ID_ITEM <= 0 then
  begin
      erro := 'Informe o Código do Item do pedido';
      Result := False;
      exit;
  end;

  try
    try
      //Cria o componente qry e atribui a conexão atual
      qry := TFDQuery.Create(nil);
      qry.Connection := FConnection;

      //Monta a query e exclui o item do pedido
      with qry do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM db_teste_wk.item_pedido');
        SQL.Add('WHERE Id_item = :ID_ITEM');
        ParamByName('ID_ITEM').Value := ID_ITEM;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
      begin
        Result := False;
        erro := 'Erro ao excluir item do pedido: ' + ex.Message;
      end;
    end;

  finally
    FreeAndNil(qry);
  end;
end;

function TItemPedido.Inserir(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  // Validacoes
  if PROD_CODIGO <= 0 then
  begin
      erro := 'Informe o Código do Produto';
      Result := False;
      exit;
  end;
  if QUANTIDADE <= 0 then
  begin
      erro := 'Informe a Quantidade do Produto';
      Result := False;
      exit;
  end;
  if VL_UNITARIO <= 0 then
  begin
      erro := 'Informe o Valor Unitário Produto';
      Result := False;
      exit;
  end;
  if VL_TOTAL <= 0 then
  begin
      erro := 'Informe o Valor Total do produto';
      Result := False;
      exit;
  end;

  try
    try
      //Cria o componente qry e atribui a conexão atual
      qry := TFDQuery.Create(nil);
      qry.Connection := FConnection;

      //Monta a query e insere o item do pedido
      with qry do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO db_teste_wk.item_pedido');
        SQL.Add('(Num_pedido, Prod_codigo, Quantidade, Vl_unitario, Vl_total)');
        SQL.Add('VALUES (:NUM_PEDIDO, :PROD_CODIGO , :QTDE, :VALORUNIT, :TOTAL)');
        ParamByName('NUM_PEDIDO').Value := NUM_PEDIDO;
        ParamByName('PROD_CODIGO').Value := PROD_CODIGO;
        ParamByName('QTDE').Value := QUANTIDADE;
        ParamByName('VALORUNIT').Value := VL_UNITARIO;
        ParamByName('TOTAL').Value := VL_TOTAL;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
      begin
        Result := False;
        erro := 'Erro ao inserir item no pedido: ' + ex.Message;
      end;
    end;

  finally
    FreeAndNil(qry);
  end;
end;

end.
