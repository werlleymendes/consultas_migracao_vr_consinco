/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Consulta voltada a migrar a tabela receber verba do vr
para o consinco*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when rv.id_loja = 1 then 1
when rv.id_loja = 2 then 2
when rv.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "CodGerente",
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa",
LEFT(CAST(f.cnpj as varchar(14)), -2) as "CodPessoa", 2 as "TipoCodPessoaNota",
LEFT(CAST(f.cnpj as varchar(14)), -2) as "CodPessoaNota",
rv.id as "NroTitulo", null as "SerieTitulo", null as "NroParcela",
rv.id as "NroDocumento", null as "SerieDoc", 
(rv.valor - coalesce(rvi.valor, 0)) as "VlrOriginal" ,
rv.dataemissao as "DtaEmissao", rv.datavencimento as "DtaVencimento",
'P' as "TipoVencOriginal", null as "DtaProgramada", 
(rv.id || ', ' || coalesce(rv.observacao, null)) as "Observacao", 
null as "CodigoFator", 'S' as "TituloEmitido", 0::float as "VlrDscFinanc", 
0::float as "PctDescFinanc", rv.datavencimento as "DtaLimDscFinanc",
'S' as "CodCarteira", null as "Banco", null as "Agencia",
null as "NroCompensacao", null as "CtaEmitente", 'P' as "ProprioTerceiro", 
0::float as "SeqCtaCorrente", null as "NossoNumero", null as "DigNossoNum", 'T' as "TituloCaixa",
'BLT' as "TipoNegociacao",
null as "NroCarga", 0 as "PerJuroMora", rv.dataemissao as "DtaMovimento",
null as "OrdenaCarga", null as "DtaCarga", 'J' as "Situacao", 
null as "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
'' as "SeqTitulo", 1 as "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
'' as "NroProcesso", 'ORCAMENTO' as "UsuAlteracao", null as "IndReplicacao", 
null as "IndGerouReplicacao", 0::float as "VlrDescComercial",  null as "SitCheqDev",
null as "CodBarra", null as "LotePagto", 'N' as "SitJuridica", null as "Percadministracao",
null as "Vlradministracao", 
null as "Dtacontabilizacao", null as "Linkerp", null as "Qtdparcela", 
null as "Vlrcomissaofat", null as "Seqboleto", null as "Seqmotorista", 
null as "Percdesccontrato", null as "Vlrdesccontrato", null as "Justcancel", 
null as "CMC7", null as "Apporigem"
FROM receberverba as rv
JOIN fornecedor as f
ON rv.id_fornecedor = f.id
LEFT JOIN (SELECT rv.id as id, sum(rvi.valor) as valor FROM receberverba as rv
		JOIN receberverbaitem as rvi
		ON rv.id = rvi.id_receberverba
		WHERE rv.id_situacaoreceberverba = 0
		GROUP BY 1) as rvi
ON rv.id = rvi.id
WHERE rv.id_situacaoreceberverba = 0;



/*CONSULTAS AUXILIARES UTILIZADAS NA CONSTRUÇÃO DA CONSULTA PRINCIPAL*/
SELECT * FROM receberverba where id_situacaoreceberverba = 0 and datavencimento <= '2021-04-30';

SELECT rv.id as id, sum(rvi.valor) as valor FROM receberverba as rv
JOIN receberverbaitem as rvi
ON rv.id = rvi.id_receberverba
WHERE rv.id_situacaoreceberverba = 0
GROUP BY 1;
