--------------------------------------------------------------------------------
                                 -- Packages --
--------------------------------------------------------------------------------

create or replace package db_Customer as

--type id_table is table of Customer.IdCust%type;

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
  
end;
/
--------------------------------------------------------------------------------
create or replace package body db_Customer as

-- Exception handling bound

EXC_pos_acc_no_delete exception;

pragma EXCEPTION_INIT (EXC_pos_acc_no_delete, -20002);


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
  select idCust, count(*) into ret, myCount
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
    select count(*) into ret from UsrsAccs where IdAcc = xCustId;
    return ret;
  end;
    
procedure del_Customer(
  xCustId Customer.IdCust%type
  ) as
  begin
    delete from Customer where IdCust = xCustId;
  exception
  when EXC_pos_acc_no_delete then
    RAISE_APPLICATION_ERROR (-20002, 'Customer could not be deleted, one or more owned accounts has positive balance');
  end;
  
end; -- package db_Customer
/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                         -- Packages Testing Data --
--------------------------------------------------------------------------------
-- add new Customer
--params first, last, birthDate, email, phone
exec DB_CUSTOMER.ADD_CUSTOMER('Klara', 'Maleckova', to_date('12.12.1993', 'DD.MM.YYYY'), 'maleckova.klara@gmail.com', '+420654987321');
select * from Customer;



