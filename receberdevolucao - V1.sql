/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Consulta para migração do contas a receber - devolução */

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
       when rd."id_loja" = 1 then 1
       when rd."id_loja" = 2 then 2
       when rd."id_loja" = 4 then 3
end "NroEmpresa",
'CONTDV' "CodEspecie", null "TipoCodGerente", null "CodGerente",
null "TipoCodVendedor", null "CodVendedor", 2 "TipoCodPessoa",
substr(f."cnpj",0,length(f."cnpj")-2) "CodPessoa", 
2 "TipoCodPessoaNota",
substr(f."cnpj",0,length(f."cnpj")-2) "CodPessoaNota", 
rd."id" "NroTitulo",
null "SerieTitulo", 1 "NroParcela", rd."numeronota" "NroDocumento",
null "SerieDoc", 
(rd."valor" - coalesce(rdi.valor, 0) - rd."valorabatimento" - 
rd."valorpagarfornecedor") "VlrOriginal", 
rd."dataemissao" "DtaEmissao",
rd."datavencimento" "DtaVencimento", 'P' "TipoVencOriginal", null "DtaProgramada",
rd."id" "Observacao", null "CodigoFator",
'S' "TituloEmitido", 0 "VlrDscFinanc", 0 "PctDescFinanc", 
rd."datavencimento" "DtaLimDscFinanc", 'S' "CodCarteira", null "Banco", null "Agencia",
null "NroCompensacao", null "CtaEmitente", null "ProprioTerceiro", 
null "SeqCtaCorrente", null "NossoNumero", null "DigNossoNum",
'T' "TituloCaixa", 'BLT' "TipoNegociacao", null "NroCarga", 
null "PerJuroMora", rd."dataemissao" "DtaMovimento", null "OrdenaCarga",
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
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", null "Numeronfse"
FROM "receberdevolucao"@pg rd
JOIN "fornecedor"@pg f
ON rd."id_fornecedor"@pg = f."id"
LEFT JOIN (SELECT rdi."id_receberdevolucao" id, sum(rdi."valortotal") valor
		              FROM "receberdevolucaoitem"@pg rdi
		              JOIN "receberdevolucao"@pg rd
		              ON rd."id" = rdi."id_receberdevolucao"
		              WHERE rd."id_situacaoreceberdevolucao" = 0
		              GROUP BY rdi."id_receberdevolucao") rdi
		        ON rd."id" = rdi.id
WHERE rd."id_situacaoreceberdevolucao" = 0
;

SELECT p.NROCGCCPF
FROM consinco.ge_pessoa p, consinco.fi_cliente c
 WHERE p.seqpessoa = c.seqpessoa and NROCGCCPF IN (5884580007,
14052690004,
18387230257,
19148510001,
28843140001,
29144600114,
33991490001,
34933770001,
35077320001,
36841750001,
37217690006,
37217690009,
40152250002,
45220650001,
51399180001,
54029040012,
54124310001,
56176170001,
59319420001,
68507130001,
70298560001,
71965790001,
72016350001,
72068160001,
72068160028,
72068160047,
72160540006,
76417340001,
76506550001,
76674390001,
76674390003,
87189210002,
88112260015,
89783650001,
93173180001,
95245020001,
95245020006,
104834440002,
128421390002,
131438020007,
133241840038,
157378150001,
168492310013,
171049710001,
172113710001,
182310890001,
183247120001,
195105870002,
202948960001,
235778510001,
279496860001,
317951960001,
318746550001,
329067500001,
330099110064,
349593820001,
352296400001,
412215160002,
414567030001,
432140550036,
564508770003,
604090750159,
605945380009,
615865580026,
633104110001,
633602340001,
634834080001,
709409940069,
739095660001,
830440160073,
833104410069,
844321110007,
874565620018,
897381730005
);

INSERT INTO consinco.Fi_Inttituloope (seqinttitulo, codoperacao,
seqop, vlroperacao, anotacao, seqtitoperacao, indreplicacao, indgeroureplicacao,
SeqCtacorrente, dtaoperacao, dtacontabilizacao, geractapartida)
SELECT it.SeqIntTitulo, 16 "CodOperacao", null "SeqOP", 
it.VlrOriginal "VlrOperacao", null "VlrOperacao", 
CONSINCO.S_FINANCEIRO.NEXTVAL "SeqTitOperacao", null "IndReplicacao",
null "IndGerouReplicacao", null "SeqCtacorrente", '01-jun-2022' "DtaOperacao",
'01-jun-2022' "DtaContabilizacao", null "GeraCtaPartida"
FROM consinco.FI_IntTitulo it
WHERE it.seqinttitulo NOT IN (SELECT seqinttitulo FROM consinco.fi_inttituloope);





/*Consultas auxiliares utilizadas para desenvolver a consulta principal*/


SELECT * FROM "receberdevolucao"@pg rd, "receberdevolucaoitem"@pg rdi
WHERE rd."id" = rdi."id_receberdevolucao" and
rd."id_situacaoreceberdevolucao" = 0;

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



