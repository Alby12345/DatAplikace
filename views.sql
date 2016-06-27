--------------------------------------------------------------------------------
                                 -- Views --
--------------------------------------------------------------------------------
-- Joined table with accounts for customers
create or replace view VIEW_Cust_Accs as
  select *from Customer natural join UsrsAccs;
--------------------------------------------------------------------------------

-- full data version of CustomersAccs view
create or replace view VIEW_Cust_Accs_Full as
  select *from Customer natural join UsrsAccs natural join account;
-- test
--select * from VIEW_Cust_Accs_Full;
--------------------------------------------------------------------------------
--Customers who has more accounts registered
create or replace view VIEW_Cust_With_More_Accs as
  select IdCust from UsrsAccs group by IdCust having count(*) > 1;

select * from VIEW_Cust_With_More_Accs;
--------------------------------------------------------------------------------
-- view used to view Accounts with more than one user;
create or replace view VIEW_Accs_With_More_Cust as
  select IdAcc from UsrsAccs group by IdAcc having count(*) > 1;

select * from VIEW_ACCS_WITH_MORE_CUST;
--------------------------------------------------------------------------------
create or replace view VIEW_Today_As_ExpirateDate as
  select to_char(to_char(SYSDATE, 'MM')* 100 +
                mod(to_char(SYSDATE, 'YYYY'),100),'0000') exp from dual;
select * from VIEW_TODAY_AS_EXPIRATEDATE;
--------------------------------------------------------------------------------
-- select only accounts which have just one owner
create or replace view VIEW_Accs_With_Single_Customer as
   select IdAcc, IdCust from 
      (select IdAcc from usrsAccs group by idAcc having count(*) = 1)
       natural join usrsAccs;
--------------------------------------------------------------------------------
--view all canceled cards not yet expired
--create or replace view VIEW_All_Canceled_Cards_Not_Expired as
--  select IdAcc from Card where Expiration
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
select 'drop view ' || view_name || ';' from user_views;
select 'drop trigger ' || trigger_name || ';' from user_triggers;
