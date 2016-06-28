insert into 
  Customer(IdCust,
           FirstName,
           LastName,
           BirthDate,
           Email,
           Phone)
  values(
  1,
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
  CustAccs(IdCust,IdAcc)
  values(1,1);
insert into
  CustAccs(IdCust,IdAcc)
  values(1,2);
insert into
  CustAccs(IdCust,IdAcc)
  values(1,6);
insert into
  CustAccs(IdCust,IdAcc)
  values(2,3);
insert into
  CustAccs(IdCust,IdAcc)
  values(3,4);
insert into
  CustAccs(IdCust,IdAcc)
  values(4,5);
insert into
  CustAccs(IdCust,IdAcc)
  values(4,4);
  insert into
  CustAccs(IdCust,IdAcc)
  values(2,1);
  insert into
  CustAccs(IdCust,IdAcc)
  values(3,1);
  
insert into
  Transaction(IdTrans, amount, accfrom, accto, created)
  values (10, 10,2000000000, 2000000001, sysdate);