/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*tabela receber cheque*/
INSERT INTO consinco.fi_inttitulo(SeqIntTitulo, TipoRegistro, NroEmpresaMae,
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
SELECT getid "SeqIntTitulo", 1 "TipoRegistro", 1 "NroEmpresaMae",
CASE 
       when rc."id_loja" = 1 then 1
       when rc."id_loja" = 2 then 2
       when rc."id_loja" = 4 then 3
end "NroEmpresa",
'CHEQUE' "CodEspecie", null "TipoCodGerente", null "CodGerente", 
null "TipoCodVendedor", null "CodVendedor", 2 "TipoCodPessoa",
substr(rc."cpf",0,length(rc."cpf")-2) "CodPessoa", 2 "TipoCodPessoaNota",
substr(rc."cpf",0,length(rc."cpf")-2) "CodPessoaNota", rc."numerocheque" "NroTitulo",
null "SerieTitulo", 1 "NroParcela", rc."numerocupom" "NroDocumento", 
null "SerieDoc", rc."valorinicial" "VlrOriginal", rc."data" "DtaEmissao",
rc."datadeposito" "DtaVencimento", 'P' "TipoVencOriginal", null "DtaProgramada",
(coalesce(rc."numerocheque", 0) || ', ' || coalesce(rc."observacao", null)) "Observacao",
null "CodigoFator", 'S' "TituloEmitido", 0 "VlrDscFinanc", 
0 "PctDescFinanc", rc."datadeposito" "DtaLimDscFinanc",
'S' "CodCarteira", rc."id_banco" "Banco", rc."agencia" "Agencia",
null "NroCompensacao", rc."conta" "CtaEmitente", 'P' "ProprioTerceiro", 
null "SeqCtaCorrente", null "NossoNumero", null "DigNossoNum", 'T' "TituloCaixa",
'CHQ' "TipoNegociacao", null "NroCarga", 0 "PerJuroMora", rc."data" "DtaMovimento",
null "OrdenaCarga", null "DtaCarga", 'J' "Situacao", null "Origem",
getid "SeqTitulo", 
1 "SeqDepositario",
getid "NroProcesso", 
'IMPORTACAO' "UsuAlteracao", null "IndReplicacao", null "IndGerouReplicacao",
null "VlrDescComercial", null "SitCheqDev", null "CodBarra", null "LotePagto",
'N' "SitJuridica", null "Percadministracao", null "Vlradministracao", 
null "Dtacontabilizacao", null "Linkerp", null "Qtdparcela", 
null "Seqboleto", null "Seqmotorista", 
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", 
null "Numeronfse"
FROM "recebercheque"@pg rc
WHERE rc."id_situacaorecebercheque" = 0;

INSERT INTO consinco.Fi_Inttituloope (seqinttitulo, codoperacao,
seqop, vlroperacao, anotacao, seqtitoperacao, indreplicacao, indgeroureplicacao,
SeqCtacorrente, dtaoperacao, dtacontabilizacao, geractapartida)
SELECT it.SeqIntTitulo, 16 "CodOperacao", null "SeqOP", 
it.VlrOriginal "VlrOperacao", null "VlrOperacao", 
CONSINCO.S_FINANCEIRO.NEXTVAL "SeqTitOperacao", null "IndReplicacao",
null "IndGerouReplicacao", null "SeqCtacorrente", '27-may-2022' "DtaOperacao",
'27-may-2022' "DtaContabilizacao", null "GeraCtaPartida"
FROM consinco.FI_IntTitulo it
WHERE it.seqinttitulo NOT IN (SELECT seqinttitulo FROM consinco.fi_inttituloope);

SELECT * FROM consinco.fi_inttitulo;
SELECT * FROM consinco.fi_inttituloope;

SELECT tablename FROM pg_tables WHERE tablename LIKE '%receber%';

SELECT * FROM "recebercheque"@pg where "id_situacaorecebercheque" = 0;
