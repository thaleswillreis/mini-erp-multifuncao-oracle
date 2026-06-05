--====================
-- VW_CONTAS_RECEBER
--====================

--TABELAS: CONTAS_RECEBER,CLIENTES

CREATE OR REPLACE VIEW VW_CONTAS_RECEBER AS
    SELECT
        A.COD_EMPRESA, 
        A.ID_DOC,
        A.ID_CLIENTE,
        B.RAZAO_CLIENTE,
        A.PARC,
        A.DATA_VENC,
        A.DATA_PAGTO,
        A.VALOR,
        CASE 
            WHEN A.DATA_PAGTO IS NULL THEN 
                'ABERTO' 
            ELSE 
                'PAGO' 
        END SITUACAO,
        CASE 
            WHEN A.DATA_VENC>SYSDATE THEN 
                'NORMAL' 
            WHEN A.DATA_PAGTO>A.DATA_VENC THEN 
                'PAGTO EM COM ATRASO'
            ELSE 
                'VENCIDO' 
        END MSG,
        CASE 
            WHEN A.DATA_VENC=A.DATA_PAGTO THEN 
                0
            WHEN A.DATA_PAGTO>A.DATA_VENC THEN 
                CAST(CAST(A.DATA_PAGTO AS DATE)-CAST(A.DATA_VENC AS DATE) AS INT )
            ELSE 
                CAST(SYSDATE-CAST(A.DATA_VENC AS DATE) AS INT ) 
        END DIAS_ATRASO
    FROM 
        CONTAS_RECEBER A
        INNER JOIN CLIENTES B
        ON A.ID_CLIENTE=B.ID_CLIENTE
            AND A.COD_EMPRESA=B.COD_EMPRESA;

 --====================
-- TESTE
--=====================

SELECT * FROM VW_CONTAS_RECEBER;