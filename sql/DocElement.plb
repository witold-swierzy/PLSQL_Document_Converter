-- component : DocElement class body
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this is abstract class used as a root for all classes defining document elements:
-- primitives, arrays and nested documents


create or replace type body DocElement
as
	member function getName return varchar2
	is
	begin
		return elemName;
	end;
end;
/	