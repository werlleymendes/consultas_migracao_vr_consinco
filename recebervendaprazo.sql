/*CONSULTA PARA MIGRAÇÃO DO BANCO DE DADOS DO VR PARA O C5*/
/*consulta para migração do vr para a consinco 
contas a receber, tabela recebervendaprazo*/

SELECT null as "SeqIntTitulo", 1 as "TipoRegistro", 1 as "NroEmpresaMae",
CASE 
when rv.id_loja = 1 then 1
when rv.id_loja = 2 then 2
when rv.id_loja = 4 then 3
end as "NroEmpresa",
'DUPR' as "CodEspecie", null as CodGerente,null as "TipoCodVendedor", 
null as "CodVendedor", 2 as "TipoCodPessoa", 
LEFT(CAST(ce.cnpj as VARCHAR), -2) as "CodPessoa",
2 as "TipoCodPessoaNota",
LEFT(CAST(ce.cnpj as VARCHAR), -2) as "CodPessoaNota",
rv.id as "NroTitulo", null as "SerieTitulo", 1 as "NroParcela",
rv.numeronota as "NroDocumento", null as "SerieDoc", 
(rv.valor - coalesce(rvi.valor, 0)) as "VlrOriginal"
FROM recebervendaprazo  as rv
JOIN clienteeventual as ce
ON rv.id_clienteeventual = ce.id
LEFT JOIN (SELECT rv.id as id, sum(rvi.valor) as valor FROM recebervendaprazo rv, recebervendaprazoitem rvi 
WHERE rv.id = rvi.id_recebervendaprazo
AND id_situacaorecebervendaprazo = 0
GROUP BY 1) as rvi 
ON rv.id = rvi.id
WHERE rv.id_situacaorecebervendaprazo = 0;


SELECT * FROM recebervendaprazo WHERE id_situacaorecebervendaprazo = 0;
SELECT * FROM recebervendaprazoitem;

SELECT rv.id as id, sum(rvi.valor) FROM recebervendaprazo rv, recebervendaprazoitem rvi 
WHERE rv.id = rvi.id_recebervendaprazo
AND id_situacaorecebervendaprazo = 0
GROUP BY 1;


