/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*CRÉDITO ROTATIVO*/

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
when rc."id_loja" = 1 then 1
when rc."id_loja" = 2 then 2
when rc."id_loja" = 4 then 3
end "NroEmpresa",
'DUPR' "CodEspecie", null "TipoCodGerente", null "CodGerente", 
null "TipoCodVendedor", null "CodVendedor", 2 "TipoCodPessoa",
substr(cp."cnpj",0,length(cp."cnpj")-2) "CodPessoa", 2 "TipoCodPessoaNota",
substr(cp."cnpj",0,length(cp."cnpj")-2) "CodPessoaNota", rc."id" "NroTitulo",
null "SerieTitulo", 1 "NroParcela", rc."numerocupom" "NroDocumento", 
null "SerieDoc", 
/*Aguardar resposta do rodrigues, se é valor inicial ou valor liquido*/
(rc."valor" - coalesce(rci.valorabatimento, 0)) "VlrOriginal", rc."dataemissao" "DtaEmissao", 
rc."datavencimento" "DtaVencimento", 'P' "TipoVencOriginal", 
null "DtaProgramada", 
rc."id" "Observacao", null "CodigoFator",
'S' "TituloEmitido", 0 "VlrDscFinanc", 0 "PctDescFinanc", 
rc."datavencimento" "DtaLimDscFinanc", 'S' "CodCarteira", null "Banco",
null "Agencia", null "NroCompensacao", null "CtaEmitente", 
null "ProprioTerceiro", 0 "SeqCtaCorrente", null "NossoNumero",
null "DigNossoNum", 'T' "TituloCaixa", 'BLT' "TipoNegociacao",
null "NroCarga", 0 "PerJuroMora", rc."dataemissao" "DtaMovimento",
null "OrdenaCarga", null "DtaCarga", 'J' "Situacao", 
null "Origem", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
''/*getid*/ "SeqTitulo", 1 "SeqDepositario", 
/*Quando for rodar o insert, solicitar ajuda ao analista da TOTVS*/
''/*getid*/ "NroProcesso", 'IMPORTACAO' "UsuAlteracao", null "IndReplicacao", 
null "IndGerouReplicacao", null "VlrDescComercial", null "SitCheqDev",
null "CodBarra", null "LotePagto", 'N' "SitJuridica", null "Percadministracao",
null "Vlradministracao", 
null "Dtacontabilizacao", null "Linkerp", null "Qtdparcela", 
null "Seqboleto", null "Seqmotorista", 
null "Percdesccontrato", null "Vlrdesccontrato", null "Justcancel", 
null "Numeronfse"
FROM "recebercreditorotativo"@pg rc
JOIN "clientepreferencial"@pg cp ON rc."id_clientepreferencial" = cp."id"
LEFT JOIN (SELECT rc."id", SUM(rci."valor") valorabatimento
		        FROM "recebercreditorotativoitem"@pg rci
						RIGHT JOIN "recebercreditorotativo"@pg rc
						ON rc."id" = rci."id_recebercreditorotativo"
						WHERE rc."id_situacaorecebercreditorotativo" = 0
						and rci."valor" is not null
						GROUP BY rc."id") rci
ON rc."id" = rci."id"
WHERE rc."id_situacaorecebercreditorotativo" = 0
;

SELECT p.NROCGCCPF
FROM consinco.ge_pessoa p, consinco.fi_cliente c
 WHERE p.seqpessoa = c.seqpessoa and NROCGCCPF IN(6796873,    
7366623,
29703903,    
31152583,   
41317543,   
41366983,   
72841343,   
92727553,   
168886265,    
266807183,   
277550533,   
348877155,   
356316003,   
426073613,   
440612773,  
444072530,   
486336153,   
517765453,   
576899432,   
787830893,   
822751438,   
916238553,   
16511970001,    
71135580001,   
72109250062,   
72373730062,   
77700070001,   
78617120002,   
89587340001,   
109682040019,    
173150310001,   
202214230001,   
222126960001,   
235442990001,   
604090750159,   
633104110001   
);

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







/*Consultas auxiliares utilizadas para desenvolvimento da query principal*/


/*Consulta utilizada para criar uma pseudo-tabela com a soma dos abatimentos, para
poder enviar apenas o restante na query principal.*/
SELECT rc.id, rc.numerocupom, rc.valor, rci.valorabatimento,  
(rc.valor - rci.valorabatimento) as totalliquido, rc.dataemissao
FROM recebercreditorotativo as rc
LEFT JOIN (SELECT rc.id, SUM(rci.valor) as valorabatimento
		   FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id) as rci
ON rc.id = rci.id
WHERE rc.id_situacaorecebercreditorotativo = 0

SELECT sum(rc.valor), sum(rci.valorabatimento),  
(sum(rc.valor) - sum(rci.valorabatimento)) as totalliquido
FROM recebercreditorotativo as rc
LEFT JOIN (SELECT rc.id, SUM(rci.valor) as valorabatimento
		   FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id) as rci
ON rc.id = rci.id
WHERE rc.id_situacaorecebercreditorotativo = 0



SELECT * FROM "recebercreditorotativo"@pg  rc WHERE rc."id_situacaorecebercreditorotativo" = 0;

SELECT * FROM recebercreditorotativoitem LIMIT 10;

SELECT rc.id, SUM(rci.valor) FROM recebercreditorotativoitem as rci
						RIGHT JOIN recebercreditorotativo as rc
						ON rc.id = rci.id_recebercreditorotativo
						WHERE rc.id_situacaorecebercreditorotativo = 0
						and rci.valor is not null
						GROUP BY rc.id


SELECT tablename, schemaname FROM pg_tables WHERE tablename like '%rotat%';

SELECT * FROM creditorotativoparcela LIMIT 10;

SELECT * FROM clientepreferencial LIMIT 1
