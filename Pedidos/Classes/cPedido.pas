unit cPedido;

interface

uses FireDAC.DApt, FireDAC.Comp.Client, System.SysUtils;

type
  TPedido = Class
  private
    FConnection: TFDConnection;
    FNUM_PEDIDO: Integer;
    FDATA_EMISSAO: TDateTime;
    FCLI_CODIGO: Integer;
    FVL_TOTAL: Double;
  public
    constructor Create(conn: TFDConnection);
    property NUM_PEDIDO: Integer read FNUM_PEDIDO write FNUM_PEDIDO;
    property DATA_EMISSAO: TDateTime read FDATA_EMISSAO write FDATA_EMISSAO;
    property CLI_CODIGO: Integer read FCLI_CODIGO write FCLI_CODIGO;
    property VL_TOTAL: Double read FVL_TOTAL write FVL_TOTAL;

    function Consultar(out erro: string): Boolean;
    function Inserir(out erro: string): Integer;
    function Excluir(out erro: string): Boolean;
    function Alterar(out erro: string): Boolean;
end;


implementation

{TPedido}

constructor TPedido.Create(conn: TFDConnection);
begin
  FConnection := conn;
end;

function TPedido.Alterar(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  if NUM_PEDIDO <= 0 then
  begin
    erro := 'Informe o Número do Pedido';
    Result := false;
    exit;
  end;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := FConnection;
       //Altera o Valor Total do pedido
      with qry do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE db_teste_wk.pedidos');
        SQL.Add('SET Vl_Total = (SELECT SUM(Vl_Total)');
        SQL.Add('FROM db_teste_wk.item_pedido');
        SQL.Add('WHERE Num_pedido = :NUM_PEDIDO)');
        SQL.Add('WHERE Num_pedido = :NUM_PEDIDO');
        ParamByName('NUM_PEDIDO').Value := NUM_PEDIDO;
        ExecSQL;
      end;

      Result := true;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao alterar o Pedido: ' + ex.Message;
    end;
    end;

  finally
      qry.DisposeOf;
  end;

end;

function TPedido.Consultar(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConnection;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM db_teste_wk.pedidos');
      SQL.Add('WHERE Num_pedido = :NUM_PEDIDO');
      ParamByName('NUM_PEDIDO').Value := NUM_PEDIDO;
      Open;
    end;

    if qry.RecordCount = 0 then
    begin
      Result := False;
      erro := 'Número de pedido não encontrado na base de dados ';
    end
    else
    begin
      Result := True;
      erro := '';
    end

  except on ex:exception do
  begin
    Result := False;
    erro := 'Erro ao consultar pedido: ' + ex.Message;
  end;
  end;
end;


function TPedido.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
  // ValidaÇÕES
  if NUM_PEDIDO <= 0 then
  begin
    erro := 'Informe o Nro do pedido';
    Result := false;
    exit;
  end;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := FConnection;
      with qry do
      begin
        //Exclui os itens caso possuam
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM db_teste_wk.item_pedido');
        SQL.Add('WHERE Num_pedido = :NUM_PEDIDO');
        ParamByName('NUM_PEDIDO').Value := NUM_PEDIDO;
        ExecSQL;

        //Exclui o pedido
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM db_teste_wk.pedidos');
        SQL.Add('WHERE Num_pedido = :NUM_PEDIDO');
        ParamByName('NUM_PEDIDO').Value := NUM_PEDIDO;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao excluir pedido: ' + ex.Message;
    end;
    end;

  finally
    qry.DisposeOf;
  end;
end;

function TPedido.Inserir(out erro: string): Integer;
var
  qry : TFDQuery;
begin
  // Validacoes
  if CLI_CODIGO <= 0 then
  begin
      erro := 'Informe o Código do Cliente';
      Result := 0;
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
        SQL.Add('INSERT INTO db_teste_wk.pedidos (Num_Pedido, ' );
        SQL.Add('Data_emissao, Cli_codigo, Vl_total)');
        SQL.Add('VALUES ((SELECT (IFNULL (MAX(ped.Num_pedido), 0) + 1) ');
        SQL.Add('FROM db_teste_wk.pedidos AS ped),');
        SQL.Add(' sysdate(), :CLI_CODIGO, 0 );');
        SQL.Add('SELECT IFNULL(MAX(Num_pedido), 0) AS NewID ' );
        SQL.Add('FROM db_teste_wk.pedidos;');
        ParamByName('CLI_CODIGO').Value := CLI_CODIGO;
        Open;
      end;

      Result := qry.FieldByName('NewId').AsInteger;
      erro := '';

    except on ex:exception do
      begin
        Result := 0;
        erro := 'Erro ao inserir pedido: ' + ex.Message;
      end;
    end;

  finally
    FreeAndNil(qry);
  end;
end;


end.
