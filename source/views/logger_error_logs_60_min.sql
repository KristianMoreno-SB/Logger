create or replace force view logger_error_logs_60_min as
	select * 
      from logger_error_logs 
	 where time_stamp > systimestamp - (1/24)
/
