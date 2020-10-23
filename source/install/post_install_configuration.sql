-- Post installation configuration tasks
PROMPT Calling loggerr_configure
begin
  loggerr_configure;
end;
/


-- Only set level if not in DEBUG mode
PROMPT Setting Loggerr Level
declare
  l_current_level loggerr_prefs.pref_value%type;
begin

  select pref_value
  into l_current_level
  from logger_prefs
  where 1=1
    and pref_type = loggerr.g_pref_type_logger
    and pref_name = 'LEVEL';

  -- Note: Probably not necessary but pre 1.4.0 code had this in place
  loggerr.set_level(l_current_level);
end;
/

prompt
prompt *************************************************
prompt Now executing LOGGERR.STATUS...
prompt

begin
	loggerr.status;
end;
/

prompt *************************************************
begin
	loggerr.log_permanent('Loggerr error version '||loggerr.get_pref('LOGGERR_VERSION')||' installed.');
end;
/
