--======================================
-- TRIGGER PARA SEQUENCIAS DAS TABELAS 
--======================================

-- SEQUÊNCIA DA TABELA EMPRESA
CREATE OR REPLACE TRIGGER trg_empresa1 BEFORE
    INSERT ON empresa
    FOR EACH ROW
BEGIN
    IF :new.cod_empresa IS NULL THEN
        SELECT
            seq_emp.NEXTVAL
        INTO :new.cod_empresa
        FROM
            dual;

    END IF;
END;

-- SEQUÊNCIA DA TABELA APONTAMENTO
CREATE OR REPLACE TRIGGER trg_apont BEFORE
    INSERT ON apontamentos
    FOR EACH ROW
BEGIN
    IF :new.id_apon IS NULL THEN
        SELECT
            seq_apon.NEXTVAL
        INTO :new.id_apon
        FROM
            dual;

    END IF;
END; 

-- SEQUÊNCIA DA TABELA CONTAS A PAGAR
CREATE OR REPLACE TRIGGER trg_cap BEFORE
    INSERT ON contas_pagar
    FOR EACH ROW
BEGIN
    IF :new.id_doc IS NULL THEN
        SELECT
            seq_cap.NEXTVAL
        INTO :new.id_doc
        FROM
            dual;

    END IF;
END; 

-- SEQUÊNCIA DA TABELA CLIENTES    
CREATE OR REPLACE TRIGGER trg_cliente BEFORE
    INSERT ON clientes
    FOR EACH ROW
BEGIN
    IF :new.id_cliente IS NULL THEN
        SELECT
            seq_cli.NEXTVAL
        INTO :new.id_cliente
        FROM
            dual;

    END IF;
END; 

-- SEQUÊNCIA DA TABELA CONTAS RECEBER
CREATE OR REPLACE TRIGGER trg_cre BEFORE
    INSERT ON contas_receber
    FOR EACH ROW
BEGIN
    IF :new.id_doc IS NULL THEN
        SELECT
            seq_cre.NEXTVAL
        INTO :new.id_doc
        FROM
            dual;

    END IF;
END; 

--SEQUÊNCIA DA TABELAS FORNECEDOR
CREATE OR REPLACE TRIGGER trg_for BEFORE
    INSERT ON fornecedores
    FOR EACH ROW
BEGIN
    IF :new.id_for IS NULL THEN
        SELECT
            seq_for.NEXTVAL
        INTO :new.id_for
        FROM
            dual;

    END IF;
END; 

--SEQUÊNCIA DA TABELA GERENTES
CREATE OR REPLACE TRIGGER trg_ger BEFORE
    INSERT ON gerentes
    FOR EACH ROW
BEGIN
    IF :new.id_ger IS NULL THEN
        SELECT
            seq_gerentes.NEXTVAL
        INTO :new.id_ger
        FROM
            dual;

    END IF;
END; 

-- SEQUÊNCIA DA TABELA ESTOQUE MOV
CREATE OR REPLACE TRIGGER trg_movest BEFORE
    INSERT ON estoque_mov
    FOR EACH ROW
BEGIN
    IF :new.id_mov IS NULL THEN
        SELECT
            seq_movest.NEXTVAL
        INTO :new.id_mov
        FROM
            dual;

    END IF;
END; 

--SEQUÊNCIA DA ORDEM DE PRODUCAO
CREATE OR REPLACE TRIGGER trg_op BEFORE
    INSERT ON ordem_prod
    FOR EACH ROW
BEGIN
    IF :new.id_ordem IS NULL THEN
        SELECT
            seq_op.NEXTVAL
        INTO :new.id_ordem
        FROM
            dual;

    END IF;
END; 

--SEQUÊNCIA DA CONDIÇÃO DE PAGAMENTO
CREATE OR REPLACE TRIGGER trg_cod_pagto BEFORE
    INSERT ON cond_pagto
    FOR EACH ROW
BEGIN
    IF :new.cod_pagto IS NULL THEN
        SELECT
            seq_pagto.NEXTVAL
        INTO :new.cod_pagto
        FROM
            dual;

    END IF;
END; 

--SEQUENCIA PARA A TABELA TIPO DE MATERIAL
CREATE OR REPLACE TRIGGER trg_cod_tip_mat BEFORE
    INSERT ON tipo_mat
    FOR EACH ROW
BEGIN
    IF :new.cod_tip_mat IS NULL THEN
        SELECT
            seq_tip_mat.NEXTVAL
        INTO :new.cod_tip_mat
        FROM
            dual;

    END IF;
END; 

--SEQ_PARA A TABELA VENDEDORES CAMPO ID_VEND
CREATE OR REPLACE TRIGGER trg_vendedor BEFORE
    INSERT ON vendedores
    FOR EACH ROW
BEGIN
    IF :new.id_vend IS NULL THEN
        SELECT
            seq_vendedores.NEXTVAL
        INTO :new.id_vend
        FROM
            dual;

    END IF;
END; 

-- TRIGGER PARA NUMERACAO DE NFE
CREATE OR REPLACE TRIGGER trg_num_nfe BEFORE
    INSERT ON nota_fiscal
    FOR EACH ROW
BEGIN
    UPDATE param_nfe
    SET
        num_nfe = num_nfe + 1
    WHERE
        cod_empresa = :new.cod_empresa;

    SELECT
        num_nfe
    INTO :new.num_nf
    FROM
        param_nfe
    WHERE
        cod_empresa = :new.cod_empresa;

END; 

-- TRIGGER PARA PARAMETROS PEDIDO DE COMPRAS
CREATE OR REPLACE TRIGGER trg_num_ped_compras BEFORE
    INSERT ON ped_compras
    FOR EACH ROW
BEGIN
    UPDATE param_ped_compras
    SET
        num_ped = num_ped + 1
    WHERE
        cod_empresa = :new.cod_empresa;

    SELECT
        num_ped
    INTO :new.num_pedido
    FROM
        param_ped_compras
    WHERE
        cod_empresa = :new.cod_empresa;

END; 
    
-- TRIGGER PARA PARAMETROS PEDIDO DE VENDAS
CREATE OR REPLACE TRIGGER trg_num_ped_vendas BEFORE
    INSERT ON ped_vendas
    FOR EACH ROW
BEGIN
    UPDATE param_ped_vendas
    SET
        num_ped = num_ped + 1
    WHERE
        cod_empresa = :new.cod_empresa;

    SELECT
        num_ped
    INTO :new.num_pedido
    FROM
        param_ped_vendas
    WHERE
        cod_empresa = :new.cod_empresa;

END; 

--TRIGGER PARA PARAMETROS MATRICULA FUNCIONARIOS
CREATE OR REPLACE TRIGGER trg_mat_func BEFORE
    INSERT ON funcionario
    FOR EACH ROW
BEGIN
    UPDATE param_matricula
    SET
        matricula = matricula + 1
    WHERE
        cod_empresa = :new.cod_empresa;

    SELECT
        matricula
    INTO :new.matricula
    FROM
        param_matricula
    WHERE
        cod_empresa = :new.cod_empresa;

END;