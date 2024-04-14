# Scripts para migracao VR para consinco

## Finalidade
Quando migramos do ERP VR(ou outro qualquer) para o Consinco, há a opção de incluir os títulos manualmente, porém para a maioria das empresas isso é muito trabalhoso já que deve haver muitos títulos cadastrados no financeiro. Uma solução para isso é fazer a inclusão via banco de dados. 

## Pré-requisitos

1. Deve ser feito um dblink entre o banco de origem dos dados (no caso da empresa vr)
**Obs: Não é abordado como criar dblink, o DBA da empresa deve ser o responsável por criar.**
2. É necessário a verificação junto com o financeiro/comercial quais tabelas necessitam ser importadas. As tabelas podem ser verificadas no link [Importação dos Títulos a Receber / a Pagar e Cheques](https://tdn.totvs.com/pages/releaseview.action?pageId=573699157).
    - Se a intenção for inserir titulos como no exemplo, duas tabelas são obrigatórias: a tabela **FI_IntTitulo** e a tabela **FI_IntTituloOpe**.
    - A necessidade de importação das outras tabelas dependerá da operação da loja, por exemplo só será nessário importar a tabela **FI_IntTituloComissao** se a loja trabalhar com comissão.
3. Deve ser Criado uma sequence para inserção na tabela 

## Scripts

1. [Contas a pagar.md](https://github.com/werlleymendes/consultas_migracao_vr_consinco/blob/main/Contas%20a%20pagar.md)
2. 


