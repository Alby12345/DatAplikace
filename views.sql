--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
                                 -- Views --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Joined table with accounts id for customers
create or replace view VIEW_Cust_Accs as
  select * from Customer
    natural join CustAccs
    ;
  
--------------------------------------------------------------------------------
-- Joined table with customers id for accounts
create or replace view VIEW_Acc_Custs as
  select * from Account
    natural join CustAccs
    ;
  
--------------------------------------------------------------------------------
-- full data version of CustomersAccs view
create or replace view VIEW_Cust_Accs_Full as
  select * from Customer
    natural join CustAccs
    natural join account
    ;

-- test
-- select * from VIEW_Cust_Accs_Full;

--------------------------------------------------------------------------------
-- Customers who has more accounts registered
create or replace view VIEW_Cust_With_More_Accs as
  select IdCust from CustAccs
    group by IdCust
    having count(*) > 1
    ;

-- select * from VIEW_Cust_With_More_Accs;

--------------------------------------------------------------------------------
-- view used to view Accounts with more than one user;
create or replace view VIEW_Accs_With_More_Cust as
  select IdAcc from CustAccs
    group by IdAcc
    having count(*) > 1
    ;
    
-- test
-- select * from VIEW_ACCS_WITH_MORE_CUST;

--------------------------------------------------------------------------------
-- view to transform datum to expDate format
create or replace view VIEW_Today_As_ExpirateDate as
  select to_char(to_char(SYSDATE, 'MM')* 100 +
         mod(to_char(SYSDATE, 'YYYY'),100),'0000') exp
    from dual;

-- test
-- select * from VIEW_TODAY_AS_EXPIRATEDATE;

--------------------------------------------------------------------------------
-- select only accounts which have just one owner
create or replace view VIEW_Accs_With_Single_Customer as
   select IdAcc, IdCust from 
     (select IdAcc from CustAccs
        group by idAcc
        having count(*) = 1
        )
      natural join CustAccs;

--------------------------------------------------------------------------------
--view all canceled cards not yet expired
--create or replace view VIEW_All_Canceled_Cards_Not_Expired as
--  select IdAcc from Card where Expiration

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
                                 -- End Views --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------