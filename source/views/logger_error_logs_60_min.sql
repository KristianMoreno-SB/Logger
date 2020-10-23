create or replace force view loggerr_logs_60_min as
	select * 
      from loggerr_logs 
	 where time_stamp > systimestamp - (1/24)
/
