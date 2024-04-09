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
Vlrdesccontrato, Justcancel, CMC7, Apporigem, Seqpessoaemitente, 
PrazoCompror, TaxaCompror, DtaBaseCobranca, VLRICMSSTPARC1,  Numeronfse)  
SELECT getid "SeqIntTitulo", 1 "TipoRegistro", 
1  "NroEmpresaMae",
--A nossa loja 4 no VR será a loja N°3 no consinco, por isso a necessidade de mudar na query 
CASE 
when pf."id_loja" = 1 then 1
when pf."id_loja" = 2 then 2
when pf."id_loja" = 4 then 3
end  "NroEmpresa",
/*CLASSIFICANDO OS TITULOS DE COMPRA DE MERCADORIA PARA REVENDA E PRODUTOR RURAL COMO DUPP 
E  DESPESAS COMO DESP*/
CASE 
   WHEN pf."id_tipoentrada" = 6 THEN 'DUPP'
   WHEN pf."id_tipoentrada" = 0 THEN 'DUPP'
ELSE 'DESP'
     END  "CodEspecie", 
/*RETORNAR O CNPJ/CPF SEM O DIGITO VERIFICADOR*/
null  "TipoCodGerente", null  "CodGerente", null  "TipoCodVendedor", 
null  "CodVendedor", 2  "TipoCodPessoa",
substr(f."cnpj",0,length(f."cnpj")-2) "CodPessoa",
2  "TipoCodPessoaNota",
substr(f."cnpj",0,length(f."cnpj")-2) "CodPessoaNota", 
pff."id" "NroTitulo", ne."serie" "SerieTitulo", pff."numeroparcela" "NroParcela", 
ne."numeronota" "NroDocumento", ne."serie" "SerieDoc",
(pff."valor" + coalesce(pff."valoracrescimo", 0) - coalesce(pfa.valorabatimento, 0) -
  coalesce(pfad.valoradiantamento, 0) - coalesce(pfdv.valordevolucao, 0) 
  - coalesce(pfvba.valorverba, 0))  "VlrOriginal", 
  pf."dataemissao"  "DtaEmissao", pff."datavencimento"  "DtaVencimento",
'P'  "TipoVencOriginal", null  "DtaProgramada", 
/*A observação é a concatenação do número do título com a observação lançada no VR software*/
pf."numerodocumento" "Observacao", null  "CodigoFator",
'S'  "TituloEmitido", 
--verificar se realmente não tem imposto
0 as "VlrDscFinanc", 0 as "PctDescFinanc",
pff."datavencimento"  "DtaLimDscFinanc", 'S'  "CodCarteira", null  "Banco", 
null  "Agencia", null  "NroCompensacao", null  "CtaEmitente", null  "ProprioTerceiro",
null  "SeqCtaCorrente", null  "NossoNumero", null  "DigNossoNum", 'T'  "TituloCaixa",
'BLT'  "TipoNegociacao", null  "NroCarga", null  "PerJuroMora", 
ne."dataentrada" "DtaMovimento", null  "OrdenaCarga", null  "DtaCarga",
'J'  "Situacao", null  "Origem", 
getid "SeqTitulo",
2  "SeqDepositario",
getid "NroProcesso",
 'IMPORTACAO'  "UsuAlteracao",
null  "IndReplicacao", null  "IndGerouReplicacao", null  "VlrDescComercial",
null  "SitCheqDev", null  "CodBarra", null  "LotePagto", 'N'  "SitJuridica",
null  "Percadministracao", null  "Vlradministracao", null "Dtacontabilizacao",
null  "Linkerp", null  "Qtdparcela", null  "Seqboleto",
null  "Seqmotorista", null  "Percdesccontrato", null  "Vlrdesccontrato",
null  "Justcancel", null "CMC7", null "AppOrigem", null "SeqPessoaEmitente",
null "PrazoCompror", null "TaxaCompror", null "DtaBaseCobranca", null "VLRICMSSTPARC1",
null  "Numeronfse"
FROM "pagarfornecedor"@pg  pf JOIN "fornecedor"@pg  f
ON pf."id_fornecedor" = f."id"
LEFT JOIN "pagarfornecedorparcela"@pg  pff
ON pff."id_pagarfornecedor" = pf."id"
LEFT JOIN "notaentrada"@pg  ne
ON pf."numerodocumento" = ne."numeronota" AND pf."id_fornecedor" = ne."id_fornecedor"
LEFT JOIN (SELECT pfp."id"  id, sum(pfa."valor")  valorabatimento
FROM "pagarfornecedorparcela"@pg  pfp
JOIN "pagarfornecedorparcelaabatimento"@pg  pfa
ON pfp."id" = pfa."id_pagarfornecedorparcela"
WHERE pfp."id_situacaopagarfornecedorparcela" = 0
GROUP BY pfp."id")  pfa
ON pff."id" = pfa.id
LEFT JOIN (SELECT pfp."id"  id, sum(pfad."valor")  valoradiantamento
FROM "pagarfornecedorparcela"@pg  pfp
JOIN "pagarfornecedorparcelaadiantamento"@pg  pfad
ON pfp."id" = pfad."id_pagarfornecedorparcela"
WHERE pfp."id_situacaopagarfornecedorparcela" = 0
GROUP BY pfp."id")  pfad
ON pff."id" = pfad.id
LEFT JOIN (SELECT pfp."id"  "id", sum(pfdv."valor")  valordevolucao
FROM "pagarfornecedorparcela"@pg  pfp
JOIN "pagarfornecedorparceladevolucao"@pg pfdv
ON pfp."id" = pfdv."id_pagarfornecedorparcela"
WHERE pfp."id_situacaopagarfornecedorparcela" =0
GROUP BY pfp."id")  pfdv
ON pff."id" = pfdv."id"
LEFT JOIN (SELECT pfp."id" id, sum(pfvb."valor") valorverba
FROM "pagarfornecedorparcela"@pg pfp, "pagarfornecedorparcelaverba"@pg pfvb
WHERE pfp."id" = pfvb."id_pagarfornecedorparcela"
and pfp."id_situacaopagarfornecedorparcela" = 0
GROUP BY pfp."id") pfvba
ON pff."id" = pfvba.id
WHERE pff."id_situacaopagarfornecedorparcela" = 0;

SELECT * FROM consinco.fi_fornecedor;
SELECT * FROM consinco.maf_fornecedor;
SELECT * FROM consinco.age_fornecedor;

SELECT * FROM consinco.fi_inttitulo;

SELECT 
    COLUMN_NAME
FROM   all_tab_cols
WHERE  table_name like '%FORNECEDOR%';

SELECT getid FROM dual;


SELECT * FROM ALL_ALL_TABLES WHERE TABLE_NAME LIKE '%FORNECEDOR%' and columns = 'SEQPESSOA';

create or replace function getid return number is begin return CONSINCO.S_FINANCEIRO.NEXTVAL; end;



INSERT INTO consinco.Fi_Inttituloope (seqinttitulo, codoperacao,
seqop, vlroperacao, anotacao, seqtitoperacao, indreplicacao, indgeroureplicacao,
SeqCtacorrente, dtaoperacao, dtacontabilizacao, geractapartida)
SELECT it.SeqIntTitulo, 16 "CodOperacao", null "SeqOP", 
it.VlrOriginal "VlrOperacao", null "VlrOperacao", 
CONSINCO.S_FINANCEIRO.NEXTVAL "SeqTitOperacao", null "IndReplicacao",
null "IndGerouReplicacao", null "SeqCtacorrente", '01-jul-2022' "DtaOperacao",
'01-jul-2022' "DtaContabilizacao", null "GeraCtaPartida"
FROM consinco.FI_IntTitulo it
WHERE it.seqinttitulo NOT IN (SELECT seqinttitulo FROM consinco.fi_inttituloope);

--SELECT * FROM "view_contasapagar"@pg;

--SELECT * FROM consinco.map_produto p WHERE trunc(p.dtahorinclusao) = '09-09-2021'

--SELECT sysdate FROM dual;
DELETE FROM consinco.fi_inttitulo f WHERE f.seqinttitulo = 52652;
DELETE FROM consinco.fi_inttituloope f WHERE f.seqinttitulo = 1122;
sELECT * FROM consinco.fi_inttitulo;
sELECT * FROM consinco.fi_inttituloope;

DELETE FROM consinco.fi_inttitulo;
DELETE FROM consinco.fi_inttituloope;

/*CONSULTA UTILIZADA PARA FAZER INSERT NA TABELA Tabela FI_IntTitulo*/
/*
select p.desccompleta  produto, f.familia  DESCRICAO_FAMILIA, f.pesavel,
f.pmtdecimal  PERMITE_DECIMAL, f.pmtmultiplicacao, 
p.seqfamilia  codigo_familial,to_char(f.DTAHORINCLUSAO,'DD/MM/YYYY')  DATA_INCL_familial, 
to_char(p.DTAHORINCLUSAO,'DD/MM/YYYY')  DATA_INCL_PRODUTO, 
f.usuarioinclusao  USUAR_INC_FAMILIA,p.usuarioinclusao  USUAR_INC_PRODUTO,
f.codnbmsh  ncm, f.situacaonfpis  PIS_ENTRADA, f.situacaonfcofins  COFINS_ENTRADA,
f.codnatrec  NATUREZA_RECEITA, f.situacaonfpissai  PIS_SAIDA, f.situacaonfcofinssai  COFINS_SAIDA,
f.codcest FROM map_produto p, map_familia f
where f.seqfamilia = p.seqfamilia;



/*Consulta utilizada para fazer insert na tabela FI_IntTituloOpe*/
/*
SELECT '' as "SeqIntTitulo", 16::integer  as "CodOperacao", null as "SeqOP",

FROM 




--Consultas auxiliares utilizadas no desenvolvimento da query principal

SELECT 
FROM fornecedorprazo AS fp 
WHERE fp.id_loja = 1
AND fp.id_divisaofornecedor = 0
ORDER BY fp.id_fornecedor;

select count(id_fornecedor) FROM notaentrada WHERE id_loja = 1 and dataentrada > '2020-07-15'
group by id_fornecedor;

SELECT * FROM tipopagamento;

SELECT * FROM tiporecebimento;

SELECT * FROM tipofornecedor;

SELECT * FROM pagarfornecedorparcela limit 10;

SELECT pfp.valor as "valor parcela", pfp.valoracrescimo,
pfa.valor as abatimento, 
pfad.valor as adiantamento, pfdv.valor as devolucao,
pfpv.valor as verba
FROM pagarfornecedorparcela as pfp
LEFT JOIN pagarfornecedorparcelaabatimento as pfa
ON pfp.id = pfa.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparcelaadiantamento as pfad
ON pfp.id = pfad.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparceladevolucao as pfdv
ON pfp.id = pfdv.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparcelaverba as pfpv
ON pfp.id = pfpv.id_pagarfornecedorparcela;

SELECT f.id as fornecedor, pfp.id, pfp.numeroparcela, pfp.datavencimento, pf.numerodocumento, (sum(pfp.valor) - sum(coalesce(pfa.valor, 0)) + 
							sum(coalesce(pfp.valoracrescimo, 0)) -
								   coalesce(sum(pfad.valor), 0) -
								   coalesce(sum(pfdv.valor), 0) -
								   coalesce(sum(pfpv.valor), 0)) as "valorliquido"
FROM pagarfornecedorparcela as pfp
LEFT JOIN pagarfornecedor as pf
ON pf.id = pfp.id_pagarfornecedor
LEFT JOIN pagarfornecedorparcelaabatimento as pfa
ON pfp.id = pfa.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparcelaadiantamento as pfad
ON pfp.id = pfad.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparceladevolucao as pfdv
ON pfp.id = pfdv.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparcelaverba as pfpv
ON pfp.id = pfpv.id_pagarfornecedorparcela
JOIN fornecedor as f 
ON pf.id_fornecedor = f.id
WHERE pfp.id_situacaopagarfornecedorparcela = 0
GROUP BY 5,3,2,1;

select * from pagarfornecedorparcela limit 1

SELECT pfp.id, pf.numerodocumento, pfp.valor, pfa.valor, pfp.valoracrescimo
FROM pagarfornecedorparcela as pfp
LEFT JOIN pagarfornecedor as pf
ON pf.id = pfp.id_pagarfornecedor
LEFT JOIN pagarfornecedorparcelaabatimento as pfa
ON pfp.id = pfa.id_pagarfornecedorparcela
LEFT JOIN pagarfornecedorparcelaadiantamento as pfad
ON pfp.id = pfad.id_pagarfornecedorparcela
WHERE pfp.id_situacaopagarfornecedorparcela = 0
AND pf.numerodocumento = 737;

SELECT * FROM pagarfornecedorparcelaabatimento WHERE id_pagarfornecedorparcela = 150571;

150571
SELECT column_name, table_name FROM information_schema.columns
WHERE column_name LIKE '%abat%';

SELECT * FROM pagarfornecedor;

SELECT * FROM pagarfornecedorparcela WHERE id_situacaopagarfornecedorparcela =0;
SELECT * FROM pagarfornecedorparcelaabatimento LIMIT 1000;
SELECT * FROM pagarfornecedorparcelaadiantamento LIMIT 10;

SELECT pfp.id, sum(pfa.valor)
FROM pagarfornecedorparcela as pfp
JOIN pagarfornecedorparcelaabatimento as pfa
ON pfp.id = pfa.id_pagarfornecedorparcela
WHERE pfp.id_situacaopagarfornecedorparcela =0
GROUP BY 1;

SELECT * FROM pagarfornecedor LIMIT 1000;
SELECT * FROM situacaopagarfornecedorparcela;
select * from tipoentrada where descricao like '%RURAI%'
/*
SELECT
/*A nossa loja 4 no VR será a loja N°3 no consinco, por isso a necessidade de mudar na query */
/*
CASE 
when pf.id_loja = 1 then 1
when pf.id_loja = 2 then 2
when pf.id_loja = 4 then 3
end as "NroEmpresa",
/*CLASSIFICANDO OS TITULOS DE COMPRA DE MERCADORIA PARA REVENDA E PRODUTOR RURAL COMO DUPP E AS DESPESAS COMO DESP*/

/*
CASE 
WHEN pf.id_tipoentrada = 6 THEN 'DUPP'
WHEN pf.id_tipoentrada = 0 THEN 'DUPP'
ELSE 'DESP'
END as "CodEspecie", 
/*RETORNAR O CNPJ/CPF SEM O DIGITO VERIFICADOR*/
/*
left(cast(f.cnpj as varchar(14)),-2) as "CodPessoa",
left(cast(f.cnpj as varchar(14)),-2) as "CodPessoaNota",
pf.numerodocumento AS "NroTitulo", ne.serie AS "SerieTitulo", pff.numeroparcela AS "NroParcela", 
ne.numeronota AS "NroDocumento", pff.valor AS "VlrOriginal", pf.dataemissao AS "DtaEmissao",
pff.datavencimento AS "DtaEmissao", pff.datavencimento AS "DtaVencimento",
pfa.valor AS "VlrDscFinanc", round((pfa.valor/pff.valor)*100,2) || '%' AS "PctDescFinanc",
/*VER COM A VANDINHA SE É LANÇADO A DATA LIMITE OU SE REALMENTE É A DATA DO VENCIMENTO.*/
/*pff.datavencimento AS "DtaLimDscFinanc", pf.dataentrada AS "DtaMovimento"
FROM pagarfornecedor as pf JOIN fornecedor as f
ON pf.id_fornecedor = f.id
LEFT JOIN pagarfornecedorparcela AS pff
ON pff.id_pagarfornecedor = pf.id
LEFT JOIN notaentrada AS ne
ON pf.numerodocumento = ne.numeronota AND pf.id_fornecedor = ne.id_fornecedor
LEFT JOIN pagarfornecedorparcelaabatimento AS pfa
ON pff.id = pfa.id_pagarfornecedorparcela
WHERE pff.id_situacaopagarfornecedorparcela = 0
LIMIT 1000; */

/*

SELECT pf.id_fornecedor FROM pagarfornecedor as pf
JOIN pagarfornecedorparcela as pfp ON pf.id = pfp.id_pagarfornecedor
WHERE pfp.id_situacaopagarfornecedorparcela = 0
GROUP BY pf.id_fornecedor;
*/
/*
SELECT * FROM notaentrada LIMIT 10;

SELECT tablename FROM pg_tables WHERE tablename LIKE '%pagarfornecedorparcelaa%';

SELECT * FROM pagarfornecedorparceladevolucao;
SELECT * FROM pagarfornecedorparcelaverba;
SELECT * FROM pagarfornecedorparcelacontrato;
SELECT * FROM pagarfornecedorparcelacheque;
SELECT * FROM pagarfornecedorparcelaabatimento;
SELECT * FROM pagarfornecedorparcelaadiantamento;


SELECT * FROM pagarfornecedorparcela WHERE id = 67483;

SELECT
column_name,
data_type,
table_catalog,
table_name,
ordinal_position,
is_nullable,
table_schema
FROM
information_schema.columns


COPY
(
    SELECT tablename, schemaname FROM pg_tables
)
TO 'C:/git/sql/fornecedor.csv'
DELIMITER ';'
CSV HEADER
*/
/*
SELECT * FROM fornecedor limit 10;

SELECT * FROM agendafornecedor order by id_fornecedor;

SELECT * FROM fornecedorconfiguracaodatacorte order by id_fornecedor;

SELECT * FROM fornecedorpagamento order by id_fornecedor;

SELECT * FROM fornecedorprazopedido where id_loja = 1 order by id_fornecedor;

SELECT * FROM tipoagendafornecedor;

SELECT * FROM fornecedorprazo where id_loja = 1 order by id_fornecedor, id_divisaofornecedor;

SELECT * FROM fornecedordocumento;

SELECT * FROM notaentrada limit 10;

SELECT id_fornecedor, max(dataentrada) FROM notaentrada GROUP by id_fornecedor ORDER BY 1;
*/
