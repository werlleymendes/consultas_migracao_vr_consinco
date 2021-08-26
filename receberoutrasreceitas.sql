/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Migração das outras receitas do Banco de dados do VR para o Consinco*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when ro.id_loja = 1 then 1
when ro.id_loja = 2 then 2
when ro.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "CodGerente", 
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa",

FROM receberoutrasreceitas as ro



SELECT * FROM receberoutrasreceitas WHERE id_situacaoreceberoutrasreceitas = 0;

SELECT * FROM receberoutrasreceitasitem LIMIT 10;

SELECT sum(roi.valor) 
FROM receberoutrasreceitas as ro
JOIN receberoutrasreceitasitem as roi
ON ro.id = roi.id_receberoutrasreceitas
WHERE ro.id_situacaoreceberoutrasreceitas = 0;