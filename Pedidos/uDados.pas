unit uDados;

interface

uses FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet,
  System.Classes;

type
  TDados = class(TDataModule)
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDConn: TFDConnection;
    qrExecutar: TFDQuery;
    dsqrItem_pedido: TDataSource;
    qrItem_pedido: TFDQuery;
    qrPedido: TFDQuery;
    dsqrPedido: TDataSource;
    qrItem_pedidoId_item: TFDAutoIncField;
    qrItem_pedidoNum_pedido: TIntegerField;
    qrItem_pedidoProd_codigo: TIntegerField;
    qrItem_pedidoQuantidade: TBCDField;
    qrItem_pedidoVl_unitario: TBCDField;
    qrItem_pedidoVl_total: TFMTBCDField;
    qrPedidoNum_pedido: TIntegerField;
    qrPedidoData_emissao: TDateTimeField;
    qrPedidoCli_codigo: TIntegerField;
    qrPedidoVl_total: TFMTBCDField;
    qrPedidoNome: TStringField;
    qrPedidoCidade: TStringField;
    qrPedidoUF: TStringField;
    qrItem_pedidoDescricao: TStringField;
    Transacao: TFDTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dados: TDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDados.DataModuleCreate(Sender: TObject);
begin
  FDConn.Connected := True;
end;

procedure TDados.DataModuleDestroy(Sender: TObject);
begin
  FDConn.Connected := False;
end;

end.
