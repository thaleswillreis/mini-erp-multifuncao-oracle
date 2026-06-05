--====================
-- VW_CONTAS_PAGAR
--====================

--TABELAS: CONTAS_PAGAR,FORNECEDORES

CREATE OR REPLACE VIEW VW_CONTAS_PAGAR AS
    SELECT A.COD_EMPRESA,
        A.ID_DOC,
        A.ID_FOR,
        B.RAZAO_FORNEC,
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
                'PAGTO EF COM ATRASO'
            ELSE 'VENCIDO' 
        END MSG
    FROM 
        CONTAS_PAGAR A
        INNER JOIN FORNECEDORES B
        ON A.ID_FOR=B.ID_FOR
            AND A.COD_EMPRESA=B.COD_EMPRESA;
 
 --====================
-- TESTE
--=====================

SELECT * FROM VW_CONTAS_PAGAR;

