CREATE PROCEDURE Operating_Date_1(Pdateoper date)
DEFINE Mdateoper date;
SELECT Dateoper INTO Mdateoper FROM Rate AS r WHERE r.Dateoper = Pdateoper limit 1;
IF (Mdateoper IS NULL)
THEN RAISE EXCEPTION -746,0,"Dateoper is not found in Table (Rate)";
END IF;
END PROCEDURE;

CREATE TRIGGER Operating_Date_1
INSERT ON Operating_Date
REFERENCING NEW AS thenew
FOR EACH ROW
(
EXECUTE PROCEDURE Operating_Date_1(thenew.Dateoper)
);

CREATE PROCEDURE Operations_1(Pdateoper date)
RAISE EXCEPTION -746,0,"This table can not update";
END PROCEDURE;

CREATE TRIGGER Operations_1
UPDATE ON Operations
REFERENCING NEW AS thenew
FOR EACH ROW
(
EXECUTE PROCEDURE Operations_1(thenew.Dateoper)
);

CREATE PROCEDURE Operations_2(Pdateoper date)
DEFINE Mdateoper date;
SELECT Dateoper INTO Mdateoper FROM Operating_Date AS o WHERE o.Dateoper = Pdateoper and o.Status = "open" limit 1;
IF (Mdateoper IS NULL)
THEN RAISE EXCEPTION -746,0,"Dateoper is not found in Table (Operating_Date)";
END IF;
END PROCEDURE;

CREATE TRIGGER Operations_2
INSERT ON Operations
REFERENCING NEW AS thenew
FOR EACH ROW
(
EXECUTE PROCEDURE Operations_2(thenew.Dateoper)
);

CREATE PROCEDURE Accounts_1(Pchapter smallint)
DEFINE Mchapter smallint;
SELECT Chapter INTO Mchapter FROM Info_Account AS i WHERE i.Chapter = Pchapter limit 1;
IF (Mchapter IS NULL)
THEN RAISE EXCEPTION -746,0,"Chapter is not found in Table (Info_Account)";
END IF;
END PROCEDURE;

CREATE TRIGGER Accounts_1
INSERT ON Accounts
REFERENCING NEW AS thenew
FOR EACH ROW
(
EXECUTE PROCEDURE Accounts_1(thenew.Chapter)
);
