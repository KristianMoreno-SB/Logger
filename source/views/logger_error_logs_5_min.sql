create or replace force view logger_error_logs_5_min as
	select * 
      from logger_error_logs 
	 where time_stamp > systimestamp - (5/1440)
/