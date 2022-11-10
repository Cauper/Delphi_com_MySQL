# Delphi_com_MySQL
Este é um exemplo de um tela simples de inclusão de pedidos, onde é informado o código do cliente e 
depois os códigos dos produtos que irão fazer parte do pedido.
Foi utilizado como banco o MySQL, também foram criados duas classes, a TPedido e TItemPedido, para 
manipular a inclusão, alteração e exclusão das informaçoes.
No arquivo TXT 'Banco de Dados' estão todos os comandas para criar a base de dados, 
tabelas e inserção de dados para exemplo.
Dado o tempo para desenvolver este exemplo (2 dias) foram incluídas as validações e verificações basicas de erro
Não foi utilizado utilizado transição com COMMIT automático, para salvar os dados do pedido é necessário 
clicar no botão Gravar Pedido, para que, tanto os dados do pedido quanto dos itens sejam efetivados no banco.
Não foi criado Trigger para a exclusão dos itens do pedido quando o pedido é excluido, essa exclusão está sendo feita manualmente
