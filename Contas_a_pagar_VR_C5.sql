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
--A nossa loja 4 no VR ser� a loja N�3 no consinco, por isso a necessidade de mudar na query 
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
/*A observa��o � a concatena��o do n�mero do t�tulo com a observa��o lan�ada no VR software*/
pf."numerodocumento" "Observacao", null  "CodigoFator",
'S'  "TituloEmitido", 
--verificar se realmente n�o tem imposto
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
