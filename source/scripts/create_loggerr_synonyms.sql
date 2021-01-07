-- Creates synonyms from defined user for Logger objects


-- Parameters
define from_user = '&1' -- This is the user to reference Logger objects


whenever sqlerror exit sql.sqlcode

create or replace synonym loggerr for &from_user..loggerr;
create or replace synonym loggerr_logs for &from_user..loggerr_logs;
create or replace synonym loggerr_logs_apex_items for &from_user..loggerr_logs_apex_items;
create or replace synonym loggerr_prefs for &from_user..loggerr_prefs;
create or replace synonym loggerr_prefs_by_client_id for &from_user..loggerr_prefs_by_client_id;
create or replace synonym loggerr_logs_5_min for &from_user..loggerr_logs_5_min;
create or replace synonym loggerr_logs_60_min for &from_user..loggerr_logs_60_min;
create or replace synonym loggerr_logs_terse for &from_user..loggerr_logs_terse;
