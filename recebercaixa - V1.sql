/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*TABELA RECEBER CAIXA*/
INSERT INTO consinco.fi_inttitulo(SeqIntTitulo, tiporegistro, NroEmpresaMae,
NroEmpresa, CodEspecie, TipoCodGerente, CodGerente, TipoCodVendedor, 
CodVendedor, TipoCodPessoa, CodPessoa, TipoCodPessoaNota, CodPessoaNota,
NroTitulo, SerieTitulo, NroParcela, NroDocumento, SerieDoc, VlrOriginal,
DtaEmissao, DtaVencimento, TipoVencOriginal, DtaProgramada, Observacao,
CodigoFator, TituloEmitido, VlrDscFinanc, PctDescFinanc, DtaLimDscFinanc,
CodCarteira, Banco, Agencia, NroCompensacao, CtaEmitente, ProprioTerceiro,
SeqCtaCorrente, NossoNumero, DigNossoNum, TituloCaixa, TipoNegociacao, 
NroCarga, PerJuroMora, DtaMovimento, OrdenaCarga, DtaCarga, Situacao,
Origem, SeqTitulo, SeqDepositario, NroProcesso, UsuAlteracao, IndReplicacao,
IndGerouReplicacao, VlrDescComercial, SitCheqDev, CodBarra, LotePagto,
SitJuridica, Percadministracao, Vlradministracao, Dtacontabilizacao,
Linkerp, Qtdparcela, Seqboleto, Seqmotorista, Percdesccontrato, 
Vlrdesccontrato, Justcancel, Numeronfse)
SELECT '' /*getid*/ "SeqIntTitulo", 1 "TipoRegistro", 1 "NroEmpresaMae",
CASE
       when rc."id_loja" = 1 then 1
       when rc."id_loja" = 2 then 2
       when rc."id_loja" = 4 then 3
end "NroEmpresa",
CASE 
    WHEN 
       tr."id_tipocartaotef" = 0 THEN
       'CARTAO'
    ELSE
       'CARDEB'
END "CodEspecie", null "TipoCodGerente", null "CodGerente", 
null "TipoCodVendedor", null "CodVendedor", 2 "TipoCodPessoa", 
CASE
    WHEN 
         tr."id_fornecedor" IS NULL THEN
         '235442990001'
    ELSE 
         substr(f."cnpj",0,length(f."cnpj")-2)
END "CodPessoa",
2  "TipoCodPessoaNota",
CASE
     WHEN 
         tr."id_fornecedor" IS NULL THEN
         '235442990001'
     ELSE 
          substr(f."cnpj",0,length(f."cnpj")-2)
END "CodPessoaNota",
rc."id" "NroTitulo", null "SerieTitulo", 1 "NroParcela", rc."id" "NroDocumento",
null "SerieDoc", 
CASE 
when rcg."taxa" <> 0 then
(rc."valor" - coalesce(rci.valor, 0) - coalesce((rc."valor" * rcg."taxa")/100, 0))
else 
(rc."valor" - coalesce(rci.valor, 0))
end "VlrOriginal", rc."dataemissao" "DtaEmissao",
rc."datavencimento" "DtaVencimento", 'P' "TipoVencOriginal", null "DtaProgramada",
rc."id" "Observacao", 
null "CodigoFator", 'S' "TituloEmitido", 0 "VlrDscFinanc", 
0 "PctDescFinanc", rc."datavencimento" "DtaLimDscFinanc", 
'S' "CodCarteira", null "Banco",
null "Agencia", null "NroCompensacao", null "CtaEmitente", 
null "ProprioTerceiro", null "SeqCtaCorrente", null "NossoNumero",
null "DigNossoNum", 'T' "TituloCaixa", 'BLT' "TipoNegociacao",
null "NroCarga", 0 "PerJuroMora",rc."dataemissao" "DtaMovimento",
null "OrdenaCarga", null "DtaCarga", 'J' "Situacao", 
null "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
''/*getid*/ "SeqTitulo", 1 "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
''/*getid*/ "NroProcesso", 'IMPORTACAO' "UsuAlteracao", null "IndReplicacao", 
null "IndGerouReplicacao", null "VlrDescComercial", null "SitCheqDev",
null "CodBarra", null "LotePagto", 'N' "SitJuridica", null "Percadministracao",
null "Vlradministracao", 
null "Dtacontabilizacao", null "Linkerp", null "Qtdparcela", null "Seqboleto", 
null "Seqmotorista", 
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", null "Numeronfse"
FROM "recebercaixa"@pg rc
LEFT JOIN (SELECT rc."id" id, sum(rci."valortotal")  valor FROM "recebercaixa"@pg rc
JOIN "recebercaixaitem"@pg rci
ON rc."id" = rci."id_recebercaixa"
WHERE rc."id_situacaorecebercaixa" = 0
GROUP BY rc."id") rci
ON rc."id" = rci.id
LEFT JOIN "tiporecebivel"@pg tr ON 
rc."id_tiporecebivel" = tr."id"
LEFT JOIN "fornecedor"@pg f ON tr."id_fornecedor" = f."id"
LEFT JOIN "recebivelconfiguracao"@pg rcg ON tr."id" = rcg."id_tiporecebivel"
     AND rc."id_loja" = rcg."id_loja"
WHERE rc."id_situacaorecebercaixa" = 0;

SELECT * FROM consinco.fi_cliente;

SELECT p.NROCGCCPF
FROM consinco.ge_pessoa p, consinco.fi_cliente c
 WHERE p.seqpessoa = c.seqpessoa and NROCGCCPF IN (
 173511800001,
478669340001,
10270580001,
14257870001,
235442990001,
27329680002,
266799100001,
925598300001,
922284100001,
355259890001,
47408760001,
93703230001,
82629610001,
604196450001,
690346680001,
25358640001
);


INSERT INTO consinco.Fi_Inttituloope (seqinttitulo, codoperacao,
seqop, vlroperacao, anotacao, seqtitoperacao, indreplicacao, indgeroureplicacao,
SeqCtacorrente, dtaoperacao, dtacontabilizacao, geractapartida)
SELECT it.SeqIntTitulo, 16 "CodOperacao", null "SeqOP", 
it.VlrOriginal "VlrOperacao", null "VlrOperacao", 
CONSINCO.S_FINANCEIRO.NEXTVAL "SeqTitOperacao", null "IndReplicacao",
null "IndGerouReplicacao", null "SeqCtacorrente", '03-jun-2022' "DtaOperacao",
'03-jun-2022' "DtaContabilizacao", null "GeraCtaPartida"
FROM consinco.FI_IntTitulo it
WHERE it.seqinttitulo NOT IN (SELECT seqinttitulo FROM consinco.fi_inttituloope);

SELECT * FROM consinco.fi_inttitulo;

pdv.venda, pdv.tipotef, pdv.autorizadora

SELECT * FROM pdv.vendatef limit 10;
SELECT * FROM pdv.venda limit 10;
SELECT * FROM venda limit 10;

SELECT * FROM PDV.vendapdvvendatef LIMIT 10;
SE


SELECT * FROM pg_tables WHERE tablename LIKE '%venda%' 
ORDER BY schemaname;

SELECT column_name, table_name FROM information_schema.columns WHERE column_name = '%tef%';
SELECT * FROM pdv.tipotef;
SELECT * FROM pdv.autorizadora;

SELECT
*
FROM
information_schema.columns
WHERE column_name LIKE '%tef%';

SELECT * FROM pdv.venda limit 10;
SELECT * FROM public.venda LIMIT 10;
SELECT FROM information_schema.columns limit 10;

SELECT * FROM tipocartaotef;
SELECT * FROM situacaocadastro;
SELECT * FROM "tiporecebivel"@pg;
SELECT * FROM "recebercaixa"@pg
SELECT * FROM "pdv"."tipotef"@pg pdv

SELECT * FROM "recebercaixaitem"@pg rc WHERE rc."valortaxa" > 0;

SELECT * FROM tiporecebimento;
SELECT * FROM recebercaixavendatef;

SELECT tr.descricao, tr.id_fornecedor
FROM recebercaixa as rc
left JOIN recebercaixaitem as rci ON rc.id = rci.id_recebercaixa
LEFT JOIN tiporecebivel as tr ON rc.id_tiporecebivel = tr.id
WHERE rc.id_situacaorecebercaixa = 0
GROUP BY 1, 2;

SELECT * FROM situacaorecebercaixa;


SELECT * FROM pdv.autorizadora;


SELECT * FROM conciliacaobancarialancamento;


SELECT   
  a.attname AS atributo,   
  clf.relname AS tabela_ref,   
  af.attname AS atributo_ref   
FROM pg_catalog.pg_attribute a   
  JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = 'r')
  JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)   
  JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND   
       ct.confrelid != 0 AND ct.conkey[1] = a.attnum)   
  JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = 'r')
  JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)   
  JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND   
       af.attnum = ct.confkey[1])   
WHERE   
  cl.relname = 'tipotef';

SELECT * FROM conciliacaobancarialancamento;
SELECT * FROM conciliacaobancaria;

SELECT rc.id as id, sum(rci.valortotal) FROM recebercaixa as rc
JOIN recebercaixaitem as rci
ON rc.id = rci.id_recebercaixa
WHERE rc.id_situacaorecebercaixa = 0
GROUP BY 1;
