/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Migração das outras receitas do Banco de dados do VR para o Consinco*/
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
/*A LOJA 4 NO VR PASSOU A SER A 3 NO CONSINCO, POR ISSO A NECESSIDADE DE FAZER O
CASE*/
CASE 
    when ro."id_loja" = 1 then 1
    when ro."id_loja" = 2 then 2
    when ro."id_loja" = 4 then 3
end "NroEmpresa",
'CONTVB' "CodEspecie", null "TipoCodGerente", null "CodGerente", 
null "TipoCodVendedor", null "CodVendedor", 2 "TipoCodPessoa",
/*AS OUTRAS RECEITAS PODEM VIR TANTO DE FORNECEDOR QUANTO DE CLIENTE EVENTUAL
*/
CASE
	WHEN ro."id_clienteeventual" is not null 
    THEN 
       substr(ce."cnpj",0,length(ce."cnpj")-2)
	ELSE 
       substr(f."cnpj",0,length(f."cnpj")-2)
END "CodPessoa",
2 "TipoCodPessoaNota", 
CASE
	WHEN ro."id_clienteeventual" is not null 
    THEN 
      substr(ce."cnpj",0,length(ce."cnpj")-2)
	ELSE 
    substr(f."cnpj",0,length(f."cnpj")-2)
END "CodPessoaNota",
ro."id" "NroTitulo", null "SerieTitulo", 1 "NroParcela", 
/*NÚMERO DA NOTA FISCAL NÃO SE APLICA A ESSA TABELA. AGUARDANDO RESPOSTA DA CONSINCO*/
'' "NroDocumento", null "SerieDoc", 
(ro."valor" - coalesce(roi.valor, 0)) "VlrOriginal", ro."dataemissao" "DtaEmissao",
ro."datavencimento" "DtaVencimento", 'P' "TipoVencOriginal", 
null "DtaProgramada", 
ro."id" "Observacao",
null "CodigoFator", 'S' "TituloEmitido", 0 "VlrDscFinanc", 
0 "PctDescFinanc", ro."datavencimento" "DtaLimDscFinanc",
'S' "CodCarteira", null "Banco", null "Agencia",
null "NroCompensacao", null "CtaEmitente", null "ProprioTerceiro", 
null "SeqCtaCorrente", null "NossoNumero", null "DigNossoNum",
'T' "TituloCaixa",'BLT' "TipoNegociacao", null "NroCarga", 
null "PerJuroMora", ro."dataemissao" "DtaMovimento", null "OrdenaCarga",
null "DtaCarga", 'J' "Situacao", null "Origem",
/*Solicitar ajuda do Analista da consinco quando for fazer a migração*/
''/*getid*/ "SeqTitulo", 1 "SeqDepositario",
/*Solicitar ajuda do Analista da consinco quando for fazer a migração*/
''/*getid*/ "NroProcesso", 'IMPORTACAO' "UsuAlteracao", null "IndReplicacao",
null "IndGerouReplicacao", null "VlrDescComercial", null "SitCheqDev",
null "CodBarra", null "LotePagto", 'N' "SitJuridica",
null "Percadministracao",
null "Vlradministracao", 
null "Dtacontabilizacao", null "Linkerp", null "Qtdparcela", 
null "Seqboleto", null "Seqmotorista", 
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", 
null "Numeronfse"
FROM "receberoutrasreceitas"@pg ro
LEFT JOIN "fornecedor"@pg f ON ro."id_fornecedor"@pg = f."id"
LEFT JOIN "clienteeventual"@pg ce ON ro."id_clienteeventual" = ce."id"
LEFT JOIN (SELECT roi."id_receberoutrasreceitas" id, SUM(roi."valor") valor 
                  FROM "receberoutrasreceitasitem"@pg roi
                  JOIN "receberoutrasreceitas"@pg ro
                  ON roi."id_receberoutrasreceitas" = ro."id"
                  WHERE ro."id_situacaoreceberoutrasreceitas" = 0
                  GROUP BY roi."id_receberoutrasreceitas") roi
           ON ro."id" = roi.id
WHERE ro."id_situacaoreceberoutrasreceitas" = 0;

SELECT p.NROCGCCPF
FROM consinco.ge_pessoa p, consinco.fi_cliente c
 WHERE p.seqpessoa = c.seqpessoa and NROCGCCPF IN (1054893,
2907123,
5800733,
10352193,
14709953,
15540653,
15764073,
18205713,
24108442,
28164673,
29880883,
29929403,
33118983,
35243233,
35749853,
42169933,
43913553,
45841293,
46617723,
48521873,
53710543,
54620173,
54628393,
54959353,
55229703,
55438243,
56502373,
58265757,
59328173,
61030193,
61414103,
63350453,
63373393,
64059193,
65828363,
68877923,
70437333,
70440933,
71255123,
72670423,
72715973,
72875463,
74133123,
74202163,
77330743,
77531083,
78908633,
79613453,
82577813,
83010443,
86911633,
90510413,
153769630,
222898538,
293946330,
298358468,
341388748,
424128703,
517765453,
556563313,
573567773,
601640073,
603962603,
642346063,
667586453,
687193023,
744617610,
802098903,
19148510001,
54029040012,
68507130001,
69803430001,
72068160001,
72068160047,
166935830001,
202214230001,
202948960001,
349593820001,
436069310001,
605945380009,
633104110001,
709409940069,
709409940092
);

INSERT INTO consinco.Fi_Inttituloope (seqinttitulo, codoperacao,
seqop, vlroperacao, anotacao, seqtitoperacao, indreplicacao, indgeroureplicacao,
SeqCtacorrente, dtaoperacao, dtacontabilizacao, geractapartida)
SELECT it.SeqIntTitulo, 16 "CodOperacao", null "SeqOP", 
it.VlrOriginal "VlrOperacao", null "VlrOperacao", 
CONSINCO.S_FINANCEIRO.NEXTVAL "SeqTitOperacao", null "IndReplicacao",
null "IndGerouReplicacao", null "SeqCtacorrente", '31-may-2022' "DtaOperacao",
'31-may-2022' "DtaContabilizacao", null "GeraCtaPartida"
FROM consinco.FI_IntTitulo it
WHERE it.seqinttitulo NOT IN (SELECT seqinttitulo FROM consinco.fi_inttituloope);



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
