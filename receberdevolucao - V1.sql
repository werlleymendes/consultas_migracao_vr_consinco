/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Consulta para migração do contas a receber - devolução */

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when rd.id_loja = 1 then 1
when rd.id_loja = 2 then 2
when rd.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "CodGerente",
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa",
LEFT(CAST(f.cnpj AS VARCHAR), -2) as "CodPessoa", 2 as "TipoCodPessoaNota",
LEFT(CAST(f.cnpj AS VARCHAR), -2) as "CodPessoaNota", rd.id as "NroTitulo",
null as "SerieTitulo", 1 as "NroParcela", rd.numeronota as "NroDocumento",
null as "SerieDoc", (rd.valor - COALESCE(rdi.valor, 0)) as "VlrOriginal", rd.dataemissao as "DtaEmissao",
rd.datavencimento as "DtaVencimento", 'P' as "TipoVencOriginal", null as "DtaProgramada",
(rd.id || ', ' || coalesce(rd.observacao, '')) as "Observacao", null as "CodigoFator",
'S' as "TituloEmitido", 0::float as "VlrDscFinanc", 0::float as "PctDescFinanc", 
rd.datavencimento as "DtaLimDscFinanc", 'S' as "CodCarteira", null as "Banco", null as "Agencia",
null as "NroCompensacao", null as "CtaEmitente", null as "ProprioTerceiro", 
0::varchar as SeqCtaCorrente, null as "NossoNumero", null as "DigNossoNum",
'T' as "TituloCaixa", 'BLT' as "TipoNegociacao", null as "NroCarga", 
null as "PerJuroMora", rd.dataemissao as "DtaMovimento", null as "OrdenaCarga",
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
FROM receberdevolucao as rd
JOIN fornecedor as f
ON rd.id_fornecedor = f.id
LEFT JOIN (SELECT rdi.id_receberdevolucao as id, sum(rdi.valor)  as valor
		FROM receberdevolucaoitem as rdi
		JOIN receberdevolucao as rd
		ON rd.id = rdi.id_receberdevolucao 
		WHERE rd.id_situacaoreceberdevolucao =0
		GROUP BY 1) as rdi
		ON rd.id = rdi.id
WHERE rd.id_situacaoreceberdevolucao = 0;






/*Consultas auxiliares utilizadas para desenvolver a consulta principal*/


SELECT * FROM receberdevolucao rd, receberdevolucaoitem rdi
WHERE rc.id = rci.id_receberdevolucao and
id_situacaoreceberdevolucao = 0;

/*CONSULTA UTILIZADA PARA CALCULAR A RAZÃO ENTRE O VALOR PRINCIPAL E O LIQUIDO
, DESCONTANDO O ABATIMENTO*/
SELECT rdi.id_receberdevolucao as id, sum(rdi.valor)  as valor
FROM receberdevolucaoitem as rdi
JOIN receberdevolucao as rd
ON rd.id = rdi.id_receberdevolucao 
WHERE rd.id_situacaoreceberdevolucao =0
GROUP BY 1;

SELECT * FROM receberdevolucao limit 10;

SELECT * FROM fornecedor;



