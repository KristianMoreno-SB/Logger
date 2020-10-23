set sqlprompt ''
set feedback off
set linesize 200
set serverout on
set termout off

alter package loggerr compile body PLSQL_CCFLAGS='NO_OP:TRUE';

spool loggerr_no_op.pkb

prompt create or replace

begin
    dbms_preprocessor.print_post_processed_source (
       object_type    => 'PACKAGE BODY',
       schema_name    => USER,
       object_name    => 'LOGGERR');
end;
/

prompt /

spool off

alter package loggerr compile body PLSQL_CCFLAGS='NO_OP:FALSE';

exit
