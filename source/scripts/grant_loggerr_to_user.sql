-- Grants privileges for logger objects from current user to a defined user


-- Parameters
define to_user = '&1' -- This is the user to grant the permissions to


whenever sqlerror exit sql.sqlcode

grant execute on loggerr to &to_user;
grant select, delete on loggerr_logs to &to_user;
grant select on loggerr_logs_apex_items to &to_user;
grant select, update on loggerr_prefs to &to_user;
grant select on loggerr_prefs_by_client_id to &to_user;
grant select on loggerr_logs_5_min to &to_user;
grant select on loggerr_logs_60_min to &to_user;
grant select on loggerr_logs_terse to &to_user;
