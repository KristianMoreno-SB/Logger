drop package loggerr
/

drop procedure loggerr_configure
/

drop table loggerr_logs_apex_items cascade constraints
/

drop table loggerr_prefs cascade constraints
/

drop table loggerr_logs cascade constraints
/

drop table loggerr_prefs_by_client_id cascade constraints
/

drop sequence loggerr_logs_seq
/

drop sequence loggerr_apx_items_seq
/


begin
	dbms_scheduler.drop_job('LOGGERR_PURGE_JOB');
end;
/

begin
	dbms_scheduler.drop_job('LOGGERR_UNSET_PREFS_BY_CLIENT');
end;
/

drop view loggerr_logs_5_min
/

drop view loggerr_logs_60_min
/

drop view loggerr_logs_terse
/

