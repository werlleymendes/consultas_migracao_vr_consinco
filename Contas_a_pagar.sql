/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*CONTAS A PAGAR*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
/*A nossa loja 4 no VR será a loja N°3 no consinco, por isso a necessidade de mudar na query */
CASE 
when pf.id_loja = 1 then 1
when pf.id_loja = 2 then 2
when pf.id_loja = 4 then 3
end as "NroEmpresa",
/*CLASSIFICANDO OS TITULOS DE COMPRA DE MERCADORIA PARA REVENDA E PRODUTOR RURAL COMO DUPP 
E AS DESPESAS COMO DESP*/
CASE 
WHEN pf.id_tipoentrada = 6 THEN 'DUPP'
WHEN pf.id_tipoentrada = 0 THEN 'DUPP'
ELSE 'DESP'
END as "CodEspecie", 
/*RETORNAR O CNPJ/CPF SEM O DIGITO VERIFICADOR*/
null as "TipoCodGerente", null as "CodGerente", null as "TipoCodVendedor", 
null as "CodVendedor", 2 as "TipoCodPessoa",
left(cast(f.cnpj as varchar(14)),-2) as "CodPessoa",
2 as "TipoCodPessoaNota",
left(cast(f.cnpj as varchar(14)),-2) as "CodPessoaNota",
pf.numerodocumento AS "NroTitulo", ne.serie AS "SerieTitulo", pff.numeroparcela AS "NroParcela", 
ne.numeronota AS "NroDocumento", ne.serie AS "SerieDoc",
pff.valor AS "VlrOriginal", pf.dataemissao AS "DtaEmissao",
pff.datavencimento AS "DtaEmissao", pff.datavencimento AS "DtaVencimento",
'P' as "TipoVencOriginal", null as "DtaProgramada", 
/*A observação é a concatenação do número do título com a observação lançada no VR software*/
concat_ws(', ', pf.numerodocumento, pff.observacao) as "Observacao", null as "CodigoFator",
'S' as "TituloEmitido", 
pfa.valor AS "VlrDscFinanc", round((pfa.valor/pff.valor)*100,2) AS "PctDescFinanc",
pff.datavencimento AS "DtaLimDscFinanc", 'S' as "CodCarteira", null as "Banco", 
null as "Agencia", '' as "NroCompensacao", null as "CtaEmitente", null as "ProprioTerceiro",
0 as "SeqCtaCorrente", '' as "NossoNumero", null as "DigNossoNum", 'T' as "TituloCaixa",
'BLT' as "TipoNegociacao", null as "NroCarga", null as "PerJuroMora",
pf.dataentrada AS "DtaMovimento", null as "OrdenaCarga", null as "DtaCarga",
'J' as "Situacao", null as "Origem", 2 as "SeqDepositario", 'ORCAMENTO' as "UsuAlteracao",
null as "IndReplicacao", null as "IndGerouReplicacao", null as "VlrDescComercial",
null as "SitCheqDev", null as "CodBarra", null as "LotePagto", 'N' as "SitJuridica",
null as "Percadministracao", null as "Vlradministracao", null as "Dtacontabilizacao",
null as "Linkerp", null as "Qtdparcela", null as "Vlrcomissaofat", null as "Seqboleto",
null as "Seqmotorista", null as "Percdesccontrato", null as "Vlrdesccontrato",
null as "Justcancel", null as "CMC7", null as "Apporigem"
FROM pagarfornecedor as pf JOIN fornecedor as f
ON pf.id_fornecedor = f.id
LEFT JOIN pagarfornecedorparcela AS pff
ON pff.id_pagarfornecedor = pf.id
LEFT JOIN notaentrada AS ne
ON pf.numerodocumento = ne.numeronota AND pf.id_fornecedor = ne.id_fornecedor
LEFT JOIN pagarfornecedorparcelaabatimento AS pfa
ON pff.id = pfa.id_pagarfornecedorparcela
WHERE pff.id_situacaopagarfornecedorparcela = 0;





SELECT *
FROM fornecedorprazo AS fp 
WHERE fp.id_loja = 1
AND fp.id_divisaofornecedor = 0
ORDER BY fp.id_fornecedor;

select count(id_fornecedor) FROM notaentrada WHERE id_loja = 1 and dataentrada > '2020-07-15'
group by id_fornecedor;

SELECT * FROM tipopagamento;

SELECT * FROM tiporecebimento;

SELECT * FROM tipofornecedor;

select * from pagarfornecedorparcelaabatimento limit 10;

SELECT column_name, table_name FROM information_schema.columns
WHERE column_name LIKE '%abat%';

SELECT * FROM pagarfornecedorparcela LIMIT 1000;
SELECT * FROM pagarfornecedor LIMIT 1000;
SELECT * FROM situacaopagarfornecedorparcela;
select * from tipoentrada where descricao like '%RURAI%'

SELECT
/*A nossa loja 4 no VR será a loja N°3 no consinco, por isso a necessidade de mudar na query */
CASE 
when pf.id_loja = 1 then 1
when pf.id_loja = 2 then 2
when pf.id_loja = 4 then 3
end as "NroEmpresa",
/*CLASSIFICANDO OS TITULOS DE COMPRA DE MERCADORIA PARA REVENDA E PRODUTOR RURAL COMO DUPP E AS DESPESAS COMO DESP*/
CASE 
WHEN pf.id_tipoentrada = 6 THEN 'DUPP'
WHEN pf.id_tipoentrada = 0 THEN 'DUPP'
ELSE 'DESP'
END as "CodEspecie", 
/*RETORNAR O CNPJ/CPF SEM O DIGITO VERIFICADOR*/
left(cast(f.cnpj as varchar(14)),-2) as "CodPessoa",
left(cast(f.cnpj as varchar(14)),-2) as "CodPessoaNota",
pf.numerodocumento AS "NroTitulo", ne.serie AS "SerieTitulo", pff.numeroparcela AS "NroParcela", 
ne.numeronota AS "NroDocumento", pff.valor AS "VlrOriginal", pf.dataemissao AS "DtaEmissao",
pff.datavencimento AS "DtaEmissao", pff.datavencimento AS "DtaVencimento",
pfa.valor AS "VlrDscFinanc", round((pfa.valor/pff.valor)*100,2) || '%' AS "PctDescFinanc",
/*VER COM A VANDINHA SE É LANÇADO A DATA LIMITE OU SE REALMENTE É A DATA DO VENCIMENTO.*/
pff.datavencimento AS "DtaLimDscFinanc", pf.dataentrada AS "DtaMovimento"
FROM pagarfornecedor as pf JOIN fornecedor as f
ON pf.id_fornecedor = f.id
LEFT JOIN pagarfornecedorparcela AS pff
ON pff.id_pagarfornecedor = pf.id
LEFT JOIN notaentrada AS ne
ON pf.numerodocumento = ne.numeronota AND pf.id_fornecedor = ne.id_fornecedor
LEFT JOIN pagarfornecedorparcelaabatimento AS pfa
ON pff.id = pfa.id_pagarfornecedorparcela
WHERE pff.id_situacaopagarfornecedorparcela = 0
LIMIT 1000;



SELECT pf.id_fornecedor FROM pagarfornecedor as pf
JOIN pagarfornecedorparcela as pfp ON pf.id = pfp.id_pagarfornecedor
WHERE pfp.id_situacaopagarfornecedorparcela = 0
GROUP BY pf.id_fornecedor;

SELECT * FROM notaentrada LIMIT 10;

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
