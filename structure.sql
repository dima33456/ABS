CREATE DATABASE ABS IN maindbs WITH LOG;

CREATE TABLE Units (
  Numunit smallint NOT NULL CONSTRAINT Units_1,
  Name varchar(50) NOT NULL CONSTRAINT Units_2,
  BIC char(9) NOT NULL CONSTRAINT Units_3,
  Head boolean NOT NULL	CONSTRAINT Units_4
) lock mode row;

REVOKE ALL ON Units FROM PUBLIC;

CREATE UNIQUE INDEX Units_1 ON Units (Numunit) USING BTREE IN maindbs;

ALTER TABLE Units ADD CONSTRAINT PRIMARY KEY (Numunit) CONSTRAINT Units_p;

CREATE TABLE Clients (
  CLID serial NOT NULL CONSTRAINT Clients_1,
  Type varchar(10) NOT NULL CONSTRAINT Clients_2,
  Resident boolean NOT NULL CONSTRAINT Clients_3,
  Datecr date NOT NULL CONSTRAINT Clients_4,
  Employee boolean NOT NULL CONSTRAINT Clients_5
) lock mode row;

REVOKE ALL ON Clients FROM PUBLIC;

CREATE UNIQUE INDEX Clients_1 ON Clients (CLID) USING BTREE IN maindbs;

ALTER TABLE Clients ADD CONSTRAINT PRIMARY KEY (CLID) CONSTRAINT Clients_p;

ALTER TABLE Clients ADD CONSTRAINT CHECK (Type IN ('physical','legal','individual')) CONSTRAINT Clients_c1;

CREATE TABLE Physical (
  CLID int NOT NULL CONSTRAINT Physical_1,
  INN char(12) NOT NULL CONSTRAINT Physical_2,
  Lname	varchar(100) NOT NULL CONSTRAINT Physical_3,
  Fname	varchar(50) NOT NULL CONSTRAINT Physical_4,
  Mname	varchar(100) NOT NULL CONSTRAINT Physical_5,
  Dateborn date	NOT NULL CONSTRAINT Physical_6,
  Document bson NOT NULL CONSTRAINT Physical_7,
  Otherdoc bson,
  Contacts bson NOT NULL CONSTRAINT Physical_8,
  Address bson NOT NULL CONSTRAINT Physical_9
) lock mode row;

REVOKE ALL ON Physical FROM PUBLIC;

CREATE UNIQUE INDEX Physical_1 ON Physical (CLID) USING BTREE IN maindbs;

CREATE UNIQUE INDEX Physical_2 ON Physical (INN) USING BTREE IN maindbs;

ALTER TABLE Physical ADD CONSTRAINT PRIMARY KEY (CLID) CONSTRAINT Physical_p;

ALTER TABLE Physical ADD CONSTRAINT UNIQUE (INN) CONSTRAINT Physical_u1;

ALTER TABLE Physical ADD CONSTRAINT FOREIGN KEY (CLID) REFERENCES Clients (CLID) CONSTRAINT Physical_f1;

CREATE TABLE Legal (
  CLID int NOT NULL CONSTRAINT Legal_1,
  INN char(12) NOT NULL CONSTRAINT Legal_2,
  KPP char(9),
  Name varchar (50) NOT NULL CONSTRAINT Legal_3,
  Fullname varchar (100) NOT NULL CONSTRAINT Legal_4,
  Latname varchar (200)	NOT NULL CONSTRAINT Legal_5,
  Contacts bson NOT NULL CONSTRAINT Legal_6,
  Address bson NOT NULL CONSTRAINT Legal_7,
  Codes bson NOT NULL CONSTRAINT Legal_8
) lock mode row;

REVOKE ALL ON Legal FROM PUBLIC;

CREATE UNIQUE INDEX Legal_1 ON Legal (CLID) USING BTREE IN maindbs;

CREATE UNIQUE INDEX Legal_2 ON Legal (INN, KPP) USING BTREE IN maindbs;

ALTER TABLE Legal ADD CONSTRAINT PRIMARY KEY (CLID) CONSTRAINT Legal_p;

ALTER TABLE Legal ADD CONSTRAINT UNIQUE (INN, KPP) CONSTRAINT Legal_u1;

ALTER TABLE Legal ADD CONSTRAINT FOREIGN KEY (CLID) REFERENCES Clients (CLID) CONSTRAINT Legal_f1;



CREATE TABLE Operating_Date (
  Dateoper date NOT NULL CONSTRAINT Operatingdate_1,
  Status varchar(7) NOT NULL CONSTRAINT Operatingdate_2,
  Numunit smallint NOT NULL CONSTRAINT Operatingdate_3
) lock mode row;

REVOKE ALL ON Operating_Date FROM PUBLIC;

CREATE UNIQUE INDEX Operating_Date_1 ON Operating_Date (Dateoper, Numunit) USING BTREE IN maindbs;

CREATE INDEX Operating_Date_2 ON Operating_Date (Numunit) USING BTREE IN maindbs;

ALTER TABLE Operating_Date ADD CONSTRAINT PRIMARY KEY (Dateoper, Numunit) CONSTRAINT Operating_Date_p;

ALTER TABLE Operating_Date ADD CONSTRAINT CHECK (Status IN ('open','close','archive')) CONSTRAINT Operating_Date_c1;

ALTER TABLE Operating_Date ADD CONSTRAINT FOREIGN KEY (Numunit) REFERENCES Units (Numunit) CONSTRAINT Operating_Date_f1;

CREATE TABLE Currency (
  Currency char(3) NOT NULL CONSTRAINT Currency_1,
  Code char(4) NOT NULL CONSTRAINT Currency_2,
  Name varchar(20) NOT NULL CONSTRAINT Currency_3,
  Dateop date NOT NULL CONSTRAINT Currency_4,
  Datecl date NOT NULL CONSTRAINT Currency_5,
  National Boolean NOT NULL CONSTRAINT Currency_6
) lock mode row;

REVOKE ALL ON Currency FROM PUBLIC;

CREATE UNIQUE INDEX Currency_1 ON Currency (Currency) USING BTREE IN maindbs;

ALTER TABLE Currency ADD CONSTRAINT PRIMARY KEY (Currency) CONSTRAINT Currency_p;

CREATE TABLE Rate (
  Currency char(3) NOT NULL CONSTRAINT Rate_1,
  Dateoper date NOT NULL CONSTRAINT Rate_2,
  Rate decimal(22,8) NOT NULL CONSTRAINT Rate_3,
  Count smallint NOT NULL CONSTRAINT Rate_4
) lock mode row;

REVOKE ALL ON Rate FROM PUBLIC;

CREATE UNIQUE INDEX Rate_1 ON Rate (Currency, Dateoper) USING BTREE IN maindbs;

CREATE INDEX Rate_2 ON Rate (Currency) USING BTREE IN maindbs;

ALTER TABLE Rate ADD CONSTRAINT PRIMARY KEY (Currency, Dateoper) CONSTRAINT Rate_p;

ALTER TABLE Rate ADD CONSTRAINT FOREIGN KEY (Currency) REFERENCES Currency (Currency) CONSTRAINT Rate_f1;

CREATE TABLE Type_Document (
  Typedoc int NOT NULL CONSTRAINT Typedocument_1,
  Lifetime int NOT NULL	CONSTRAINT Typedocument_2,
  Createdoc Boolean NOT NULL CONSTRAINT Typedocument_3,
  Maindoc Boolean NOT NULL CONSTRAINT Typedocument_4,
  Name varchar(50,15) NOT NULL CONSTRAINT Typedocument_5,
  Sysname varchar(15) NOT NULL CONSTRAINT Typedocument_6,
  Widop	char(2)	NOT NULL CONSTRAINT Typedocument_7,
  Kassa Boolean NOT NULL CONSTRAINT Typedocument_8,
  Execute varchar(18) NOT NULL CONSTRAINT Typedocument_9,
  Unexecute varchar(18)	NOT NULL CONSTRAINT Typedocument_10
) lock mode row;

REVOKE ALL ON Type_Document FROM PUBLIC;

CREATE UNIQUE INDEX Type_Document_1 ON Type_Document (Typedoc) USING BTREE IN maindbs;

ALTER TABLE Type_Document ADD CONSTRAINT PRIMARY KEY (Typedoc) CONSTRAINT Type_Document_p;

CREATE TABLE Chapters (
  Chapter smallint NOT NULL CONSTRAINT Chapters_1,
  Name varchar(60) NOT NULL CONSTRAINT Chapters_2
) lock mode row;

REVOKE ALL ON Chapters FROM PUBLIC;

CREATE UNIQUE INDEX Chapters_1 ON Chapters (Chapter) USING BTREE IN maindbs;

ALTER TABLE Chapters ADD CONSTRAINT PRIMARY KEY (Chapter) CONSTRAINT Chapters_p;

CREATE TABLE Accounts (
  Account char(19) NOT NULL CONSTRAINT Accounts_1,
  Type char(1) NOT NULL	CONSTRAINT Accounts_2,
  Key char(1) NOT NULL CONSTRAINT Accounts_3,
  Dateop date NOT NULL CONSTRAINT Accounts_4,
  Datecl date NOT NULL CONSTRAINT Accounts_5,
  Name varchar(255) NOT NULL CONSTRAINT Accounts_6,
  CLID int NOT NULL CONSTRAINT Accounts_7,
  Chapter smallint NOT NULL CONSTRAINT Accounts_8,
  Numunit smallint NOT NULL CONSTRAINT Accounts_9,
  Balance decimal(22,8)	NOT NULL CONSTRAINT Accounts_10
) lock mode row;

REVOKE ALL ON Accounts FROM PUBLIC;

CREATE UNIQUE INDEX Accounts_1 ON Accounts (Account, Dateop) USING BTREE IN maindbs;

CREATE INDEX Accounts_2 ON Accounts (CLID) USING BTREE IN maindbs;

CREATE INDEX Accounts_3 ON Accounts (Chapter) USING BTREE IN maindbs;

CREATE INDEX Accounts_4 ON Accounts (Numunit) USING BTREE IN maindbs;

ALTER TABLE Accounts ADD CONSTRAINT PRIMARY KEY (Account, Dateop) CONSTRAINT Accounts_p;

ALTER TABLE Accounts ADD CONSTRAINT FOREIGN KEY (CLID) REFERENCES Clients (CLID) CONSTRAINT Accounts_f1;

ALTER TABLE Accounts ADD CONSTRAINT FOREIGN KEY (Chapter) REFERENCES Chapters (Chapter) CONSTRAINT Accounts_f2;

ALTER TABLE Accounts ADD CONSTRAINT FOREIGN KEY (Numunit) REFERENCES Units (Numunit) CONSTRAINT Accounts_f3;

CREATE TABLE Users (
  Nameuser varchar(20) NOT NULL CONSTRAINT Users_1,
  Numunit smallint NOT NULL CONSTRAINT Users_2,
  CLID int NOT NULL CONSTRAINT Users_3
) lock mode row;

REVOKE ALL ON Users FROM PUBLIC;

CREATE UNIQUE INDEX Users_1 ON Users (Nameuser) USING BTREE IN maindbs;

CREATE INDEX Users_2 ON Users (Numunit) USING BTREE IN maindbs;

CREATE INDEX Users_3 ON Users (CLID) USING BTREE IN maindbs;

ALTER TABLE Users ADD CONSTRAINT PRIMARY KEY (Nameuser) CONSTRAINT Users_p;

ALTER TABLE Users ADD CONSTRAINT FOREIGN KEY (Numunit) REFERENCES Units (Numunit) CONSTRAINT Users_f1;

ALTER TABLE Users ADD CONSTRAINT FOREIGN KEY (CLID) REFERENCES Clients (CLID) CONSTRAINT Users_f2;

CREATE TABLE Documents (
  D_Numdoc bigserial NOT NULL CONSTRAINT Documents_1,
  D_Typedoc int NOT NULL CONSTRAINT Documents_2,
  D_CLID int NOT NULL CONSTRAINT Documents_3,
  D_Chapter smallint NOT NULL CONSTRAINT Documents_4,
  D_Owner varchar(20) NOT NULL CONSTRAINT Documents_5,
  D_Signature varchar(20),
  D_Datecrea date NOT NULL CONSTRAINT Documents_6,
  D_Dateterm date NOT NULL CONSTRAINT Documents_7,
  D_Numunit smallint NOT NULL CONSTRAINT Documents_8,
  D_Srok date,
  D_Ochered bigint NOT NULL CONSTRAINT Documents_9,
  D_Numcust char(6) NOT NULL CONSTRAINT Documents_10,
  D_Datecust date NOT NULL CONSTRAINT Documents_11,
  D_Simvol char(2),
  D_Key char(1),
  D_Father bigint,
  D_Exec Boolean NOT NULL CONSTRAINT Documents_12,
  D_Plan Boolean NOT NULL CONSTRAINT Documents_13,
  D_Dbacc char(19),
  D_Cracc char(19),
  D_Summa decimal(22,8) NOT NULL CONSTRAINT Documents_14,
  D_Currency char(3) NOT NULL CONSTRAINT Documents_15,
  D_Rate decimal(22,8) NOT NULL	CONSTRAINT Documents_16,
  D_Sourceacc char(20),
  D_Sourcemfo char(9),
  D_Sourcecor char(20),
  D_Destacc char(20),
  D_Destmfo char(9),
  D_Destcor char(20),
  D_Remark char(305),
  D_Batch bigint NOT NULL CONSTRAINT Documents_17,
  D_Widop char(2),
  D_Overrate Boolean NOT NULL CONSTRAINT Documents_18,
  D_Choice smallint,
  D_Credcurr char(3),
  D_Innp char(12),
  D_Namep varchar(160),
  D_Ref1 bigint,
  D_Ref2 bigint
) lock mode row;

REVOKE ALL ON Documents FROM PUBLIC;

CREATE UNIQUE INDEX Documents_1 ON Documents (D_Numdoc) USING BTREE IN maindbs;

CREATE INDEX Documents_2 ON Documents (D_Typedoc) USING BTREE IN maindbs;

CREATE INDEX Documents_3 ON Documents (D_CLID) USING BTREE IN maindbs;

CREATE INDEX Documents_4 ON Documents (D_Chapter) USING BTREE IN maindbs;

CREATE INDEX Documents_5 ON Documents (D_Owner) USING BTREE IN maindbs;

CREATE INDEX Documents_6 ON Documents (D_Signature) USING BTREE IN maindbs;

CREATE INDEX Documents_7 ON Documents (D_Numunit) USING BTREE IN maindbs;

CREATE INDEX Documents_8 ON Documents (D_Father) USING BTREE IN maindbs;

CREATE INDEX Documents_9 ON Documents (D_Currency) USING BTREE IN maindbs;

ALTER TABLE Documents ADD CONSTRAINT PRIMARY KEY (D_Numdoc) CONSTRAINT Documents_p;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Typedoc) REFERENCES Type_Document (Typedoc) CONSTRAINT Documents_f1;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_CLID) REFERENCES Clients (CLID) CONSTRAINT Documents_f2;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Chapter) REFERENCES Chapters (Chapter) CONSTRAINT Documents_f3;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Owner) REFERENCES Users (Nameuser) CONSTRAINT Documents_f4;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Signature) REFERENCES Users (Nameuser) CONSTRAINT Documents_f5;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Numunit) REFERENCES Units (Numunit) CONSTRAINT Documents_f6;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Father) REFERENCES Documents (D_Numdoc) CONSTRAINT Documents_f7;

ALTER TABLE Documents ADD CONSTRAINT FOREIGN KEY (D_Currency) REFERENCES Currency (Currency) CONSTRAINT Documents_f8;

CREATE TABLE Operations (
  Numoper bigserial NOT NULL CONSTRAINT Operations_1,
  Numdoc bigint NOT NULL CONSTRAINT Operations_2,
  Dbacc char(19) NOT NULL CONSTRAINT Operations_3,
  Cracc char(19) NOT NULL CONSTRAINT Operations_4,
  Dateoper date NOT NULL CONSTRAINT Operations_5,
  Currency char(3) NOT NULL CONSTRAINT Operations_6,
  Amount decimal(22,8) NOT NULL CONSTRAINT Operations_7,
  Overrate Boolean NOT NULL CONSTRAINT Operations_8,
  Numunit smallint NOT NULL CONSTRAINT Operations_9
) lock mode row;

REVOKE ALL ON Operations FROM PUBLIC;

CREATE UNIQUE INDEX Operations_1 ON Operations (Numoper) USING BTREE IN maindbs;

CREATE UNIQUE INDEX Operations_2 ON Operations (Numdoc) USING BTREE IN maindbs;

CREATE INDEX Operations_3 ON Operations (Numunit) USING BTREE IN maindbs;

ALTER TABLE Operations ADD CONSTRAINT PRIMARY KEY (Numoper) CONSTRAINT Operations_p;

ALTER TABLE Operations ADD CONSTRAINT UNIQUE (Numdoc) CONSTRAINT Operations_u1;

ALTER TABLE Operations ADD CONSTRAINT FOREIGN KEY (Numdoc) REFERENCES Documents (D_Numdoc) CONSTRAINT Operations_f1;

ALTER TABLE Operations ADD CONSTRAINT FOREIGN KEY (Numunit) REFERENCES Units (Numunit) CONSTRAINT Operations_f2;

CREATE TABLE Balance (
  Dateoper date NOT NULL CONSTRAINT Balance_1,
  Account char(19) NOT NULL CONSTRAINT Balance_2,
  Currency char(3) NOT NULL CONSTRAINT Balance_3,
  Dbtotal decimal(22,8) NOT NULL CONSTRAINT Balance_4,
  Crtotal decimal(22,8) NOT NULL CONSTRAINT Balance_5,
  Saldo decimal(22,8) NOT NULL CONSTRAINT Balance_6,
  Numunit smallint NOT NULL CONSTRAINT Balance_7
) lock mode row;

REVOKE ALL ON Balance FROM PUBLIC;

CREATE UNIQUE INDEX Balance_1 ON Balance (Dateoper, Account, Currency, Numunit) USING BTREE IN maindbs;

CREATE INDEX Balance_2 ON Balance (Dateoper, Numunit) USING BTREE IN maindbs;

CREATE INDEX Balance_3 ON Balance (Currency) USING BTREE IN maindbs;

CREATE INDEX Balance_4 ON Balance (Numunit) USING BTREE IN maindbs;

ALTER TABLE Balance ADD CONSTRAINT PRIMARY KEY (Dateoper, Account, Currency, Numunit) CONSTRAINT Balance_p;

ALTER TABLE Balance ADD CONSTRAINT FOREIGN KEY (Dateoper, Numunit) REFERENCES Operating_Date (Dateoper, Numunit) CONSTRAINT Balance_f1;

ALTER TABLE Balance ADD CONSTRAINT FOREIGN KEY (Currency) REFERENCES Currency (Currency) CONSTRAINT Balance_f2;

ALTER TABLE Balance ADD CONSTRAINT FOREIGN KEY (Numunit) REFERENCES Units (Numunit) CONSTRAINT Balance_f3;

CREATE TABLE Makets (
  Maket	smallint NOT NULL CONSTRAINT Makets_1,
  Sysname varchar(15) NOT NULL CONSTRAINT Makets_2,
  Choice smallint NOT NULL CONSTRAINT Makets_3,
  Typedoc int NOT NULL CONSTRAINT Makets_4,
  Context varchar(255) NOT NULL CONSTRAINT Makets_5
) lock mode row;

REVOKE ALL ON Makets FROM PUBLIC;

CREATE UNIQUE INDEX Makets_1 ON Makets (Maket, Sysname, Choice) USING BTREE IN maindbs;

CREATE INDEX Makets_2 ON Makets (Typedoc) USING BTREE IN maindbs;

ALTER TABLE Makets ADD CONSTRAINT PRIMARY KEY (Maket, Sysname, Choice) CONSTRAINT Makets_p;

ALTER TABLE Makets ADD CONSTRAINT FOREIGN KEY (Typedoc) REFERENCES Type_Document (Typedoc) CONSTRAINT Makets_f1;

CREATE TABLE Info_Account (
  Account2p char(5) NOT NULL CONSTRAINT Info_Account_1,
  Name varchar(50,0) NOT NULL CONSTRAINT Info_Account_2,
  Type char(1) NOT NULL CONSTRAINT Info_Account_3,
  Chapter smallint,
  Open Boolean NOT NULL CONSTRAINT Info_Account_4
) lock mode row;

REVOKE ALL ON Info_Account FROM PUBLIC;

CREATE UNIQUE INDEX Info_Account_1 ON Info_Account (Account2p) USING BTREE IN maindbs;

CREATE INDEX Info_Account_2 ON Info_Account (Chapter) USING BTREE IN maindbs;

ALTER TABLE Info_Account ADD CONSTRAINT PRIMARY KEY (Account2p) CONSTRAINT Info_Account_p;

ALTER TABLE Info_Account ADD CONSTRAINT CHECK (Type IN ('a','p')) CONSTRAINT Info_Account_c1;

ALTER TABLE Info_Account ADD CONSTRAINT FOREIGN KEY (Chapter) REFERENCES Chapters (Chapter) CONSTRAINT Info_Account_f1;

CREATE ROLE Reader;

GRANT SELECT ON Units TO Reader;

GRANT SELECT ON Clients TO Reader;

GRANT SELECT ON Physical TO Reader;

GRANT SELECT ON Legal TO Reader;

GRANT SELECT ON Operating_Date TO Reader;

GRANT SELECT ON Rate TO Reader;

GRANT SELECT ON Currency TO Reader;

GRANT SELECT ON Type_Document TO Reader;

GRANT SELECT ON Accounts TO Reader;

GRANT SELECT ON Users TO Reader;

GRANT SELECT ON Operations TO Reader;

GRANT SELECT ON Documents TO Reader;

GRANT SELECT ON Balance TO Reader;

GRANT SELECT ON Chapters TO Reader;

GRANT SELECT ON Makets TO Reader;

CREATE ROLE Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Units TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Clients TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Physical TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Legal TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Operating_Date TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Rate TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Currency TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Type_Document TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Accounts TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Users TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Operations TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Documents TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Balance TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Chapters TO Writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Makets TO Writer;
