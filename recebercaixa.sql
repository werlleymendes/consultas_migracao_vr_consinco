/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*TABELA RECEBER CAIXA*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when pf.id_loja = 1 then 1
when pf.id_loja = 2 then 2
when pf.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", 
FROM 






SELECT * FROM recebercaixa LIMIT 10;