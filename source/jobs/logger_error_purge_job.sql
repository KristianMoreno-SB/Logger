declare
  l_count pls_integer;
  l_job_name user_scheduler_jobs.job_name%type := 'LOGGER_ERROR_PURGE_JOB';
begin
  
  select count(1)
  into l_count
  from user_scheduler_jobs
  where job_name = l_job_name;
  
  if l_count = 0 then
    dbms_scheduler.create_job(
       job_name => l_job_name,
       job_type => 'PLSQL_BLOCK',
       job_action => 'begin logger_error.purge; end; ',
       start_date => systimestamp,
       repeat_interval => 'FREQ=DAILY; BYHOUR=1',
       enabled => TRUE,
       comments => 'Purges LOGGER_ERROR_LOGS utilizando valores por defecto definidos en logger_error_prefs.');
  end if;
end;
/