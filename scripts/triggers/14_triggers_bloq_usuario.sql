--===========================================
-- TRIGGER PARA BLOQUEAR USUARIOS DEMITIDOS
--===========================================

-- ATIVA SOMENTE SE HOUVER MUDANCAS NO ATRIBUTO 'FUNCIONARIO.DATE_DEMISS'
CREATE OR REPLACE TRIGGER trg_bloqueia_usuario AFTER
    UPDATE OF date_demiss ON funcionario
    FOR EACH ROW
BEGIN
    IF ( :new.date_demiss IS NOT NULL ) THEN
        UPDATE usuarios
        SET
            situacao = 'B' --BLOQUEIA
        WHERE
                matricula = :old.matricula
            AND cod_empresa = :old.cod_empresa;
    END IF;
END;


--=========================
-- TESTES
-- ========================

--SIMULAÇÃO DA DEMISSÃO DO FUNCIONÁRIO DE MATRÍCULA 11 DA EMPRESA 1
SELECT * FROM FUNCIONARIO
WHERE COD_EMPRESA='1'
AND MATRICULA='11';

SELECT * FROM USUARIOS
WHERE COD_EMPRESA='1'
AND MATRICULA='11';

--UPDATE DO REGISTRO E TESTE DA TRIGGER
UPDATE FUNCIONARIO SET DATE_DEMISS=SYSDATE
WHERE COD_EMPRESA='1'
AND MATRICULA='11';
COMMIT;

SELECT * FROM USUARIOS
WHERE COD_EMPRESA='1'
AND MATRICULA='11';

