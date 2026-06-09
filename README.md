# Projeto de Mini ERP - Oracle Database

Este projeto didático consiste na modelagem e implementação de um banco de dados relacional funcional para um sistema Mini ERP genérico, simulando operações reais como por exemplo vendas, estoque, produção e financeiro. O projeto conta com 42 tabelas estrategicamente relacionadas e automatizações em **PL/SQL** (Triggers, Procedures, Functions e Views).

## Modelo de Dados

O banco foi desenhado pensando em integridade referencial, automatização e performance. Abaixo está o Diagrama Entidade-Relacionamento (DER) do sistema:

![Diagrama do Banco de Dados](https://raw.githubusercontent.com/thaleswillreis/mini-erp-multifuncao-oracle/main/doc/Diagrama_tabelas.png)

### Divisão por Módulos e Tabelas
O ecossistema do Mini ERP é composto por tabelas integradas e distribuídas nos seguintes módulos funcionais:

1. `📂 Core & Cadastros Base:` Responsável pela estrutura organizacional, dados geográficos e cadastros mestres de entidades e insumos.

    **Tabelas:** empresa, uf, cidades, clientes, fornecedores, tipo_mat, material, mat_fornec.

2. `🏭 Planejamento e Controle da Produção (PCP):` Controla o chão de fábrica, desde o planejamento das Ordens de Produção (OP) até os apontamentos de consumo e rendimento.

    **Tabelas:** ordem_prod, apontamentos, ficha_tecnica, consumo.

3. `📦 Suprimentos & Almoxarifado:` Gerencia o estoque físico, saldos por lote, rastreabilidade de movimentações (Entradas/Saídas) e o fluxo de compras de suprimentos.

    **Tabelas:** estoque, estoque_lote, estoque_mov, ped_compras, param_ped_compras, ped_compras_itens.

4. `👥 Recursos Humanos (RH):` Estrutura o organograma da empresa através de centros de custo e cargos, além de gerenciar a folha de pagamento e histórico salarial.

    **Tabelas:** centro_custo, cargos, funcionario, param_matricula, salario, folha_pagto.

5. `💼 Comercial & Força de Vendas:` Mapeia a estrutura de vendas, vinculando gerentes e vendedores a carteiras de clientes, além de registrar metas e pedidos de venda.

    **Tabelas:** ped_vendas, param_ped_vendas, ped_vendas_itens, vendedores, gerentes, canal_vendas_g_v, canal_vendas_v_c, meta_vendas.

6. `💰 Financeiro:` Controla o fluxo de caixa do ERP através do gerenciamento das regras de condições de pagamento, parcelamentos, e títulos de Contas a Pagar e a Receber.

    **Tabelas:** contas_receber, contas_pagar, cond_pagto, cond_pagto_det.

7. `🧾 Fiscal & Segurança:` Controla a emissão de Notas Fiscais (Entrada/Saída) parametrizadas por CFOP, regras tributárias vigentes (INSS/IRRF), auditoria interna e acessos ao sistema.

    **Tabelas:** cfop, nota_fiscal, nota_fiscal_itens, param_nfe, param_inss, param_irrf, auditoria_salario, usuarios.


> [!NOTE] 
> O sistema possui tabelas nativas de rastreabilidade e auditoria (como auditoria_salario e relacionamentos tardios de login em apontamentos e estoque_mov), simulando boas práticas de compliance de dados e dando uma pequena amostra de como implementá-las.
---

## Como Executar

### Pré-requisitos
* **Docker** (caso o mecanismo de banco de dados precise ser executado em contêiner).
* **Oracle Database 19c ou superior** (pode ser utilizado o Oracle XE).
* **Cliente SQL compatível com PL/SQL** (**Ex:** SQL Developer, DBeaver, DataGrip, Extensão Oracle para VSCode, etc).

### Usando o Docker
1. Salve um código semelhante ao descrito abaixo em um arquivo chamado `'docker-compose.yml'`.

>  [!WARNING]
>O parâmetro **'volumes'** deve ser modificado para refletir o endereço local onde o volume do contêiner que persistirá os dados da base de dados Oracle ficará. Para saber mais sobre Volumes Docker consulte a [documentação oficial do Docker](https://docs.docker.com/).

> [!NOTE]
> No exemplo abaixo foi utilizado uma **'senha fraca'** no parâmetro **'ORACLE_PWD'** por se tratar de um perfil de desenvolvimento e de um projeto didático. É extremamente desencorajado o uso de **'senhas fracas'** e sem criptografia em projetos em produção.


Exemplo de script `'docker-compose.yml'` de um contêiner **Oracle XE** instanciado a partir do Container Registry oficial da Oracle.
```yaml
services:
  oracle-xe:
    image: container-registry.oracle.com/database/express:21.3.0-xe
    container_name: oracle-xe
    ports:
      - "1521:1521"
      - "5500:5500"
    environment:
      ORACLE_PWD: Oracle123
      ORACLE_CHARACTERSET: AL32UTF8
    volumes:
      - "/home/will/Documentos/Analise de Dados/ProjetosBD/oracle-db-test/oradata:/opt/oracle/oradata"
    shm_size: 1g
    restart: unless-stopped
```
2. Abra o terminal no diretório onde o script do Docker Compose foi salvo e execute-o para iniciar um contêiner do Oracle XE:

    ```bash
    $ docker compose up -d
    ```
3. Abra o cliente PL/SQL e crie uma nova conexão Oracle (**OBS:**  cada cliente PL/SQL tem seu próprio processo de conexão).

### Ordem de Execução dos Scripts
O deploy do banco de dados foi fragmentado em 23 scripts e organizados sequencialmente para garantir que as dependências (constraints, chaves estrangeiras e integrações) sejam respeitadas. Abaixo está a sequência em que os scripts foram criados. Nem todos os scripts tem dependência imediata em relação ao anterior, mas é aconselhável que sejam executados na ordem abaixo:

1. `01_criacao_table_space.sql` -> Criação de Tablespace e Usuário/Schema (**OBS:** Requer privilégios de **SYSDBA**).
2. `02_criacao_tabelas.sql` -> Criação da estrutura inicial de tabelas.
3. `03_triggers_seq_auto.sql` -> Criação e automatização das sequências dos index das tabelas.
4. `04_carga_dados_teste.sql` -> Carga de dados 'mock' para o perfil de desenvolvimento/testes (usados para testar o funcionamento da lógica e integração das tabelas).
5. `05_proc_copia_material.sql` -> Criação da procedure para facilitar a cópia de materiais entre duas empresas (**OBS:** O Mini ERP é multiempresas e pode operar mais de uma empresa ou filial simultaneamente).
6. `06_proc_plan_ordem_producao.sql` -> Criação da procedure para o planejamento de ordens de produção sob demanda.
7. `07_proc_gerar_pedido_compra.sql` -> Criação da procedure de geração de pedidos de compras.
8. `08_proc_estoque.sql` -> Criação da procedure de manipulação de estoque.
9. `09_proc_nota_fiscal.sql` -> Criação da procedure de geração de dados de notas fiscais.
10. `10_proc_integra_nf_estoque.sql` -> Criação da procedure de integração do sistema de notas fiscais com o estoque.
11. `11_proc_integr_fin.sql` -> Criação da procedure de integração do setor financeiro.
12. `12_proc_apontamento_producao.sql` -> Criação da procedure de geração dos apontamentos de produção.
13. `13_proc_folha.sql` -> Criação da procedure para manipulação dos dados de folha de pagamento (RH).
14. `14_triggers_bloq_usuario.sql` -> Criação do trigger de bloqueio de usuários inativados ou demitidos.
15. `15_triggers_audit_salario.sql` -> Criação do trigger de geração de dados de auditoria de alterações salariais.
16. `16_view_funcionario.sql` -> View de dados dos funcionários (RH).
17. `17_view_faturamento.sql` -> View de dados de faturamento (Financeiro).
18. `18_view_necessidades.sql` -> View de dados de materiais de produção (Produção).
19. `19_view_contas_pagar.sql` -> View de dados de contas a pagar (Financeiro).
20. `20_view_contas_receber.sql` -> View de dados de contas a receber (Financeiro).
21. `21_view_custo_detalhado.sql` -> View de dados detalhados de custo de produção (Produção).
22. `22_view_canais_vendas.sql` -> View de dados de vendas (Comercial).
23. `23_view_custo_resumido.sql` -> View de dados resumidos de custo de produção (Produção).


---

## Funcionalidades e Regras de Negócio Implementadas

O banco possui inteligência intrínseca para garantir a consistência dos dados:

* **Triggers:**
  * `TRG_AUDIT_SAL`: Grava dados de auditoria sempre que houver uma alteração na tabela de salários.
  * `TRG_BLOQUEIA_USUARIO`: Realiza o bloqueio automático de um usuário do sistema sempre que este for demitido.
* **Procedures:**
  * `PROC_APONTAMENTO`: Valida os dados, verifica as ordens de produção e se há estoque de material suficiente em cada lote para a produção. Executa a movimentação de estoque (executa PROC_MOV_ESTOQUE) e atualiza as ordens de produção de produtos.
  * `PROC_COPIA_MAT`: Valida os dados, realiza uma cópia de registros de materiais para outras empresas ou filiais (útil caso haja mais de uma empresa ou filial compartilhando o mesmo banco de dados).
  * `PROC_FOLHA`: Valida os dados do funcionário, calcula salário bruto, contribuição do INSS, IRRF e salário líquido por funcionário.
  * `PROC_GERA_NF`: Verifica se há pedidos de compra ou de venda, gera os dados de notas fiscais de entrada ou de saída.
  * `PROC_GER_PED_COMPRAS`: Verifica ordens de produção, fornecedores e estoque para gerar pedido do compras.
  * `PROC_INTEGR_FIN`: Verifica notas fiscais de entrada e saída e registros de vendas parceladas. Faz a integração das parcelas em Contas a Receber e das notas fiscais de compras a prazo em contas a pagar.
  * `PROC_INTEGR_NF_ESTOQUE`: Verifica se há novas notas fiscais de entrada ou saída de mercadoria para dar entrada ou saída em estoque (executa PROC_MOV_ESTOQUE).
  * `PROC_MOV_ESTOQUE`: Realiza uma verificação de cada lote de mercadoria no estoque, verifica a demanda da operação de movimentação de estoque requerida (entrada ou saída) e atualiza os dados de estoque.
  * `PROC_PLAN_ORDEM`: Verifica se há pedidos em aberto, realiza a abertura de uma nova ordem de produção e atualiza o status do pedido.
* **Functions:**
  * `MD5`: Utiliza o pacote DBMS_CRYPTO para criptografar as senhas de usuários.
---

## Tecnologias
* **RDBMS:** Oracle Database
* **Linguagem:** PL/SQL
* **Ambiente de Desenvolvimento:** Docker, DBeaver e Oracle SQL Developer

## Links relacionados:

* [Docker](https://www.docker.com/)
* [DBeaver](https://dbeaver.io/)
* [Oracle XE](https://www.oracle.com/database/technologies/appdev/xe.html)

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](https://github.com/thaleswillreis/mini-erp-multifuncao-oracle/blob/main/LICENCA_PT-BR.md) para mais detalhes.