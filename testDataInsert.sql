insert into 
  Customer(FirstName,
           LastName,
           BirthDate,
           Email,
           Phone)
  values(
  'Ladislav',
  'Malecek',
  '25.may.1993',
  'malecek.ladislav@gmail.com',
  '+420737123456'
);
  
insert into 
  Customer(FirstName,
           LastName,
           BirthDate,
           Email,
           Phone)
  values(
  'Eva',
  'Rudneva',
  '31.oct.1995',
  'eva.rudneva@gmail.com',
  '+420737555555'
);
  
insert into 
  Customer(FirstName,
           LastName,
           BirthDate,
           Email,
           Phone)
  values(
  'Jo',
  'TheDog',
  '1.mar.2014',
  'jo.thedog@gmail.com',
  '+420666666666'
);
  
insert into 
  Customer(FirstName,
           LastName,
           BirthDate,
           Email,
           Phone)
  values(
  'Jon',
  'Snow',
  '1.jan.2000',
  'jon@stark.got',
  '+420333333333'
);

insert into
  Account(IdAcc,
  Currency)
  values(1,
         'CZK');
  
insert into
  Account(IdAcc,
  Currency)
  values(2,
         'EUR');
         
insert into
  Account(IdAcc,
  Currency)
  values(3,
         'CZK');
insert into
  Account(IdAcc,
  Currency)
  values(4,
         'CZK');
         
insert into
  Account(IdAcc,
  Currency)
  values(5,
         'CZK');
         
insert into
  Account(IdAcc,
  Currency)
  values(6,
         'CZK');        
         
         
insert into
  Card(IdAcc)
  values(1);
insert into
  Card(IdAcc)
  values(1);
insert into
  Card(IdAcc)
  values(2);
insert into
  Card(IdAcc)
  values(3);
insert into
  Card(IdAcc)
  values(4);
insert into
  Card(IdAcc)
  values(5);
insert into
  Card(IdAcc)
  values(5);

insert into
  UsrsAccs(IdCust,IdAcc)
  values(1,1);
insert into
  UsrsAccs(IdCust,IdAcc)
  values(1,2);
insert into
  UsrsAccs(IdCust,IdAcc)
  values(1,6);
insert into
  UsrsAccs(IdCust,IdAcc)
  values(2,3);
insert into
  UsrsAccs(IdCust,IdAcc)
  values(3,4);
insert into
  UsrsAccs(IdCust,IdAcc)
  values(4,5);
insert into
  UsrsAccs(IdCust,IdAcc)
  values(4,4);
  insert into
  UsrsAccs(IdCust,IdAcc)
  values(2,1);
  insert into
  UsrsAccs(IdCust,IdAcc)
  values(3,1);
  
insert into
  Transaction(IdTrans, amount, accfrom, accto, created)
  values (10, 10,2000000000, 2000000001, sysdate);
  
delete from Account;
delete from card;
delete from customer;

delete from Customer where FirstName = 'Ladislav';

select * from Account;
select * from card;
select * from Customer;
select * from usrsaccs;
select * from Transaction;

select IdAcc, TO_CHAR(created, 'DD-MON-YYYY HH24:MI:SS') from account;

select to_char(to_char(SYSDATE, 'MM')* 100 +
                mod(to_char(SYSDATE, 'YYYY'),100),'0000')from dual;


select to_char(to_char(SYSDATE, 'MM')* 100 +
                mod(to_char(SYSDATE, 'YYYY'),100),'0000') from dual;


update account set balance=500000 where idacc=2;
delete from account where idacc=1;
RAISE_APPICATION_ERROR(-20001, 'Account that has non zero balance can not be removed.');


select IdCust, FirstName, LASTNAME, EMAIL from CUSTOMER;


