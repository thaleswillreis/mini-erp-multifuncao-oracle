--========================================================
--CADASTROS
--========================================================

-- TABELA EMPRESA
CREATE TABLE empresa (
    cod_empresa  INT NOT NULL PRIMARY KEY,
    nome_empresa VARCHAR2(50),
    fantasia     VARCHAR2(15)
);
 
 --CRIA SEQUENCIA PARA O CODIGO EMPRESA
CREATE SEQUENCE seq_emp START WITH 1 INCREMENT BY 1 NOMAXVALUE;

-- TABELA DE UNIDADE FEDERATIVA
CREATE TABLE uf (
    cod_uf   VARCHAR2(2) NOT NULL PRIMARY KEY,
    sigla_uf VARCHAR2(2) NOT NULL,
    nome_uf  VARCHAR2(30) NOT NULL
);

--TABELA CIDADES
CREATE TABLE cidades (
    cod_cidade  VARCHAR2(7) NOT NULL PRIMARY KEY,
    cod_uf      VARCHAR2(2) NOT NULL,
    nome_cidade VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_cid1 FOREIGN KEY ( cod_uf )
        REFERENCES uf ( cod_uf )
);

--TABELA CLIENTES
CREATE TABLE clientes (
    cod_empresa   INT NOT NULL,
    id_cliente    INT NOT NULL PRIMARY KEY,
    razao_cliente VARCHAR2(100) NOT NULL,
    fantasia      VARCHAR2(15) NOT NULL,
    endereco      VARCHAR2(50) NOT NULL,
    nro           VARCHAR2(10) NOT NULL,
    bairro        VARCHAR2(20) NOT NULL,
    cod_cidade    VARCHAR2(7) NOT NULL,
    cep           VARCHAR2(8),
    cnpj_cpf      VARCHAR2(15),
    tipo_cliente  CHAR(1)
        CONSTRAINT ck_tc1 CHECK ( tipo_cliente IN ( 'F', 'J' ) ),
    data_cadastro DATE NOT NULL,
    cod_pagto     INT,
    CONSTRAINT fk_cod_emp1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT fk_cli1 FOREIGN KEY ( cod_cidade )
        REFERENCES cidades ( cod_cidade )
);

 -- CRIA SEQUENCIA PARA CLIENTES;  
CREATE SEQUENCE seq_cli START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA FORNECEDORES
CREATE TABLE fornecedores (
    cod_empresa   INT NOT NULL,
    id_for        INT NOT NULL PRIMARY KEY,
    razao_fornec  VARCHAR2(100) NOT NULL,
    fantasia      VARCHAR2(15) NOT NULL,
    endereco      VARCHAR2(50) NOT NULL,
    nro           VARCHAR2(10) NOT NULL,
    bairro        VARCHAR2(20) NOT NULL,
    cod_cidade    VARCHAR2(7) NOT NULL,
    cep           VARCHAR2(8),
    cnpj_cpf      VARCHAR2(15),
    tipo_fornec   CHAR(1)
        CONSTRAINT ck_tf1 CHECK ( tipo_fornec IN ( 'F', 'J' ) ),
    data_cadastro DATE NOT NULL,
    cod_pagto     INT,
    CONSTRAINT fk_cod_emp2 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT fk_for1 FOREIGN KEY ( cod_cidade )
        REFERENCES cidades ( cod_cidade )
);

 -- CRIA SEQUENCIA PARA FORNECEDORES;  
CREATE SEQUENCE seq_for START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA TIPO DE MATERIAL
CREATE TABLE tipo_mat (
    cod_tip_mat  INT NOT NULL PRIMARY KEY,
    desc_tip_mat VARCHAR2(20) NOT NULL
);

--CRIA SEQUENCIA TIPO MATERIAL
CREATE SEQUENCE seq_tip_mat START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA MATERIAL
CREATE TABLE material (
    cod_empresa INT NOT NULL,
    cod_mat     INT NOT NULL,
    descricao   VARCHAR2(50) NOT NULL,
    preco_unit  DECIMAL(10, 2) NOT NULL,
    cod_tip_mat INT NOT NULL,
    CONSTRAINT fk_cod_emp3 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT fk_mat1 FOREIGN KEY ( cod_tip_mat )
        REFERENCES tipo_mat ( cod_tip_mat ),
    CONSTRAINT pk_emp_mat PRIMARY KEY ( cod_empresa,
                                        cod_mat )
);

--TABELA COMPOSTA EMPRESA/MATERIAL/FORNECEDOR
CREATE TABLE mat_fornec (
    cod_empresa INT NOT NULL,
    cod_mat     INT NOT NULL,
    id_for      INT NOT NULL,
    CONSTRAINT pk_mat_for PRIMARY KEY ( cod_empresa,
                                        cod_mat,
                                        id_for ),
    CONSTRAINT fk_mat_for1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT fk_mar_for2 FOREIGN KEY ( id_for )
        REFERENCES fornecedores ( id_for )
);

--CRIA INDEX
--SIMULA ERRO INDEX DE CHAVE PRIMARIA
--CREATE INDEX IX_MAT1 ON MATERIAL(COD_EMPRESA,COD_MAT);
--CRIANDO INDEX TIPO MAT
CREATE INDEX ix_mat2 ON
    material (
        cod_tip_mat
    );

--========================================================
--PRODUÇÃO
--========================================================

--TABELA ORDEM DE PRODUCAO
CREATE TABLE ordem_prod (
    cod_empresa  INT NOT NULL,
    id_ordem     INT NOT NULL PRIMARY KEY,
    cod_mat_prod INT NOT NULL,
    qtd_plan     DECIMAL(10, 2) NOT NULL,
    qtd_prod     DECIMAL(10, 2) NOT NULL,
    data_ini     DATE,
    data_fim     DATE,
    situacao     CHAR(1)
        CONSTRAINT ck_op1 CHECK ( situacao IN ( 'A', 'P', 'F' ) ),--A-ABERTA, P-PLANEJADA -F-FECHADA
    CONSTRAINT fk_op1
        FOREIGN KEY ( cod_mat_prod,
                      cod_empresa )
            REFERENCES material ( cod_mat,
                                  cod_empresa )
    --CONSTRAINT FK_COD_EMP4 FOREIGN KEY (COD_EMPRESA) REFERENCES EMPRESA(COD_EMPRESA)
);

--CRIA SEQUENCIA ORDEM DE PRODUCAO
CREATE SEQUENCE seq_op START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA APONTAMENTOS DE PRODUCAO
CREATE TABLE apontamentos (
    cod_empresa  INT NOT NULL,
    id_apon      INT NOT NULL PRIMARY KEY,
    id_ordem     INT NOT NULL,
    cod_mat_prod INT,
    qtd_apon     DECIMAL(10, 2),
    data_apon    DATE NOT NULL,
	--CAMPO LOTE CRIADO NO FINAL
	--LOGIN, SERA CRIADO APOIS CRIACAO DA TABELA USUARIOS
    CONSTRAINT fk_ap1
        FOREIGN KEY ( cod_mat_prod,
                      cod_empresa )
            REFERENCES material ( cod_mat,
                                  cod_empresa ),
    CONSTRAINT fk_apon1 FOREIGN KEY ( id_ordem )
        REFERENCES ordem_prod ( id_ordem )
);

-- CRIA SEQUENCIA PARA TABELA APONTAMENTOS
CREATE SEQUENCE seq_apon START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA FICHA TECNICA
CREATE TABLE ficha_tecnica (
    cod_empresa   INT NOT NULL,
    cod_mat_prod  INT NOT NULL,
    cod_mat_neces INT NOT NULL,
    qtd_neces     DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_fic1
        FOREIGN KEY ( cod_empresa,
                      cod_mat_prod )
            REFERENCES material ( cod_empresa,
                                  cod_mat ),
    CONSTRAINT fk_fic2
        FOREIGN KEY ( cod_empresa,
                      cod_mat_neces )
            REFERENCES material ( cod_empresa,
                                  cod_mat )
);

-- CRIA SEQUENCIA PARA TABELA FICHA_TECNICA
CREATE SEQUENCE seq_ft START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA CONSUMO
CREATE TABLE consumo (
    id_apon       INT NOT NULL,
    cod_empresa   INT NOT NULL,
    cod_mat_neces INT NOT NULL,
    qtd_consumida DECIMAL(10, 2) NOT NULL,
    lote          VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_cons1
        FOREIGN KEY ( cod_empresa,
                      cod_mat_neces )
            REFERENCES material ( cod_empresa,
                                  cod_mat ),
    CONSTRAINT fk_cons2 FOREIGN KEY ( id_apon )
        REFERENCES apontamentos ( id_apon )
);

--========================================================
--SUPRIMENTOS
--========================================================

--TABELA ESTOQUE
CREATE TABLE estoque (
    cod_empresa INT NOT NULL,
    cod_mat     INT NOT NULL,
    qtd_saldo   DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_est1
        FOREIGN KEY ( cod_empresa,
                      cod_mat )
            REFERENCES material ( cod_empresa,
                                  cod_mat ),
    CONSTRAINT pk_estoque1 PRIMARY KEY ( cod_empresa,
                                         cod_mat )
);

--TABELA ESTOQUE_LOTE
CREATE TABLE estoque_lote (
    cod_empresa INT NOT NULL,
    cod_mat     INT NOT NULL,
    lote        VARCHAR2(20) NOT NULL,
    qtd_lote    DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_estl1 PRIMARY KEY ( cod_empresa,
                                      cod_mat,
                                      lote ), --PK COMPOSTA
    CONSTRAINT fk_estl1
        FOREIGN KEY ( cod_empresa,
                      cod_mat )
            REFERENCES material ( cod_empresa,
                                  cod_mat )
);

--TABELA ESTOQUE_MOV
CREATE TABLE estoque_mov (
    id_mov      INT NOT NULL PRIMARY KEY,
    cod_empresa INT NOT NULL,
    tip_mov     VARCHAR2(1),
    CONSTRAINT ck_mov CHECK ( tip_mov IN ( 'S', 'E' ) ), --S=SAIDA ,E=ENTRADA
    cod_mat     INT NOT NULL,
    lote        VARCHAR2(20) NOT NULL,
    qtd         DECIMAL(10, 2) NOT NULL,
    data_mov    DATE NOT NULL,
    data_hora   DATE NOT NULL,
    CONSTRAINT fk_estm1
        FOREIGN KEY ( cod_empresa,
                      cod_mat )
            REFERENCES material ( cod_empresa,
                                  cod_mat )
	--CAMPO LOGIN TABELA ESTOQUE_MOV CRIACAO APOS TABELA USUARIO
);

-- CRIA SEQUENCIA PARA TABELA ESTOQUE_MOV
CREATE SEQUENCE seq_movest START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA PED_COMPRAS	
CREATE TABLE ped_compras (
    cod_empresa  INT NOT NULL,
    num_pedido   INT NOT NULL,
    id_for       INT NOT NULL,
    cod_pagto    INT NOT NULL, --ALTERAR  COD_PAGTO TAB PED_COMPRAS PARA FOREIGN KEY APOS TABELA COND_PAGTO  	
    data_pedido  DATE NOT NULL,
    data_entrega DATE NOT NULL,
    situacao     NCHAR(1) NOT NULL, --A-ABERTO P-PLANEJADO -F FINALIZADO
    total_ped    DECIMAL(10, 2),
    CONSTRAINT fk_pedc1 FOREIGN KEY ( id_for )
        REFERENCES fornecedores ( id_for ),
    CONSTRAINT pk_pedc1 PRIMARY KEY ( cod_empresa,
                                      num_pedido )
);

--TABELA DE PARAMETROS DE NUMEROS DE PEDIDO POR EMPRESA
CREATE TABLE param_ped_compras (
    cod_empresa INT NOT NULL PRIMARY KEY,
    num_ped     INT NOT NULL,
    CONSTRAINT fk_ppc FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--TABELA PEDIDO COMPRAS
CREATE TABLE ped_compras_itens (
    cod_empresa INT NOT NULL,
    num_pedido  INT NOT NULL,
    seq_mat     INT NOT NULL,
    cod_mat     INT NOT NULL,
    qtd         INT NOT NULL,
    val_unit    DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_pedit1
        FOREIGN KEY ( cod_empresa,
                      num_pedido )
            REFERENCES ped_compras ( cod_empresa,
                                     num_pedido ),
    CONSTRAINT fk_pedit2
        FOREIGN KEY ( cod_empresa,
                      cod_mat )
            REFERENCES material ( cod_empresa,
                                  cod_mat ),
    CONSTRAINT pk_ped_c_it PRIMARY KEY ( cod_empresa,
                                         num_pedido,
                                         seq_mat )
);

--========================================================
--RH
--========================================================

--TABELA CENTRO DE CUSTO
CREATE TABLE centro_custo (
    cod_empresa INT NOT NULL,
    cod_cc      VARCHAR2(4) NOT NULL,
    nome_cc     VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_cc1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT pk_cc1 PRIMARY KEY ( cod_empresa,
                                    cod_cc )
);

--TABELA CARGOS 
CREATE TABLE cargos (
    cod_empresa INT NOT NULL,
    cod_cargo   INT NOT NULL,
    nome_cargo  VARCHAR2(50),
    CONSTRAINT fk_carg1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT pk_carg1 PRIMARY KEY ( cod_empresa,
                                      cod_cargo )
);

--TABELA FUNCIONARIO
CREATE TABLE funcionario (
    cod_empresa INT NOT NULL,
    matricula   INT NOT NULL,
    cod_cc      VARCHAR2(4) NOT NULL,
    nome        VARCHAR2(50) NOT NULL,
    rg          VARCHAR2(15) NOT NULL,
    cpf         VARCHAR2(15) NOT NULL,
    endereco    VARCHAR2(50) NOT NULL,
    numero      VARCHAR2(10) NOT NULL,
    bairro      VARCHAR2(50) NOT NULL,
    cod_cidade  VARCHAR2(7) NOT NULL,
    data_admiss DATE NOT NULL,
    date_demiss DATE,
    data_nasc   DATE NOT NULL,
    telefone    VARCHAR2(15) NOT NULL,
    cod_cargo   INT NOT NULL,
    CONSTRAINT fk_func1
        FOREIGN KEY ( cod_empresa,
                      cod_cc )
            REFERENCES centro_custo ( cod_empresa,
                                      cod_cc ),
    CONSTRAINT fk_func2 FOREIGN KEY ( cod_cidade )
        REFERENCES cidades ( cod_cidade ),
    CONSTRAINT fk_func3
        FOREIGN KEY ( cod_empresa,
                      cod_cargo )
            REFERENCES cargos ( cod_empresa,
                                cod_cargo ),
    CONSTRAINT pk_func1 PRIMARY KEY ( cod_empresa,
                                      matricula )
);

-- TABELA DE PARAMETROS DE MATRICULA POR EMPRESA
CREATE TABLE param_matricula (
    cod_empresa INT NOT NULL PRIMARY KEY,
    matricula   INT NOT NULL,
    CONSTRAINT fk_pmat1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--TABELA SALARIO
CREATE TABLE salario (
    cod_empresa INT NOT NULL,
    matricula   INT NOT NULL,
    salario     DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_sal1
        FOREIGN KEY ( cod_empresa,
                      matricula )
            REFERENCES funcionario ( cod_empresa,
                                     matricula ),
    CONSTRAINT pk_sal1 PRIMARY KEY ( cod_empresa,
                                     matricula )
);

--TABELA FOLHA DE PAGTO
CREATE TABLE folha_pagto (
    cod_empresa INT NOT NULL,
    matricula   INT NOT NULL,
    tipo_pgto   CHAR(1) NOT NULL,-- (M-FOLHA,A-ADTO,F-FERIAS,D-13�,R-RESC),
    tipo        CHAR(1) NOT NULL,--P=PROVENTOS D-DESCONTO
    evento      VARCHAR2(30) NOT NULL,
    mes_ref     VARCHAR2(2) NOT NULL,
    ano_ref     VARCHAR2(4) NOT NULL,
    data_pagto  DATE NOT NULL,
    valor       DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_fp1
        FOREIGN KEY ( cod_empresa,
                      matricula )
            REFERENCES funcionario ( cod_empresa,
                                     matricula )
);

-- CRIA INDEX PARA OTIMARIZAR CONSULTAS
CREATE INDEX ix1_fpag ON
    folha_pagto (
        cod_empresa,
        mes_ref,
        ano_ref
    );

--========================================================
--SEGURANÇA
--========================================================

--TABELA USARIOS 
CREATE TABLE usuarios (
    cod_empresa INT NOT NULL,
    login       VARCHAR2(30) NOT NULL,
    matricula   INT NOT NULL,
    senha       VARCHAR2(32) NOT NULL,
    situacao    CHAR(1) NOT NULL, --A=ATIVO -B BLOQUEADO
    CONSTRAINT fk_us1
        FOREIGN KEY ( cod_empresa,
                      matricula )
            REFERENCES funcionario ( cod_empresa,
                                     matricula ),
    CONSTRAINT pk_user PRIMARY KEY ( cod_empresa,
                                     matricula )
);

-- CRIA INDEX UNIQUE PARA LOGIN
CREATE UNIQUE INDEX ix1_user ON
    usuarios (
        login
    );

--========================================================
--FINANCEIRO
--========================================================

--TABELA CONTAS A RECEBER
CREATE TABLE contas_receber (
    cod_empresa INT NOT NULL,
    id_doc      INT NOT NULL PRIMARY KEY,
    id_cliente  INT NOT NULL,
    id_doc_orig INT NOT NULL, --ALTER CAMPO ID_DOC_ORIG PARA FK TABELA NOTA_FISCAL
    parc        INT NOT NULL,
    data_venc   DATE NOT NULL,
    data_pagto  DATE,
    valor       DECIMAL(10, 2),
    CONSTRAINT fk_cr1 FOREIGN KEY ( id_cliente )
        REFERENCES clientes ( id_cliente ),
    CONSTRAINT fk_cr2 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

-- CRIA SEQUENCIA PARA TABELA CONTAS_RECEBER
CREATE SEQUENCE seq_cre START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA CONTAS A PAGAR
CREATE TABLE contas_pagar (
    cod_empresa INT NOT NULL,
    id_doc      INT NOT NULL PRIMARY KEY,
    id_for      INT NOT NULL,
    id_doc_orig INT NOT NULL, --ALTER CAMPO ID_DOC_ORIG PARA FK TABELA NOTA_FISCAL
    parc        INT NOT NULL,
    data_venc   DATE NOT NULL,
    data_pagto  DATE,
    valor       DECIMAL(10, 2),
    CONSTRAINT fk_cp1 FOREIGN KEY ( id_for )
        REFERENCES fornecedores ( id_for ),
    CONSTRAINT fk_cp2 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

-- CRIA SEQUENCIA PARA TABELA CONTAS_PAGAR
CREATE SEQUENCE seq_cap START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA CONDIÇÕES DE PAGTO
CREATE TABLE cond_pagto (
    cod_pagto INT NOT NULL PRIMARY KEY,
    nome_cp   VARCHAR2(50) NOT NULL
);

-- CRIA SEQUENCIA PARA TABELA COND_PAGTO
CREATE SEQUENCE seq_pagto START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA DE CONDICAO DE PAGTO COM PARCELA
CREATE TABLE cond_pagto_det (
    cod_pagto INT NOT NULL,
    parc      INT NOT NULL,
    dias      INT NOT NULL,
    pct       DECIMAL(10, 2) NOT NULL,--PERCENTUAL DA PARCELA
    CONSTRAINT fk_condp1 FOREIGN KEY ( cod_pagto )
        REFERENCES cond_pagto ( cod_pagto )
);

--========================================================
--COMERCIAL
--========================================================

--TABELA PEDIDO DE VENDAS
CREATE TABLE ped_vendas (
    cod_empresa  INT NOT NULL,
    num_pedido   INT NOT NULL,
    id_cliente   INT NOT NULL,
    cod_pagto    INT NOT NULL,
    data_pedido  DATE NOT NULL,
    data_entrega DATE NOT NULL,
    situacao     NCHAR(1) NOT NULL, --A-ABERTO P-PLANEJADO -F FINALIZADO
    total_ped    DECIMAL(10, 2),
    CONSTRAINT fk_pv1 FOREIGN KEY ( id_cliente )
        REFERENCES clientes ( id_cliente ),
    CONSTRAINT fk_pv2 FOREIGN KEY ( cod_pagto )
        REFERENCES cond_pagto ( cod_pagto ),
    CONSTRAINT fk_pv3 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa ),
    CONSTRAINT pk_pv1 PRIMARY KEY ( cod_empresa,
                                    num_pedido )
);

--TABELA DE PARAMETROS DE NUMEROS DE PEDIDO DE VENDAS POR EMPRESA
CREATE TABLE param_ped_vendas (
    cod_empresa INT NOT NULL PRIMARY KEY,
    num_ped     INT NOT NULL,
    CONSTRAINT fk_pv FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--TABELA PEDIDO VENDAS ITENS
CREATE TABLE ped_vendas_itens (
    cod_empresa INT NOT NULL,
    num_pedido  INT NOT NULL,
    seq_mat     INT NOT NULL,
    cod_mat     INT NOT NULL,
    qtd         INT NOT NULL,
    val_unit    DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_pvit1
        FOREIGN KEY ( cod_empresa,
                      num_pedido )
            REFERENCES ped_vendas ( cod_empresa,
                                    num_pedido ),
    CONSTRAINT fk_pvit2
        FOREIGN KEY ( cod_empresa,
                      cod_mat )
            REFERENCES material ( cod_empresa,
                                  cod_mat )
);

--TABELA VENDEDORES
CREATE TABLE vendedores (
    cod_empresa INT NOT NULL,
    id_vend     INT NOT NULL,
    matricula   INT NOT NULL,
    CONSTRAINT fk_vend1
        FOREIGN KEY ( cod_empresa,
                      matricula )
            REFERENCES funcionario ( cod_empresa,
                                     matricula ),
    CONSTRAINT pk_vend1 PRIMARY KEY ( cod_empresa,
                                      matricula )
);

-- CRIA SEQUENCIA PARA COD DO VENDEDOR
CREATE SEQUENCE seq_vendedores START WITH 1 INCREMENT BY 1 NOMAXVALUE;
    
--TABELA GERENTES DE VENDAS
CREATE TABLE gerentes (
    cod_empresa INT NOT NULL,
    id_ger      INT NOT NULL,
    matricula   INT NOT NULL,
    CONSTRAINT fk_ger1
        FOREIGN KEY ( cod_empresa,
                      matricula )
            REFERENCES funcionario ( cod_empresa,
                                     matricula ),
    CONSTRAINT pk_ger1 PRIMARY KEY ( cod_empresa,
                                     matricula )
);

-- CRIA SEQUENCIA PARA COD DO VENDEDOR
CREATE SEQUENCE seq_gerentes START WITH 1 INCREMENT BY 1 NOMAXVALUE;

--TABELA COMPOSTA DE CANAL DE VENDAS RELACIONADA GERENTE COM VENDEDOR
CREATE TABLE canal_vendas_g_v (
    cod_empresa INT NOT NULL,
    id_ger      INT NOT NULL,
    id_vend     INT NOT NULL,
    CONSTRAINT fk_cgv3 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--TABELA COMPOSTA DE CANAL DE VENDAS RELACIONA VENDEDOR COM CLIENTE
CREATE TABLE canal_vendas_v_c (
    cod_empresa INT NOT NULL,
    id_vend     INT NOT NULL,
    id_cliente  INT NOT NULL,
    CONSTRAINT fk_cvc2 FOREIGN KEY ( id_cliente )
        REFERENCES clientes ( id_cliente ),
    CONSTRAINT fk_ccv1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--TABELA PARA REGISTRA META DE VENDAS MES A MES/ANO
CREATE TABLE meta_vendas (
    cod_empresa INT NOT NULL,
    id_vend     INT NOT NULL,
    ano         VARCHAR2(4) NOT NULL,
    mes         VARCHAR2(2) NOT NULL,
    valor       DECIMAL(10, 2),
    CONSTRAINT fk_mv1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--========================================================
--FISCAL
--========================================================

--TABELA DOS CODIGO DE OPERACOES FISCAIS
CREATE TABLE cfop (
    cod_cfop  VARCHAR2(5) NOT NULL PRIMARY KEY,
    desc_cfop VARCHAR2(255) NOT NULL
);

--TABELA NOTA_FISCAL
CREATE TABLE nota_fiscal (
    cod_empresa   INT NOT NULL,
    num_nf        INT NOT NULL,
    tip_nf        CHAR(1) NOT NULL, --E ENTRADA, S- SAIDA
    cod_cfop      VARCHAR2(5) NOT NULL,
    id_clifor     INT NOT NULL,
    cod_pagto     INT NOT NULL,
    data_emissao  DATE NOT NULL,
    data_entrega  DATE NOT NULL,
    total_nf      DECIMAL(10, 2),
    integrada_fin CHAR(1) DEFAULT ( 'N' ),
    integrada_sup CHAR(1) DEFAULT ( 'N' ),
    CONSTRAINT fk_nf1 FOREIGN KEY ( cod_cfop )
        REFERENCES cfop ( cod_cfop ),
    CONSTRAINT fk_nf2 FOREIGN KEY ( cod_pagto )
        REFERENCES cond_pagto ( cod_pagto ),
    CONSTRAINT pk_nf1 PRIMARY KEY ( cod_empresa,
                                    num_nf )
);

--TABELA NOTA_FISCAL_ITENS
CREATE TABLE nota_fiscal_itens (
    cod_empresa INT NOT NULL,
    num_nf      INT NOT NULL,
    seq_mat     INT NOT NULL,
    cod_mat     INT NOT NULL,
    qtd         INT NOT NULL,
    val_unit    DECIMAL(10, 2) NOT NULL,
    ped_orig    INT NOT NULL,
    CONSTRAINT fk_nfit1
        FOREIGN KEY ( cod_empresa,
                      num_nf )
            REFERENCES nota_fiscal ( cod_empresa,
                                     num_nf ),
    CONSTRAINT fk_nfit2
        FOREIGN KEY ( cod_empresa,
                      cod_mat )
            REFERENCES material ( cod_empresa,
                                  cod_mat )
);

--TABELA PARAMETRO NUMERACAO NFE
CREATE TABLE param_nfe (
    cod_empresa INT NOT NULL PRIMARY KEY,
    num_nfe     INT NOT NULL,
    CONSTRAINT fk_nfe1 FOREIGN KEY ( cod_empresa )
        REFERENCES empresa ( cod_empresa )
);

--TABELA PARAMETRO DE INSS
CREATE TABLE param_inss (
    vigencia_ini DATE,
    vigencia_fim DATE,
    valor_de     DECIMAL(10, 2) NOT NULL,
    valor_ate    DECIMAL(10, 2) NOT NULL,
    pct          DECIMAL(10, 2) NOT NULL
);

--TABELA DE PARAMETRO DO IRRF
CREATE TABLE param_irrf (
    vigencia_ini DATE,
    vigencia_fim DATE,
    valor_de     DECIMAL(10, 2) NOT NULL,
    valor_ate    DECIMAL(10, 2) NOT NULL,
    pct          DECIMAL(10, 2) NOT NULL,
    val_isent    DECIMAL(10, 2)
);

 --TABELA AUDIT SALARIO
CREATE TABLE auditoria_salario (
    cod_empresa      INT NOT NULL,
    matricula        INT NOT NULL,
    sal_antes        DECIMAL(10, 2) NOT NULL,
    sal_depois       DECIMAL(10, 2) NOT NULL,
    usuario          VARCHAR2(20) NOT NULL,
    data_atualizacao DATE NOT NULL,
    CONSTRAINT fk_audit1
        FOREIGN KEY ( cod_empresa,
                      matricula )
            REFERENCES funcionario ( cod_empresa,
                                     matricula )
);

--========================================================
--ALTERAÇÕES E TESTES
--========================================================

--ADD CAMPO LOGIN TABELA APONTAMENTOS CRIACAO APOS TABELA USUARIOS E FK
ALTER TABLE apontamentos ADD login VARCHAR2(30) NOT NULL;

ALTER TABLE apontamentos ADD lote VARCHAR2(20) NOT NULL;
  
  --REMOVENDO CONSTRAINT PARA TESTE
ALTER TABLE consumo DROP CONSTRAINT fk_cons2;
  --ALTER TABLE APONTAMENTOS DROP CONSTRAINT  FK_APONT3

--ADD CAMPO LOGIN TABELA ESTOQUE_MOV  CRIACAO APOS TABELA USUARIO
ALTER TABLE estoque_mov ADD login VARCHAR2(30) NOT NULL;
  
 
--ALTERAR  COD_PAGTO TAB PED_COMPRAS PARA FOREIGN KEY APOS TABELA COND_PAGTO
ALTER TABLE ped_compras
    ADD FOREIGN KEY ( cod_pagto )
        REFERENCES cond_pagto ( cod_pagto );