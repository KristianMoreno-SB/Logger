create or replace package loggerr_test
as

  type rec_error is record(
    proc_name varchar2(30),
    error varchar2(4000));

  type tab_error is table of rec_error index by binary_integer;

  g_errors loggerr_test.tab_error;

  procedure util_run_tests;

end loggerr_test;
/
