object Dados: TDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 409
  Width = 649
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Users\allan\Desktop\Anderson\Testes\WK Technologies\Pedidos\L' +
      'ib\libmysql.dll'
    Left = 540
    Top = 144
  end
  object FDConn: TFDConnection
    Params.Strings = (
      'User_Name=usr_banco'
      'Password=Teste@1324'
      'Database=db_teste_wk'
      'Server=localhost'
      'DriverID=MySQL')
    TxOptions.AutoStart = False
    TxOptions.AutoStop = False
    TxOptions.DisconnectAction = xdNone
    LoginPrompt = False
    Left = 536
    Top = 28
  end
  object qrExecutar: TFDQuery
    Connection = FDConn
    Transaction = Transacao
    Left = 52
    Top = 32
  end
  object dsqrItem_pedido: TDataSource
    AutoEdit = False
    DataSet = qrItem_pedido
    Left = 188
    Top = 84
  end
  object qrItem_pedido: TFDQuery
    MasterSource = dsqrPedido
    MasterFields = 'Num_pedido'
    Connection = FDConn
    SQL.Strings = (
      'SELECT ip.*, prod.Descricao'
      'FROM item_pedido ip'
      '  LEFT JOIN produtos prod ON (ip.Prod_codigo = prod.Prod_codigo)'
      'WHERE ip.Num_Pedido = :Num_pedido')
    Left = 188
    Top = 36
    ParamData = <
      item
        Name = 'NUM_PEDIDO'
        ParamType = ptInput
      end>
    object qrItem_pedidoId_item: TFDAutoIncField
      FieldName = 'Id_item'
      Origin = 'Id_item'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qrItem_pedidoNum_pedido: TIntegerField
      FieldName = 'Num_pedido'
      Origin = 'Num_pedido'
      Required = True
    end
    object qrItem_pedidoProd_codigo: TIntegerField
      FieldName = 'Prod_codigo'
      Origin = 'Prod_codigo'
      Required = True
    end
    object qrItem_pedidoQuantidade: TBCDField
      FieldName = 'Quantidade'
      Origin = 'Quantidade'
      Required = True
      Precision = 15
    end
    object qrItem_pedidoVl_unitario: TBCDField
      FieldName = 'Vl_unitario'
      Origin = 'Vl_unitario'
      Required = True
      DisplayFormat = '##,###,##0.0000'
      Precision = 15
    end
    object qrItem_pedidoVl_total: TFMTBCDField
      FieldName = 'Vl_total'
      Origin = 'Vl_total'
      Required = True
      DisplayFormat = '##,###,##0.00'
      Precision = 18
      Size = 2
    end
    object qrItem_pedidoDescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Descricao'
      Origin = 'Descricao'
      ProviderFlags = []
      ReadOnly = True
      Size = 140
    end
  end
  object qrPedido: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT Ped.*, Cli.Nome, Cli.Cidade, Cli.UF'
      'FROM pedidos Ped'#10
      'LEFT JOIN clientes Cli ON (Ped.Cli_codigo = Cli.Cli_Codigo)'
      'WHERE Ped.Num_pedido = :NUM_PEDIDO')
    Left = 292
    Top = 36
    ParamData = <
      item
        Name = 'NUM_PEDIDO'
        ParamType = ptInput
        Value = Null
      end>
    object qrPedidoNum_pedido: TIntegerField
      FieldName = 'Num_pedido'
      Origin = 'Num_pedido'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      DisplayFormat = '000000'
    end
    object qrPedidoData_emissao: TDateTimeField
      FieldName = 'Data_emissao'
      Origin = 'Data_emissao'
      Required = True
    end
    object qrPedidoCli_codigo: TIntegerField
      FieldName = 'Cli_codigo'
      Origin = 'Cli_codigo'
      Required = True
    end
    object qrPedidoVl_total: TFMTBCDField
      FieldName = 'Vl_total'
      Origin = 'Vl_total'
      Required = True
      DisplayFormat = '##,###,##0.00'
      Precision = 18
      Size = 2
    end
    object qrPedidoNome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Nome'
      Origin = 'Nome'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qrPedidoCidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Cidade'
      Origin = 'Cidade'
      ProviderFlags = []
      ReadOnly = True
      Size = 70
    end
    object qrPedidoUF: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'UF'
      Origin = 'UF'
      ProviderFlags = []
      ReadOnly = True
      Size = 2
    end
  end
  object dsqrPedido: TDataSource
    AutoEdit = False
    DataSet = qrPedido
    Left = 292
    Top = 84
  end
  object Transacao: TFDTransaction
    Options.AutoStart = False
    Options.AutoStop = False
    Options.DisconnectAction = xdNone
    Connection = FDConn
    Left = 536
    Top = 88
  end
end
