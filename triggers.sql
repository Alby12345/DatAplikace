--Triggers 

--Used for generating id for Cust if not inserted
create or replace trigger bef_ins_Cust_Id
  before insert
  on Customer
  for each row
  begin
    if(:NEW.IdCust is null) then
      :NEW.IdCust := SEQ_Customer_Id.nextval;
    end if;
  end;
/

--Used for generating id for Card if not inserted
create or replace trigger bef_ins_Card_Id
  before insert
  on Card
  for each row
  begin
    if (:NEW.IdCard is null) then
      :NEW.IdCard := SEQ_Card_Id.nextval;
    end if;
  end;
/

--Used for generating id for new Account if not inserted
create or replace trigger bef_ins_Acc_Id
  before insert
  on Account
  for each row
  begin
    if (:NEW.IdAcc is null) then
      :NEW.IdAcc := SEQ_Account_Id.nextval;
    end if;
  end;
/

--Used for generating id for new Trans if not inserted
create or replace trigger bef_ins_Trans_Id
  before insert
  on Transaction
  for each row
  begin
    if (:NEW.IdTrans is null) then
      :NEW.IdTrans := SEQ_Transaction_Id.nextval;
    end if;
  end;
/


--Used for generating id for new Agreement if not inserted
create or replace trigger bef_ins_Agre_Id
  before insert
  on Agreement
  for each row
  begin
    if (:NEW.IdAgre is null) then
      :NEW.IdAgre := SEQ_Agreement_Id.nextval;
    end if;
  end;
/
  
--Trigger used to generate account number
create or replace trigger bef_ins_Account_AccNumber
  before insert
  on Account
  for each row
  declare
    randomNumber number(10);
    numberOfRows number;
  begin
    if(:NEW.AccNumber is null) then
      loop
        select dbms_random.value(1000000000,9999999999)
        into randomNumber
        from dual;

        select count(*)
        into numberOfRows
        from Account
        where AccNumber = randomNumber;
        
        -- if unique, assign and exitt loop
        if (numberOfRows = 0) then 
            :NEW.AccNumber := randomNumber;
            exit;
        end if;
      end loop;
    end if;
  end;
/

create or replace trigger bef_ins_Account_DateCreated
  before insert
  on Account
  for each row
  begin
    :NEW.Created := SYSDATE;
  end;
/

-- Trigger used for generating random card number if not inserted
create or replace trigger bef_ins_Card_NumberC
  before insert
  on Card
  for each row
  declare
    randomNumber number(16);
    numberOfRows number;
  begin
    
    if (:NEW.NumberC is null) then
      loop
        select round(dbms_random.value(1000000000000000, 9999999999999998))
        into randomNumber
        from dual;

        select count(*)
        into numberOfRows
        from Account
        where AccNumber = randomNumber;
        
        -- if unique, assign and exitt loop
        if (numberOfRows = 0) then 
            :NEW.NumberC := randomNumber;
            exit;
        end if;
      end loop;
    end if;
  end;
/

-- Trigger used for generating random card ccv if not inserted
create or replace trigger bef_ins_Card_CVV
  before insert
  on Card
  for each row
  begin
    if (:NEW.CVV is null) then 
      select dbms_random.value(0, 999)
      into :NEW.CVV
      from dual;
    end if;
  end;
/

-- Trigger used for generating expiration date if not inserted
create or replace trigger bef_ins_Card_Expiration
  before insert
  on Card
  for each row
  begin
    if (:NEW.Expiration is null) then
      select to_char(to_char(SYSDATE, 'MM')* 100 +
                mod(to_char(SYSDATE, 'YYYY'),100),'0000')
      into :NEW.Expiration
      from dual;
    end if;
  end;
/


