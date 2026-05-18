--=========================================================
--Tablespace do Perfil de Testes
--=========================================================
 
 -- criando tablespace para o perfil de TESTE
create tablespace erp_mult_tst
    datafile '/opt/oracle/oradata/XE/erp_mult_tst.dbf' 
    size 100m autoextend on next 50m maxsize 500m
    online
    permanent
    extent management local autoallocate
    segment space management auto;

-- criando um usuario para o perfil de TESTE
create user user_tst
    identified by 123456 --uso de senha fraca apenas para fins didáticos
    default tablespace erp_mult_tst
    temporary tablespace TEMP;

-- concendendo permissoes para o usuario 'user_tst'
grant ALL PRIVILEGES to user_tst;

-- configurando o limite de cota para o usuario 'user_tst'
alter user user_tst quota unlimited on erp_mult_tst;

--=========================================================
--Tablespace do Perfil de Produção
--=========================================================

 -- criando tablespace para o pelfil de PRODUÇÃO
 create tablespace erp_mult_prd
    datafile '/opt/oracle/oradata/XE\erp_mult_prd.dbf' 
    size 100m autoextend on next 50m maxsize 500m
    online
    permanent
    extent management local autoallocate
    segment space management auto;

-- criando usuario para o perfil de PRODUÇÃO
create user user_prd
    identified by 123456 --uso de senha fraca apenas para fins didáticos
    default tablespace erp_mult_prd
    temporary tablespace TEMP;

-- concendendo permissoes para o usuario 'user_prd'
grant ALL PRIVILEGES to user_prd;

-- alterando limite de cota para o usuario 'user_prd'
alter user user_prd quota unlimited on erp_mult_prd;
