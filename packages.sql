------------------------------------------------------------------------------
                                 -- Packages --
------------------------------------------------------------------------------

create or replace package db_Customer as

type id_table is table of Customer.IdCust%type;


procedure add_Customer(
  xFirstName Customer.FirstName%type,
  xLastName Customer.LastName%type,
  xBirthDate Customer.BirthDate%type,
  xEmail Customer.Email%type,
  xPhone Customer.Phone%type
);
  
function get_Customer_By_Email(
  xEmail Customer.Email%type
  ) return Customer.IdCust%type;
  
function get_Customer_By_Phone(
  xPhone Customer.Phone%type
  ) return Customer.IdCust%type;
  
function search_Customer(
  xFirstName Customer.FirstName%type default null,
  xLastName Customer.LastName%type default null,
  xBirthDate Customer.BirthDate%type default null
  ) return Customer.IdCust%type;
    
function get_Disposable_Funds(
  xCustId Customer.IdCust%type
  ) return Account.Balance%type;
    
function get_Account_Count(
  xCustId Customer.IdCust%type
  ) return Account.IdAcc%type;
    
procedure del_Customer(
 xCustId Customer.IdCust%type
);

procedure assign_Account(
  xCustId Customer.IdCust%type,
  xAccId Account.IdAcc%type
);
  
end;
/
--------------------------------------------------------------------------------
create or replace package body db_Customer as

-- Exception handling bound

EXC_pos_acc_no_delete exception;
EXC_unique_constraint_violated exception;
EXC_check_constraint_violated exception;

pragma EXCEPTION_INIT (EXC_pos_acc_no_delete, -20001);
pragma EXCEPTION_INIT (EXC_unique_constraint_violated, -00001);
pragma EXCEPTION_INIT (EXC_check_constraint_violated, -02290);



procedure add_Customer(
    xFirstName Customer.FirstName%type,
    xLastName Customer.LastName%type,
    xBirthDate Customer.BirthDate%type,
    xEmail Customer.Email%type,
    xPhone Customer.Phone%type
  ) as
  begin
    insert into 
    Customer(FirstName,
           LastName,
           BirthDate,
           Email,
           Phone)
      values(
        xFirstName,
        xLastName,
        xBirthDate,
        xEmail,
        xPhone
        );
  exception
    when EXC_unique_constraint_violated then
      RAISE_APPLICATION_ERROR(-20005, 'Customer must have unique email and phone number');
    when EXC_check_constraint_violated then
      RAISE_APPLICATION_ERROR(-20006, 'Email or phone does not satisfy needed format');
  end;
  
function get_Customer_By_Email(
  xEmail Customer.Email%type
  ) return Customer.IdCust%type
  as 
  ret Customer.IdCust%type;
  begin
    select IdCust into ret from Customer where Email = xEmail;
  end;
  
function get_Customer_By_Phone(
  xPhone Customer.Phone%type
  ) return Customer.IdCust%type
  as
  ret Customer.IdCust%type;
  begin
    select IdCust into ret from Customer where Phone = xPhone;
  end;
  
  
function search_Customer(
  xFirstName Customer.FirstName%type default null,
  xLastName Customer.LastName%type default null,
  xBirthDate Customer.BirthDate%type default null
  ) return Customer.IdCust%type
  as
  ret Customer.IdCust%type;
  myCount number(10);
  begin
  select min(idCust), count(*) into ret, myCount
  from customer
    where
    (firstName = xFirstName or xFirstName is null) and
    (lastName = xLastName or xLastName is null) and
    (birthDate = xBirthDate or xBirthDate is null);
  if( myCount > 1) then
    RAISE_APPLICATION_ERROR(-20004, 'Search query is not unique');
  end if;
  if( myCount = 0) then
    return null;
  end if;
  
  select idCust into ret
  from customer
    where
    (firstName = xFirstName or xFirstName is null) and
    (lastName = xLastName or xLastName is null) and
    (birthDate = xBirthDate or xBirthDate is null);
  return ret;
  end;
  

function get_Disposable_Funds(
  xCustId Customer.IdCust%type
  ) return Account.Balance%type
  as
  ret Account.Balance%type;
  begin
    select sum(balance) into ret from VIEW_Acc_Custs where IdCust = xCustId;
    return ret;
  end;
    
function get_Account_Count(
  xCustId Customer.IdCust%type
  ) return Account.IdAcc%type
  as
  ret Account.IdAcc%type;
  begin
    select count(*) into ret from CustAccs where IdAcc = xCustId;
    return ret;
  end;
    
procedure del_Customer(
  xCustId Customer.IdCust%type
  ) as
    accountPositiveCount number;
  begin
    -- check if customer does not onwn private account with funds on it
    select count(*) into accountPositiveCount from
      (select * from VIEW_Accs_With_Single_Customer where idCust = xCustId)
       natural join Account where balance <> 0;
    if (accountPositiveCount > 0) then
      RAISE_APPLICATION_ERROR(-20002, 'Customer could not be deleted, one or more owned accounts has positive balance');
    end if;
    delete from Account where IdAcc in 
      (select IdAcc
        from VIEW_Accs_With_Single_Customer
        where idCust = xCustId
        );
    delete from Customer where IdCust = xCustId;
  end;
  
procedure assign_Account(
  xCustId Customer.IdCust%type,
  xAccId Account.IdAcc%type
  ) as
  begin
    insert into
      CustAccs(IdCust, IdAcc)
      values(xCustId, xAccId); 
  exception
    when EXC_unique_constraint_violated then
      RAISE_APPLICATION_ERROR(-20005, 'Assign was already made');
    when EXC_check_constraint_violated then
      RAISE_APPLICATION_ERROR(-20006, 'Id does not satisfy constrains');
  end;
  
end; -- package db_Customer
/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

create or replace package db_Account as


function add_Account(
  xCustId Customer.IdCust%type,
  xCurrency Account.Currency%type default 'CZK',
  xName Account.Name%type default null)
  return Account.IdAcc%type;

procedure del_Account(
  xAccId Account.IdAcc%type
);

procedure inc_Funds(
  xAccId Account.IdAcc%type,
  xAmount Transaction.Amount%type
);

  
end;
/

create or replace package body db_Account as

-- Exception handling bound

EXC_pos_acc_no_delete exception;
EXC_unique_constraint_violated exception;
EXC_check_constraint_violated exception;

pragma EXCEPTION_INIT (EXC_pos_acc_no_delete, -20001);
pragma EXCEPTION_INIT (EXC_unique_constraint_violated, -00001);
pragma EXCEPTION_INIT (EXC_check_constraint_violated, -02290);

function add_Account(
  xCustId Customer.IdCust%type,
  xCurrency Account.Currency%type default 'CZK',
  xName Account.Name%type default null
  ) return Account.IdAcc%type
  as
    myAccountId number;
  begin
  myAccountId := SEQ_Account_Id.nextval;
  insert into Account(IdAcc, Currency, Name)
              values(myAccountId, xCurrency, xName);
  insert into CustAccs(IdCust, IdAcc)
              values(xCustId, myAccountId);
  return myAccountId;
  exception
    when EXC_unique_constraint_violated then
      RAISE_APPLICATION_ERROR(-20005, 'Account could not be created');
    when EXC_check_constraint_violated then
      RAISE_APPLICATION_ERROR(-20006, 'Currency was not recognised, check constraint');
  end;


procedure del_Account(
  xAccId Account.IdAcc%type
  ) as
  begin
    delete from Account where idAcc = xAccId;
  exception
    when EXC_pos_acc_no_delete then
    RAISE_APPLICATION_ERROR(-20001, 'Account that has non zero balance can not be removed.');
  end;

procedure inc_Funds(
  xAccId Account.IdAcc%type,
  xAmount Transaction.Amount%type
  ) as
  myCount number;
  begin
    select count(*) into myCount from Account where IdAcc = xAccId;
    -- acc with this id does not exist?
    if myCount <> 1 then
      RAISE_APPLICATION_ERROR(-20008, 'No such account found');
    end if;
    
    update Account
    set balance = balance + xAmount
    where IdAcc = xAccId;
  end;
end;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

create or replace package db_Transaction as


procedure send_Money(
  xAccId Account.IdAcc%type,
  xAmount Transaction.Amount%type,
  xAccTo Transaction.AccTo%type,
  xBankTo Transaction.BankTo%type default null,
  xVarSymb Transaction.VarSymb%type default null,
  xConSymb Transaction.ConSymb%type default null,
  xMessage Transaction.Message%type default null
);

--procedure send_Money_Card(
--  xCardId Card.IdCard%type,
--  xAccTo Transaction.AccTo%type,
--  xBankTo Transaction.BankTo%type default null
--);
--
--  
end;
/


create or replace package body db_Transaction as

-- Exception handling bound

EXC_pos_acc_no_delete exception;
EXC_unique_constraint_violated exception;
EXC_check_constraint_violated exception;

pragma EXCEPTION_INIT (EXC_pos_acc_no_delete, -20001);
pragma EXCEPTION_INIT (EXC_unique_constraint_violated, -00001);
pragma EXCEPTION_INIT (EXC_check_constraint_violated, -02290);

procedure send_Money(
  xAccId Account.IdAcc%type,
  xAmount Transaction.Amount%type,
  xAccTo Transaction.AccTo%type,
  xBankTo Transaction.BankTo%type default null,
  xVarSymb Transaction.VarSymb%type default null,
  xConSymb Transaction.ConSymb%type default null,
  xMessage Transaction.Message%type default null
  )as
   myCurrency Account.Currency%type;
   myAccFrom Transaction.AccFrom%type;
   myCount number;
   myIdAcc Account.IdAcc%type;
   myToCurrency Account.Currency%type;
   myFundsLeft Account.Balance%type;
   
   
  begin
    savepoint start_trans;
    
    select min(currency), count(*) into myCurrency, myCount from Account where IdAcc = xAccId;
    
    if myCount <> 1 then
      RAISE_APPLICATION_ERROR(-20008, 'No such account found');
    end if;
    
    
    update Account
    set Balance = Balance - xAmount
    where IdAcc = xAccId;
    
    select Balance into myFundsLeft from Account
    where IdAcc = xAccId;
    
    if(myFundsLeft  < 0) then
      RAISE_APPLICATION_ERROR(-20011, 'Not enough funds');
    end if;
  
    -- resolve to acc
    if xBankTo is null then
    -- check if account exists in my database and increase balance if same currency
      select min(idAcc), count(*), min(currency)
      into myIdAcc, myCount, myToCurrency
      from Account where AccNumber = xAccTo;
      if myCount != 1 then
        RAISE_APPLICATION_ERROR(-20009, 'Destination Acc does not exist');
      end if;
      
      if myCurrency <> myToCurrency then
        RAISE_APPLICATION_ERROR(-20010, 'Destination acc does not mach the currency');
      end if;
    -- increase amount on local acc now
    update Account
    set balance=balance + xAmount
    where IdAcc = myIdAcc;
    end if;
    
    select AccNumber into myAccFrom
    from Account
    where IdAcc = xAccId;
    
    
    insert into Transaction(Amount,
                            Currency,
                            AccTo,
                            BankTo,
                            AccFrom,
                            VarSymb,
                            ConSymb,
                            Message)
                     values(xAmount,
                            myCurrency,
                            xAccTo,
                            xBankTo,
                            myAccFrom,
                            xVarSymb,
                            xConSymb,
                            xMessage);                
  
  exception
    when EXC_check_constraint_violated then
      rollback to start_trans;
        RAISE_APPLICATION_ERROR(-20011, 'Not enough funds');
    when others then
      rollback to start_trans;
      raise;
  end;

--procedure send_Money_Card(
--  xCardId Card.IdCard%type,
--  xAccTo Transaction.AccTo%type,
--  xBankTo Transaction.BankTo%type default null
--  ) as
--    myCount number;
--    myAccId Account.IdAcc%type;
--  begin
--    select min(IdAcc), count(*) into myAccId, myCount
--    from Card where IdCard = xCardId;
--    if(myCount <> 1) then
--      RAISE_APPLICATION_ERROR(-20007, 'No such card exists');
--    end if;
--    exec db_Transaction.send_Money(myAccId, xAccTo, xBankTo);
--  end;

end;
/
