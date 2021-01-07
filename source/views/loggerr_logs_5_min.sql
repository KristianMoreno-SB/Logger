create or replace force view loggerr_logs_5_min as
	select * 
      from loggerr_logs 
	 where time_stamp > systimestamp - (5/1440)
/