-- --------------------------------------------------------------------------------
-- BD/SWD-DOE4        BIA1SI   Andreas Binder                            2025-06-02
-- --------------------------------------------------------------------------------
--
--  Small Test script on flashback query time
--
-- -------------------------------------------------------------------------------- 

declare
TYPE TTABS IS TABLE OF VARCHAR2(128 char); NTABS TTABS := TTABS( 'ACT_ID_TOKEN'
                                                                ,'ACT_RU_EXECUTION'
                                                                ,'DATABASECHANGELOG'
                                                                ,'EXT_GOODS_ISSUES'
                                                                ,'EXT_INVOICES'
                                                                ,'EXT_SALES_ORDER_ITEMS'
                                                                ,'FLW_EVENT_DEPLOYMENT'
                                                                ,'FLW_RU_BATCH'
                                                                ,'T_ASSIGNEES'
                                                                ,'T_WORK_CONFIG'
                                                                 );
x        number;
ec       number;
lvn_cnt  number := 0;
lvb_ok   boolean;

em varchar2(128 char);
begin



   for t in ntabs.first .. ntabs.last loop
     ec := 0;
     em := null;
     lvb_ok := true;

     for h in 1 .. 24 loop

     if lvb_ok then

       begin
         x := 1/24 * h;
         execute immediate 'select count(*) from ' ||  ntabs(t) || ' as of timestamp sysdate - ' || x into lvn_cnt;
        exception
          when others then
            ec:=sqlcode;
            em:=sqlerrm;
            lvn_cnt := 0;
            lvb_ok := false;
       end;

       dbms_output.put_line(  rpad(ntabs(t), 30, ' ') ||  'sysdate - ' || to_char(h, '90') || ' hours'   ||
                            ' Count: ' || to_char(lvn_cnt, '99G999G990') || '  Error: ' || ec || ' Errm: ' || em) ;

       if ec != 0 then
         exit ;
       end if;
    end if;

   end loop;
   dbms_output.new_line;
  end loop;

end;
