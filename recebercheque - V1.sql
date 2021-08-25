/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*tabela receber cheque*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when rc.id_loja = 1 then 1
when rc.id_loja = 2 then 2
when rc.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as "TipoCodGerente", null as "CodGerente", 
null as "TipoCodVendedor", null as "CodVendedor", 2 as "TipoCodPessoa",
left(cast(rc.cpf as varchar(14)), -2) as "CodPessoa", 2 as "TipoCodPessoaNota",
left(cast(rc.cpf as varchar(14)), -2) as "CodPessoaNota", rc.numerocheque as "NroTitulo",
null as "SerieTitulo", 1 as "NroParcela", rc.numerocupom as "NroDocumento", 
null as "SerieDoc", rc.valorinicial as "VlrOriginal", data as "DtaEmissao",
datadeposito as "DtaVencimento", 'P' as "TipoVencOriginal", null as "DtaProgramada",
(coalesce(rc.numerocheque, 0) || ', ' || coalesce(rc.observacao, null)) as "Observacao",
null as "CodigoFator", 'S' as "TituloEmitido", 0 as "VlrDscFinanc", 
'0.0'::double precision as "PctDescFinanc", rc.datadeposito as "DtaLimDscFinanc",
'S' as "CodCarteira", rc.id_banco as "Banco", rc.agencia::varchar(10) as "Agencia",
null as "NroCompensacao", rc.conta as "CtaEmitente", 'P' as "ProprioTerceiro", 
0 as "SeqCtaCorrente", null as "NossoNumero", null as "DigNossoNum", 'T' as "TituloCaixa",
'CHQ' as "TipoNegociacao", null as "NroCarga", 0 as "PerJuroMora", rc.data as "DtaMovimento",
null as "OrdenaCarga", null as "DtaCarga", 'J' as "Situacao", null as "Origem",
/*Na hora do teste pedir ajuda ao Rodrigues  da Consinco*/'' as "SeqTitulo", 
1 as "SeqDepositario",
/*Na hora do teste pedir ajuda ao Rodrigues  da Consinco*/ '' as "NroProcesso", 
'ORCAMENTO' as "UsuAlteracao", null as "IndReplicacao", null as "IndGerouReplicacao",
null as "VlrDescComercial", null as "SitCheqDev", null as "CodBarra", null as "LotePagto",
'N' as "SitJuridica", null as "Percadministracao", null as "Vlradministracao", 
null as "Dtacontabilizacao", null as "Linkerp", null as "Qtdparcela", 
null as "Vlrcomissaofat", null as "Seqboleto", null as "Seqmotorista", 
null as "Percdesccontrato", null as "Vlrdesccontrato", null as "Justcancel", 
null as "CMC7", null as "Apporigem"
FROM recebercheque AS rc
WHERE rc.id_situacaorecebercheque = 0;


SELECT tablename FROM pg_tables WHERE tablename LIKE '%receber%';

SELECT * FROM recebercheque where id_situacaorecebercheque = 0;