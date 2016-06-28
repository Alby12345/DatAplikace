--delete from Account;
--delete from card;
--delete from customer;
--
--delete from Customer where FirstName = 'Ladislav';
--
--select * from Account;
--select * from card;
--select * from Customer;
--select * from CustAccs;
--select * from Transaction;
--
--select IdAcc, TO_CHAR(created, 'DD-MON-YYYY HH24:MI:SS') from account;
--
--select to_char(to_char(SYSDATE, 'MM')* 100 +
--                mod(to_char(SYSDATE, 'YYYY'),100),'0000')from dual;
--
--
--select to_char(to_char(SYSDATE, 'MM')* 100 +
--                mod(to_char(SYSDATE, 'YYYY'),100),'0000') from dual;
--
--
--update account set balance=500000 where idacc=2;
--delete from CUSTOMER;
--RAISE_APPICATION_ERROR(-20001, 'Account that has non zero balance can not be removed.');
--
--
--select IdCust, FirstName, LASTNAME, EMAIL from CUSTOMER;
--

--------------------------------------------------------------------------------
                         -- Packages Testing Data --
--------------------------------------------------------------------------------


exec DBMS_OUTPUT.PUT_LINE('LIST OF CUSTOMERS:');
select * from Customer;

exec DBMS_OUTPUT.PUT_LINE('LIST OF ACCOUNTS:');
select * from Account;

exec DBMS_OUTPUT.PUT_LINE('LIST OF CUST ACCS JOIN:');
select * from VIEW_CUST_ACCS_FULL;

exec DBMS_OUTPUT.PUT_LINE('LIST OF CUST ACCS JOIN:');
select * from TRANSACTION;


--ADD NEW CUSTOMER
--params first, last, birthDate, email, phone
--error raise checking
exec DB_CUSTOMER.ADD_CUSTOMER('Klara', 'Maleckova', to_date('12.12.1994', 'DD.MM.YYYY'), 'maleckova.klara@gmail.com', '+42054987321');
exec DB_CUSTOMER.ADD_CUSTOMER('More', 'Snow', to_date('11.11.1960', 'DD.MM.YYYY'), 'snowgmail.com', '+420654117321');
--
select IdCust, IdAcc, FirstName, LastName, balance from VIEW_CUST_ACCS_FULL;

--SEARCH FOR CUSTOMER USING HIS LAST NAME
select DB_CUSTOMER.SEARCH_CUSTOMER(xLastName => 'Snow') from dual;
--


--Increase funds
exec DB_ACCOUNT.INC_FUNDS(3,5000);

--send_Money(xAccId xAmount xAccTo xBankTo default null,
--           xVarSymb default null, xConSymb default null,
--            xMessage default null
exec DB_TRANSACTION.SEND_MONEY(3, 200, 8832165421, 1231);

select AccNumber from account where idAcc = 6;

exec DB_TRANSACTION.SEND_MONEY(3, 531, 3408063989);

-- try to delete account without money
exec DB_ACCOUNT.DEL_ACCOUNT(1);
-- try to delete account with money
exec DB_ACCOUNT.DEL_ACCOUNT(2);

-- add first account back
select DB_ACCOUNT.ADD_ACCOUNT(1,'CZK', 'osobni ucet') from dual;

-- VIEW ACC WITH ACC BALANCE NON ZERO
select * from VIEW_CUST_ACCS_FULL where IdCust = 1;

--SHOW REMAINING BALANCE ACROSS ALL ACCOUNTS
select DB_CUSTOMER.GET_DISPOSABLE_FUNDS(1) from dual;

--DELETE CUSTOMER WITH ACC BALANCE NON ZERO
-- will fail
exec DB_CUSTOMER.DEL_CUSTOMER(1);


