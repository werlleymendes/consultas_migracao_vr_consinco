/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*CONTAS A RECEBER*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when pf.id_loja = 1 then 1
when pf.id_loja = 2 then 2
when pf.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", 
FROM 

SELECT * FROM situacaorecebercaixa;

SELECT * FROM recebercaixaitemrecebercaixa;

SELECT * FROM recebercaixavendatef;

select * FROM receberchequehistorico;

SELECT * FROM receberchequeitem;

SELECT * FROM situacaorecebercreditorotativo;

select * from tiporecebivel where id = 45 

SELECT * FROM recebercaixaitem where id_recebercaixa BETWEEN 750 and 1000 ORDER BY id_recebercaixa;

SELECT * FROM tiporecebimento;

SELECT * FROM receberdevolucao WHERE id_situacaoreceberdevolucao = 0;

SELECT * FROM situacaoreceberdevolucao;

SELECT sum(valorliquido) FROM receberverba where id_situacaoreceberverba = 0 and datavencimento <= '2021-04-30';

/*TABELA DO BANCO QUE ARMAZENA OS RECEBÍVEIS DE CARTÃO*/
SELECT sum(valor) FROM recebercaixa where id_situacaorecebercaixa = 0;

SELECT * FROM situacaorecebercaixa;

SELECT sum(valor) FROM recebercheque WHERE id_situacaorecebercheque = 0;

SELECT sum(valor) FROM recebercreditorotativo WHERE id_situacaorecebercreditorotativo = 0;

SELECT * FROM receberoutrasreceitas WHERE id_situacaoreceberoutrasreceitas = 0 and valor = 5.16;

SELECT sum(valorliquido) FROM recebervendaprazo WHERE id_situacaorecebervendaprazo = 0;


SELECT tablename FROM pg_tables WHERE tablename like '%receberdevol%';

;


