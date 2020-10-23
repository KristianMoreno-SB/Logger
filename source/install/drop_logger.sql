drop package logger_error
/

drop procedure logger_error_configure
/

drop table logger_error_logs_apex_items cascade constraints
/

drop table logger_error_prefs cascade constraints
/

drop table logger_error_logs cascade constraints
/

drop table logger_error_prefs_by_client_id cascade constraints
/

drop sequence logger_error_logs_seq
/

drop sequence logger_error_apx_items_seq
/


begin
	dbms_scheduler.drop_job('LOGGER_PURGE_JOB');
end;
/

begin
	dbms_scheduler.drop_job('LOGGER_UNSET_PREFS_BY_CLIENT');
end;
/

drop view logger_logs_5_min
/

drop view logger_logs_60_min
/

drop view logger_logs_terse
/

