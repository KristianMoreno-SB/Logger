-- Post installation configuration tasks
PROMPT Calling logger_configure
begin
  logger_configure;
end;
/


-- Only set level if not in DEBUG mode
PROMPT Setting Logger Level
declare
  l_current_level logger_prefs.pref_value%type;
begin

  select pref_value
  into l_current_level
  from logger_prefs
  where 1=1
    and pref_type = logger_error.g_pref_type_logger
    and pref_name = 'LEVEL';

  -- Note: Probably not necessary but pre 1.4.0 code had this in place
  logger_error.set_level(l_current_level);
end;
/

prompt
prompt *************************************************
prompt Now executing LOGGER_ERROR.STATUS...
prompt

begin
	logger_error.status;
end;
/

prompt *************************************************
begin
	logger_error.log_permanent('Logger error version '||logger.get_pref('LOGGER_ERROR_VERSION')||' installed.');
end;
/
