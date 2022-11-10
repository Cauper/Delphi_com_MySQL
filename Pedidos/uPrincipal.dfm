object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Pedidos'
  ClientHeight = 441
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 23
    Width = 784
    Height = 88
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 2
      Top = 5
      Width = 96
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'C'#243'digo do Cliente.:'
    end
    object DBText1: TDBText
      Left = 104
      Top = 26
      Width = 284
      Height = 17
      Color = clBtnFace
      DataField = 'Nome'
      DataSource = Dados.dsqrPedido
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label5: TLabel
      Left = 6
      Top = 26
      Width = 96
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Nome do Cliente.:'
    end
    object DBText2: TDBText
      Left = 472
      Top = 25
      Width = 109
      Height = 17
      DataField = 'Num_pedido'
      DataSource = Dados.dsqrPedido
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 388
      Top = 30
      Width = 82
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pedido Nro.:'
    end
    object Label7: TLabel
      Left = 2
      Top = 47
      Width = 96
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Cidade.:'
    end
    object DBText3: TDBText
      Left = 100
      Top = 47
      Width = 221
      Height = 17
      DataField = 'Cidade'
      DataSource = Dados.dsqrPedido
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBText4: TDBText
      Left = 100
      Top = 68
      Width = 57
      Height = 17
      DataField = 'UF'
      DataSource = Dados.dsqrPedido
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 2
      Top = 68
      Width = 96
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'UF.:'
    end
    object btn_Gravar_Pedido: TBitBtn
      Left = 681
      Top = 36
      Width = 96
      Height = 32
      Caption = 'Gravar Pedido'
      TabOrder = 4
      OnClick = btn_Gravar_PedidoClick
    end
    object edt_Cli_codigo: TEdit
      Left = 100
      Top = 2
      Width = 60
      Height = 21
      TabOrder = 0
      Text = 'edt_Cli_codigo'
      OnExit = edt_Cli_codigoExit
      OnKeyPress = edt_Prod_codigoKeyPress
    end
    object btn_Novo_Pedido: TBitBtn
      Left = 681
      Top = 2
      Width = 96
      Height = 32
      Caption = 'Novo Pedido'
      TabOrder = 2
      OnClick = btn_Novo_PedidoClick
    end
    object btn_Carregar_Pedido: TBitBtn
      Left = 583
      Top = 2
      Width = 96
      Height = 32
      Caption = 'Carregar Pedido'
      TabOrder = 1
      OnClick = btn_Carregar_PedidoClick
    end
    object btn_Cancelar_Pedido: TBitBtn
      Left = 583
      Top = 36
      Width = 96
      Height = 32
      Caption = 'Cancelar Pedido'
      TabOrder = 3
      OnClick = btn_Cancelar_PedidoClick
    end
  end
  object dbgrd_Produtos: TDBGrid
    Left = 0
    Top = 176
    Width = 784
    Height = 245
    Align = alClient
    DataSource = Dados.dsqrItem_pedido
    FixedColor = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgCancelOnExit, dgTitleHotTrack]
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    OnKeyDown = dbgrd_ProdutosKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'Id_item'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'Num_pedido'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'Prod_codigo'
        Title.Caption = 'C'#243'digo'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Descricao'
        Title.Caption = 'Descri'#231#227'o do Produto'
        Width = 360
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantidade'
        Title.Caption = 'Qtde'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Vl_unitario'
        Title.Caption = 'Valor Unit'#225'rio'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Vl_total'
        Title.Caption = 'Total'
        Width = 100
        Visible = True
      end>
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 421
    Width = 784
    Height = 20
    Panels = <
      item
        Alignment = taRightJustify
        Text = 'Total do Pedido'
        Width = 100
      end
      item
        Text = '1.500,00'
        Width = 100
      end>
  end
  object StaticText1: TStaticText
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 778
    Height = 17
    Align = alTop
    Alignment = taCenter
    Caption = 'Informa'#231#245'es Gerais do Pedido'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object StaticText2: TStaticText
    AlignWithMargins = True
    Left = 3
    Top = 114
    Width = 778
    Height = 17
    Align = alTop
    Alignment = taCenter
    Caption = 'Informa'#231#245'es dos Produtos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    ExplicitTop = 100
  end
  object Panel2: TPanel
    Left = 0
    Top = 134
    Width = 784
    Height = 42
    Align = alTop
    TabOrder = 3
    ExplicitTop = 120
    object Label2: TLabel
      Left = 2
      Top = 12
      Width = 104
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'C'#243'digo do Produto.:'
    end
    object Label3: TLabel
      Left = 369
      Top = 12
      Width = 82
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Quantidade.:'
    end
    object Label4: TLabel
      Left = 520
      Top = 12
      Width = 82
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Valor Unit'#225'rio.:'
    end
    object lbl_Descricao: TLabel
      Left = 174
      Top = 12
      Width = 210
      Height = 13
      AutoSize = False
      Caption = 'lbl_Descricao'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edt_Prod_codigo: TEdit
      Left = 108
      Top = 9
      Width = 60
      Height = 21
      TabOrder = 0
      Text = 'edt_Prod_codigo'
      OnExit = edt_Prod_codigoExit
      OnKeyPress = edt_Prod_codigoKeyPress
    end
    object btn_Incluir_Produto: TBitBtn
      Left = 681
      Top = 5
      Width = 96
      Height = 32
      Caption = 'Incluir Produto'
      TabOrder = 3
      OnClick = btn_Incluir_ProdutoClick
    end
    object edt_Quantidade: TEdit
      Left = 453
      Top = 9
      Width = 60
      Height = 21
      TabOrder = 1
      Text = 'edt_Quantidade'
      OnKeyPress = edt_Vl_unitarioKeyPress
    end
    object edt_Vl_unitario: TEdit
      Left = 604
      Top = 9
      Width = 70
      Height = 21
      TabOrder = 2
      Text = 'edt_Vl_unitario'
      OnKeyPress = edt_Vl_unitarioKeyPress
    end
  end
end
