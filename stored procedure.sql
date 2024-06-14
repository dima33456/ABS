create procedure select_clients (inni char(12)) returning int, varchar(10,5), char(12), char(10), char(9), json
DEFINE
tp varchar(10,5);
DEFINE mid int; DEFINE type varchar(10,5); DEFINE inno char(10); DEFINE inno2 char(12); DEFINE rrc char(9); DEFINE document json; 
BEGIN 
	if (LENGTH(inni) = 12) then
		SELECT c.type INTO tp FROM clients c JOIN physical p ON c.mid = p.mid WHERE p.inn = inni;
		if (tp = 'individual') THEN
			SELECT c.mid, c.type, p.inn as physical_inn, l.inn as legal_inn, l.rrc as legal_kpp, l.document::json as name, 
			l.address::json as address INTO mid, type, inno2, inno, rrc, document FROM clients c JOIN legal l ON c.mid = l.mid JOIN physical p ON c.mid = p.mid 
			WHERE p.inn = inni;
			
		else
			SELECT c.mid, c.type, p.inn, '', '', p.document::json as surname INTO mid, type, inno2, inno, rrc, document FROM clients c 
			JOIN physical p ON c.mid = p.mid WHERE p.inn = inni; 
			
		end IF
	end IF
	if (LENGTH(inni) = 10) then
		SELECT c.type INTO tp FROM clients c JOIN legal l ON c.mid = l.mid WHERE l.inn = inni;
		if (tp = 'individual') THEN
			SELECT c.mid, c.type, p.inn as physical_inn, l.inn as legal_inn, l.rrc as legal_kpp, l.document::json as name, 
			l.address::json as address INTO mid, type, inno2, inno, rrc, document FROM clients c JOIN legal l ON c.mid = l.mid JOIN physical p ON c.mid = p.mid 
			WHERE l.inn = inni;
			
		else
			SELECT c.mid, c.type, '', l.inn, l.rrc, l.document::json as name, l.address::json as address INTO mid, type, inno2, inno, rrc, document 
			FROM clients c 
			JOIN legal l ON c.mid = l.mid WHERE l.inn = inni;
			
		end IF
	end IF
RETURN mid, type, inno2, inno, rrc, document;
END;
END PROCEDURE;
