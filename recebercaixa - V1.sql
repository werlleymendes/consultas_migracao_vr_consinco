/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*TABELA RECEBER CAIXA*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when rc.id_loja = 1 then 1
when rc.id_loja = 2 then 2
when rc.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "TipoCodGerente", 
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa", 
--AGUARDANDO RESPOSTA DA VANDINHA DE ONDE EU PEGO OS CNPJS, OU DO RODRIGUES SE PODE
--OU DO RODRIGUES SE PODE DEIXAR COMO NULL
'' as "CodPessoa", 
2 as "TipoCodPessoaNota",
--AGUARDANDO RESPOSTA DA VANDINHA DE ONDE EU PEGO OS CNPJS, OU DO RODRIGUES SE PODE
--OU DO RODRIGUES SE PODE DEIXAR COMO NULL
'' as "CodPessoaNota",
rc.id as "NroTitulo", null as "SerieTitulo", 1 as "NroParcela", rc.id as "NroDocumento",
null as "SerieDoc", 
(rc.valor - coalesce(rci.valor, 0)) as "VlrOriginal", rc.dataemissao as "DtaEmissao",
rc.datavencimento as "DtaVencimento", 'P' as "TipoVencOriginal", null as "DtaProgramada",
(rc.id || ', ' || coalesce(rc.observacao)) as "Observacao", 
null as "CodigoFator", 'S' as "TituloEmitido", 0::float as "VlrDscFinanc", 
0::float as "PctDescFinanc", rc.datavencimento as "DtaLimDscFinanc", 
'S' as "CodCarteira", null as "Banco",
null as "Agencia", null as "NroCompensacao", null as "CtaEmitente", 
null as "ProprioTerceiro", 0 as "SeqCtaCorrente", null as "NossoNumero",
null as "DigNossoNum", 'T' as "TituloCaixa", 'BLT' as "TipoNegociacao",
null as "NroCarga", 0::float as "PerJuroMora", rc.dataemissao as "DtaMovimento",
null as "OrdenaCarga", null as "DtaCarga", 'J' as "Situacao", 
null as "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
'' as "SeqTitulo", 1 as "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
'' as "NroProcesso", 'ORCAMENTO' as "UsuAlteracao", null as "IndReplicacao", 
null as "IndGerouReplicacao", null as "VlrDescComercial", 'H' as "SitCheqDev",
null as "CodBarra", null as "LotePagto", 'N' as "SitJuridica", null as "Percadministracao",
null as "Vlradministracao", 
null as "Dtacontabilizacao", null as "Linkerp", null as "Qtdparcela", 
null as "Vlrcomissaofat", null as "Seqboleto", null as "Seqmotorista", 
null as "Percdesccontrato", null as "Vlrdesccontrato", null as "Justcancel", 
null as "CMC7", null as "Apporigem"
FROM recebercaixa as rc
LEFT JOIN (SELECT rc.id as id, sum(rci.valortotal)  as valor FROM recebercaixa as rc
JOIN recebercaixaitem as rci
ON rc.id = rci.id_recebercaixa
WHERE rc.id_situacaorecebercaixa = 0
GROUP BY 1) as rci
ON rc.id = rci.id
WHERE rc.id_situacaorecebercaixa = 0;





SELECT * FROM situacaocadastro;
SELECT * FROM tiporecebivel;
SELECT * FROM recebercaixa WHERE id = 152398;
SELECT * FROM recebercaixaitem LIMIT 10;

SELECT rc.id as id, sum(rci.valortotal) FROM recebercaixa as rc
JOIN recebercaixaitem as rci
ON rc.id = rci.id_recebercaixa
WHERE rc.id_situacaorecebercaixa = 0
GROUP BY 1;