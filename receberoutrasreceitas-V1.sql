/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Migração das outras receitas do Banco de dados do VR para o Consinco*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
/*A LOJA 4 NO VR PASSOU A SER A 3 NO CONSINCO, POR ISSO A NECESSIDADE DE FAZER O
CASE*/
CASE 
when ro.id_loja = 1 then 1
when ro.id_loja = 2 then 2
when ro.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "CodGerente", 
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa",
/*AS OUTRAS RECEITAS PODEM VIR TANTO DE FORNECEDOR QUANTO DE CLIENTE EVENTUAL
*/
CASE
	WHEN ro.id_clienteeventual is not null THEN LEFT(CAST(ce.cnpj as VARCHAR(14)), -2)
	ELSE LEFT(CAST(f.cnpj as VARCHAR(14)), -2)
END as "CodPessoa",
2 as "TipoCodPessoaNota", 
CASE
	WHEN ro.id_clienteeventual is not null THEN LEFT(CAST(ce.cnpj as VARCHAR(14)), -2)
	ELSE LEFT(CAST(f.cnpj as VARCHAR(14)), -2)
END as "CodPessoaNota",
ro.id as "NroTitulo", null as "SerieTitulo", 1 as "NroParcela", 
/*NÚMERO DA NOTA FISCAL NÃO SE APLICA A ESSA TABELA. AGUARDANDO RESPOSTA DA CONSINCO*/
'' as "NroDocumento", null as "SerieDoc", 
(ro.valor - coalesce(roi.valor, 0)) as "VlrOriginal", ro.dataemissao as "DtaEmissao",
ro.datavencimento as "DtaVencimento", 'P' as "TipoVencOriginal", 
null as "DtaProgramada", (ro.id || ', ' || coalesce(ro.observacao, null)) as "Observacao",
null as "CodigoFator", 'S' as "TituloEmitido", 0::float as "VlrDscFinanc", 
0::float as "PctDescFinanc", ro.datavencimento as "DtaLimDscFinanc",
'S' as "CodCarteira", null as "Banco", null as "Agencia",
null as "NroCompensacao", null as "CtaEmitente", null as "ProprioTerceiro", 
0::varchar as SeqCtaCorrente, null as "NossoNumero", null as "DigNossoNum",
'T' as "TituloCaixa",'BLT' as "TipoNegociacao", null as "NroCarga", 
null as "PerJuroMora", ro.dataemissao as "DtaMovimento", null as "OrdenaCarga",
null as "DtaCarga", 'J' as "Situacao", null as "Origem",
/*Solicitar ajuda do Analista da consinco quando for fazer a migração*/
'' as "SeqTitulo", 1 as "SeqDepositario",
/*Solicitar ajuda do Analista da consinco quando for fazer a migração*/
'' as "NroProcesso", 'ORCAMENTO' as "UsuAlteracao", null as "IndReplicacao",
null as "IndGerouReplicacao", null as "VlrDescComercial", null as "SitCheqDev",
null as "CodBarra", null as "LotePagto", 'N' as "SitJuridica",
null as "Percadministracao",
null as "Vlradministracao", 
null as "Dtacontabilizacao", null as "Linkerp", null as "Qtdparcela", 
null as "Vlrcomissaofat", null as "Seqboleto", null as "Seqmotorista", 
null as "Percdesccontrato", null as "Vlrdesccontrato", null as "Justcancel", 
null as "CMC7", null as "Apporigem"
FROM receberoutrasreceitas as ro
LEFT JOIN fornecedor f ON ro.id_fornecedor = f.id
LEFT JOIN clienteeventual ce ON ro.id_clienteeventual = ce.id
LEFT JOIN (SELECT roi.id_receberoutrasreceitas as id, SUM(roi.valor) as valor FROM receberoutrasreceitasitem roi
JOIN receberoutrasreceitas as ro
ON roi.id_receberoutrasreceitas = ro.id
WHERE ro.id_situacaoreceberoutrasreceitas = 0
GROUP BY 1) as roi
ON ro.id = roi.id
WHERE ro.id_situacaoreceberoutrasreceitas = 0;



SELECT * FROM receberoutrasreceitas WHERE id_situacaoreceberoutrasreceitas = 0;

SELECT * FROM receberoutrasreceitasitem LIMIT 10;

SELECT sum(roi.valor) 
FROM receberoutrasreceitas as ro
JOIN receberoutrasreceitasitem as roi
ON ro.id = roi.id_receberoutrasreceitas
WHERE ro.id_situacaoreceberoutrasreceitas = 0;

SELECT 
CASE
	WHEN ro.id_clienteeventual is not null THEN ce.cnpj
	ELSE f.cnpj
	END AS "CodPessoa"
FROM receberoutrasreceitas as ro
LEFT JOIN fornecedor f ON ro.id_fornecedor = f.id
LEFT JOIN clienteeventual ce ON ro.id_fornecedor = ce.id
WHERE ro.id_situacaoreceberoutrasreceitas = 0;


/*CONSULTA UTILIZADA PARA SOMAR OS ABATIMENTOS DAS OUTRAS RECEITAS*/
SELECT roi.id_receberoutrasreceitas as id, SUM(roi.valor) as valor FROM receberoutrasreceitasitem roi
JOIN receberoutrasreceitas as ro
ON roi.id_receberoutrasreceitas = ro.id
WHERE ro.id_situacaoreceberoutrasreceitas = 0
GROUP BY 1;

SELECT * FROM clienteeventual;

SELECT * FROM receberoutrasreceitas WHERE id = 3609;
