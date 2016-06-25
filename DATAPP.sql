--This database scripts resembles simplified version of banking system
--The main simplification is in amount of informations stored
--and thought complexity difference
--Basic entities are as follows:
--  Customer
--  Account
--  Transaction
--  Card
--Every customer can have unlimited amount of Acconts
--Each account has exactly one owner
--Account can have max 3 cards
--And each card must have exactly one owner account
-- TODO: thing throug transactions
--       Problem is outside operations
--               is dual ownership within bank operation
--       Solve it by giving the Transaction one owner, the one who
--       issued the transaction? Bank can be a CustomerLike entity?


--TODO: INDEXY, Zacit Trigry

-------------------------------------------
-- Tables and theirs indexes definitions --
-------------------------------------------

-- Table customer, evides all of banks customers
create table Customer(
  IdCust number(7) not null,
  FirstName varchar2(50) not null,
  LastName varchar2(50) not null,
  BirthDate date not null,
  City varchar2(50) not null,
  Street varchar2(50) not null,
  StreetNumber number(5) not null,
  Email varchar2(100) not null,
  Phone char(13) not null,
  --
  constraint Customer_PK
    primary key (IdCust),
  constraint Customer_U_Email
    unique (Email),
  constraint Customer_CHK_Email
    check (REGEXP_LIKE(Email, '[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,4}')),
  constraint Customer_CHK_Phone
    check (REGEXP_LIKE(Phone, '\+420[1-9][0-9]{8}'))  
);

-- Table card, which stores all emmited cards to customers
create table Card(
  IdCard number(10) not null, 
  NumberC number(16) not null,
  Expiration number(4) not null,
  CCV number(3) not null,
  CanceledB number(1) default 0,
  --
  constraint Card_PK
    primary key(IdCard),
  constraint Card_CHK_CanceledB
    check ( CanceledB >=0 AND CanceledB <=1 )
);

-- Table account, which stores all accounts
-- which are availible to theirs custommers
create table Account(
  IdAcc number(8) not null,
  AccNumber number(10) not null,
  Balance number(18,3) default 0,
  Currency char(3) not null,
  Created date not null,
  --
  constraint Account_PK
    primary key (IdAcc),
  constraint Account_U_AccNumber
    unique (AccNumber),
  constraint Account_CHK_Balance
    check ( Balance >= 0 ),
  constraint Account_CHK_Currency
    check ( Currency in ('CZK', 'EUR', 'USD'))
);

-- Transition Table for 1:N relation ship between Account and its Cards
create table AccsCards(
  IdAcc number(7) not null,
  IdCard number(10) not null,
  --
  constraint AccsCards_PK
    primary key(IdAcc, IdCard),
  constraint AccsCards_U_IdCard
    unique(IdCard),
  constraint AccsCards_FK_Account
    foreign key(IdAcc)
    references Account(IdAcc)
    on delete cascade,
  constraint AccsCards_FK_Card
    foreign key(IdCard)
    references Card(IdCard)
    on delete cascade
);
-- Transition table for 1:N relation ship between User ant its Accounts
create table UsrsAccs(
  IdCustomer number(7) not null,
  IdAccount number(8) not null,
  --
  constraint UsrsAccs_PK 
    primary key(IdCustomer, IdAccount),
  constraint UsrsAccs_U_IdAccount
    unique(IdAccount),
  constraint UsrsAccs_FK_Customer
    foreign key (IdCustomer)
    references Customer(IdCust)
    on delete cascade,
  constraint UsrsAccs_FK_Account
    foreign key (IdAccount)
    references Account(IdAcc)
    on delete cascade
);

-- Table storing all transactions which were issued
create table Transaction(
  IdTrans number(15) not null,
  Amount number(15) not null,
  AccTo number(10) not null,
  BankTo number(4),
  AccFrom number(10) not null,
  BankFrom number(4),
  VarSymb number(20),
  ConSymb number(20),
  Created date not null,
  Message varchar2(200),
  --
  constraint Transaction_PK
    primary key(IdTrans),
  constraint Transaction_CHK_Amount
    check ( Amount > 0 ),
  constraint Transaction_CHK_BankTo
    check ( BankTo > 0 ),
  constraint Transaction_CHK_BankFrom
    check ( BankFrom > 0 ),
  constraint Transaction_CHK_AccTo
    check ( AccTo > 0 ),
  constraint Transaction_CHK_AccFrom
    check ( AccFrom > 0 )
);

-- Table stroring Aggreements to Customers
create table Agreement(
  IdAgre number(15) not null,
  IdCust number(7) not null,
  Name varchar2(50) not null,
  Created date not null,
  FileId number(20) not null,
  --
  constraint Agreement_PK
    primary key(IdAgre),
  constraint Agreement_FK_Customer
    foreign key(IdCust)
    references Customer(IdCust),
  constraint Agreement_U_FileId
    unique(FileId),
  constraint Agreement_CHK_Created
    check ( Created <= now )
);
    
    


------------------------------------------------------
-- Deletion of tables and all surounding structures --
------------------------------------------------------


analyze table Agreement delete statistics; 
analyze table Transaction delete statistics;
analyze table UsrsAccs delete statistics;
analyze table AccsCards delete statistics;
analyze table Account delete statistics;
analyze table Card delete statistics;
analyze table Customer delete statistics;

drop table Agreement;
drop table Transaction;
drop table UsrsAccs;
drop table AccsCards;
drop table Account;
drop table Card;
drop table Customer;