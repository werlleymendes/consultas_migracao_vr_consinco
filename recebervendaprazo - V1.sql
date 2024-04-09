/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*consulta para migração do vr para a consinco 
contas a receber, tabela recebervendaprazo*/
INSERT INTO consinco.FI_IntTitulo (SeqIntTitulo, TipoRegistro, NroEmpresaMae,
NroEmpresa, CodEspecie, TipoCodGerente, CodGerente, TipoCodVendedor,
CodVendedor, TipoCodPessoa, CodPessoa, TipoCodPessoaNota, CodPessoaNota, NroTitulo,
SerieTitulo, NroParcela, NroDocumento, SerieDoc, VlrOriginal,
DtaEmissao, DtaVencimento, TipoVencOriginal, DtaProgramada, Observacao,
CodigoFator, TituloEmitido, VlrDscFinanc, PctDescFinanc, DtaLimDscFinanc,
CodCarteira, Banco, Agencia, NroCompensacao, CtaEmitente, ProprioTerceiro,
SeqCtaCorrente, NossoNumero, DigNossoNum, TituloCaixa, TipoNegociacao,
NroCarga, PerJuroMora, DtaMovimento, OrdenaCarga, DtaCarga, Situacao,
Origem, SeqTitulo, SeqDepositario, NroProcesso, UsuAlteracao, IndReplicacao,
IndGerouReplicacao, VlrDescComercial, SitCheqDev, CodBarra, LotePagto,
SitJuridica, Percadministracao, Vlradministracao, Dtacontabilizacao, linkerp,
Qtdparcela, Seqboleto, Seqmotorista, Percdesccontrato,
Vlrdesccontrato, Justcancel, Numeronfse)
SELECT ''/*getid*/ "SeqIntTitulo", 1 "TipoRegistro", 1 "NroEmpresaMae",
CASE 
       when rv."id_loja" = 1 then 1
       when rv."id_loja" = 2 then 2
       when rv."id_loja" = 4 then 3
end "NroEmpresa",
'DUPR' "CodEspecie", null "TipoCodGerente", 
null "CodGerente",null "TipoCodVendedor", 
null "CodVendedor", 2 "TipoCodPessoa", 
substr(ce."cnpj",0,length(ce."cnpj")-2) "CodPessoa",
2 "TipoCodPessoaNota",
substr(ce."cnpj",0,length(ce."cnpj")-2) "CodPessoaNota",
rv."id" "NroTitulo", null "SerieTitulo", 1 "NroParcela",
rv."numeronota" "NroDocumento", null "SerieDoc", 
(rv."valor" - coalesce(rvi.valor, 0)) "VlrOriginal",
rv."dataemissao" "DtaEmissao", rv."datavencimento" "DtaVencimento", 
'P' "TipoVencOriginal", null "DtaProgramada", 
rv."id" "Observacao",
null "CodigoFator", 'S' "TituloEmitido", 0 "VlrDscFinanc", 
0 "PctDescFinanc", rv."datavencimento" "DtaLimDscFinanc",
'S' "CodCarteira", null "Banco", null "Agencia",
null "NroCompensacao", null "CtaEmitente", null "ProprioTerceiro", 
null "SeqCtaCorrente", null "NossoNumero", null "DigNossoNum", 'T' "TituloCaixa",
'BLT' "TipoNegociacao",
null "NroCarga", 0 "PerJuroMora", rv."dataemissao" "DtaMovimento",
null "OrdenaCarga", null "DtaCarga", 'J' "Situacao", 
null "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
''/*getid*/ "SeqTitulo", 1 "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
''/*getid*/ "NroProcesso", 'IMPORTACAO' "UsuAlteracao", null "IndReplicacao", 
null "IndGerouReplicacao", null "VlrDescComercial",  null "SitCheqDev",
null "CodBarra", null "LotePagto", 'N' "SitJuridica", null "Percadministracao",
null "Vlradministracao", 
null "Dtacontabilizacao", null "Linkerp", null "Qtdparcela", 
null "Seqboleto", null "Seqmotorista", 
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", 
null "Numeronfse"
FROM "recebervendaprazo"@pg rv
JOIN "clienteeventual"@pg ce
ON rv."id_clienteeventual" = ce."id"
LEFT JOIN (
           SELECT rv."id" id, sum(rvi."valor") valor 
           FROM "recebervendaprazo"@pg rv, 
		       "recebervendaprazoitem"@pg rvi 
           WHERE rv."id" = rvi."id_recebervendaprazo"
           AND "id_situacaorecebervendaprazo" = 0
           GROUP BY rv."id") rvi 
ON rv."id" = rvi.id
WHERE rv."id_situacaorecebervendaprazo" = 0;

SELECT NROCGCCPF
FROM consinco.ge_pessoa where NROCGCCPF in (89587340001,
413827400001);



SELECT * FROM recebervendaprazo WHERE id_situacaorecebervendaprazo = 0;
SELECT * FROM recebervendaprazoitem;

SELECT rv.id as id, sum(rvi.valor) FROM recebervendaprazo rv, recebervendaprazoitem rvi 
WHERE rv.id = rvi.id_recebervendaprazo
AND id_situacaorecebervendaprazo = 0
GROUP BY 1;


