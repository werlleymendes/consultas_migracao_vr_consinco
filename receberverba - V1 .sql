/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*Consulta voltada a migrar a tabela receber verba do vr
para o consinco*/
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
SELECT getid "SeqIntTitulo", 1 "TipoRegistro", 1 "NroEmpresaMae",
CASE 
       when rv."id_loja" = 1 then 1
       when rv."id_loja" = 2 then 2
       when rv."id_loja" = 4 then 3
end "NroEmpresa",
'CONTVB' "CodEspecie", null "TipoCodGerente", null "CodGerente",
null "TipoCodVendedor", null "CodVendedor", 2 "TipoCodPessoa",
substr(f."cnpj",0,length(f."cnpj")-2) "CodPessoa", 2 "TipoCodPessoaNota",
substr(f."cnpj",0,length(f."cnpj")-2) "CodPessoaNota",
rv."id" "NroTitulo", null "SerieTitulo", 1 "NroParcela",
rv."id" "NroDocumento", null "SerieDoc", 
(rv."valor" - coalesce(rv."valorabatimento", 0) - coalesce(rvi.valor, 0)) "VlrOriginal" ,
rv."dataemissao" "DtaEmissao", rv."datavencimento" "DtaVencimento",
'P' "TipoVencOriginal", null "DtaProgramada", 
rv."id" "Observacao", 
null "CodigoFator", 'S' "TituloEmitido", 0 "VlrDscFinanc", 
0 "PctDescFinanc", rv."datavencimento" "DtaLimDscFinanc",
'S' "CodCarteira", null "Banco", null "Agencia",
null  "NroCompensacao", null "CtaEmitente", null "ProprioTerceiro", 
null "SeqCtaCorrente", null "NossoNumero", null "DigNossoNum", 'T' "TituloCaixa",
'BLT' "TipoNegociacao",
null "NroCarga", 0 "PerJuroMora", rv."dataemissao" "DtaMovimento",
null "OrdenaCarga", null "DtaCarga", 'J' "Situacao", 
null "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
getid "SeqTitulo", 1 "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
getid "NroProcesso", 'IMPORTACAO' "UsuAlteracao", null "IndReplicacao", 
null "IndGerouReplicacao", null "VlrDescComercial",  null "SitCheqDev",
null "CodBarra", null "LotePagto", 'N' "SitJuridica", null "Percadministracao",
null "Vlradministracao", 
null "Dtacontabilizacao", null "Linkerp", null "Qtdparcela", 
null "Seqboleto", null "Seqmotorista", 
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", 
null "Numeronfse"
FROM "receberverba"@pg rv
JOIN "fornecedor"@pg f
ON rv."id_fornecedor" = f."id"
LEFT JOIN (SELECT rv."id" id, sum(rvi."valor") valor 
                  FROM "receberverba"@pg rv
                  JOIN "receberverbaitem"@pg rvi
                  ON rv."id" = rvi."id_receberverba"
		              WHERE rv."id_situacaoreceberverba" = 0
		              GROUP BY rv."id") rvi
ON rv."id" = rvi.id
WHERE rv."id_situacaoreceberverba" = 0;

SELECT p.NROCGCCPF
FROM consinco.ge_pessoa p, consinco.fi_cliente c
 WHERE p.seqpessoa = c.seqpessoa and NROCGCCPF IN (
12579950001,
19148510001,
19148510001,
30143740007,
34933770001,
36841750001,
40152250002,
41722080002,
41722080002,
45220650001,
49184530004,
54029040012,
62931010001,
68507130001,
68507130001,
70326880006,
70326880006,
70326880006,
70694870007,
70694870007,
70694870007,
72068160047,
72160540002,
72160540002,
72160540006,
88112260015,
89783650001,
89783650001,
95004300001,
104834440002,
104834440002,
150998330001,
153506020024,
153506020024,
168492310013,
168492310013,
168492310013,
168492310013,
168492310013,
168492310013,
168492310013,
168492310013,
168492310013,
205243040001,
416001310002,
416001310002,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
432140550036,
604090750159,
604090750159,
604090750159,
604090750159,
604090750159,
604090750159,
604090750159,
633104110001,
633104110001,
633104110001,
633104110001,
633602340001,
634834080001,
634834080001,
649042950015,
649042950015,
739095660001,
830440160073,
874565620040,
874565620040,
874565620040,
874565620040,
874565620040
);


INSERT INTO consinco.Fi_Inttituloope (seqinttitulo, codoperacao,
seqop, vlroperacao, anotacao, seqtitoperacao, indreplicacao, indgeroureplicacao,
SeqCtacorrente, dtaoperacao, dtacontabilizacao, geractapartida)
SELECT it.SeqIntTitulo, 16 "CodOperacao", null "SeqOP", 
it.VlrOriginal "VlrOperacao", null "VlrOperacao", 
CONSINCO.S_FINANCEIRO.NEXTVAL "SeqTitOperacao", null "IndReplicacao",
null "IndGerouReplicacao", null "SeqCtacorrente", '06-jul-2022' "DtaOperacao",
'06-jul-2022' "DtaContabilizacao", null "GeraCtaPartida"
FROM consinco.FI_IntTitulo it
WHERE it.seqinttitulo NOT IN (SELECT seqinttitulo FROM consinco.fi_inttituloope);



/*CONSULTAS AUXILIARES UTILIZADAS NA CONSTRUÇÃO DA CONSULTA PRINCIPAL*/
SELECT * FROM receberverba where id_situacaoreceberverba = 0 and datavencimento <= '2021-04-30';

SELECT rv.id as id, sum(rvi.valor) as valor FROM receberverba as rv
JOIN receberverbaitem as rvi
ON rv.id = rvi.id_receberverba
WHERE rv.id_situacaoreceberverba = 0
GROUP BY 1;
SELECT * FROM "recebeverbaitem"@pg WHERE rownum <= 2;

SELECT sum(vlroriginal) FROM consinco.fi_inttitulo WHERE CODESPECIE = 'CONTVB';
