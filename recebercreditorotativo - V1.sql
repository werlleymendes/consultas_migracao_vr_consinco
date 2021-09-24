/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*CRÉDITO ROTATIVO*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when rc.id_loja = 1 then 1
when rc.id_loja = 2 then 2
when rc.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "CodGerente", 
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa",
left(cast(cnpj as varchar(14)), -2) as "CodPessoa", 2 as "TipoCodPessoaNota",
left(cast(cnpj as varchar(14)), -2) as "CodPessoaNota", rc.id as "NroTitulo",
null as "SerieTitulo", 1 as "NroParcela", rc.numerocupom as "NroDocumento", 
null as "SerieDoc", 
/*Aguardar resposta do rodrigues, se é valor inicial ou valor liquido*/
(rc.valor - coalesce(rci.valorabatimento, 0))as "VlrOriginal", rc.dataemissao as "DtaEmissao", 
rc.datavencimento as "DtaVencimento", 'P'  as "TipoVencOriginal", 
null as "DtaProgramada", 
(rc.id || ', ' || coalesce(rc.observacao)) as "Observacao", null as "CodigoFator",
'S' as "TituloEmitido", 0 as "VlrDscFinanc", 0 as "PctDescFinanc", 
rc.datavencimento as "DtaLimDscFinanc", 'S' as "CodCarteira", null as "Banco",
null as "Agencia", null as "NroCompensacao", null as "CtaEmitente", 
null as "ProprioTerceiro", 0 as "SeqCtaCorrente", null as "NossoNumero",
null as "DigNossoNum", 'T' as "TituloCaixa", 'BLT' as "TipoNegociacao",
null as "NroCarga", 0 as "PerJuroMora", rc.dataemissao as "DtaMovimento",
null as "OrdenaCarga", null as "DtaCarga", 'J' as "Situacao", 
null as "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
'' as "SeqTitulo", 1 as "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
'' as "NroProcesso", 'ORCAMENTO' as "UsuAlteracao", null as "IndReplicacao", 
null as "IndGerouReplicacao", null as "VlrDescComercial", null as "SitCheqDev",
null as "CodBarra", null as "LotePagto", 'N' as "SitJuridica", null as "Percadministracao",
null as "Vlradministracao", 
null as "Dtacontabilizacao", null as "Linkerp", null as "Qtdparcela", 
null as "Vlrcomissaofat", null as "Seqboleto", null as "Seqmotorista", 
null as "Percdesccontrato", null as "Vlrdesccontrato", null as "Justcancel", 
null as "CMC7", null as "Apporigem"
FROM recebercreditorotativo as rc
JOIN clientepreferencial as cp ON rc.id_clientepreferencial = cp.id
LEFT JOIN (SELECT rc.id, SUM(rci.valor) as valorabatimento
		   FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id) as rci
ON rc.id = rci.id
WHERE rc.id_situacaorecebercreditorotativo = 0;







/*Consultas auxiliares utilizadas para desenvolvimento da query principal*/


/*Consulta utilizada para criar uma pseudo-tabela com a soma dos abatimentos, para
poder enviar apenas o restante na query principal.*/
SELECT rc.id, rc.numerocupom, rc.valor, rci.valorabatimento,  
(rc.valor - rci.valorabatimento) as totalliquido, rc.dataemissao
FROM recebercreditorotativo as rc
LEFT JOIN (SELECT rc.id, SUM(rci.valor) as valorabatimento
		   FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id) as rci
ON rc.id = rci.id
WHERE rc.id_situacaorecebercreditorotativo = 0

SELECT sum(rc.valor), sum(rci.valorabatimento),  
(sum(rc.valor) - sum(rci.valorabatimento)) as totalliquido
FROM recebercreditorotativo as rc
LEFT JOIN (SELECT rc.id, SUM(rci.valor) as valorabatimento
		   FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id) as rci
ON rc.id = rci.id
WHERE rc.id_situacaorecebercreditorotativo = 0



SELECT * FROM recebercreditorotativo WHERE id_situacaorecebercreditorotativo = 0;

SELECT * FROM recebercreditorotativoitem LIMIT 10;

SELECT rc.id, SUM(rci.valor) FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id


SELECT tablename, schemaname FROM pg_tables WHERE tablename like '%rotat%';

SELECT * FROM creditorotativoparcela LIMIT 10;

SELECT * FROM clientepreferencial LIMIT 1
