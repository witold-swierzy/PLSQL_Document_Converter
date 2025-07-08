-- component : DocElement class specification
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this is abstract class used as a root for all classes defining document elements:
-- primitives, arrays and nested documents

create or replace type DocElement under DocComponent (
	elemName varchar2(32767),

	not instantiable member function toString return clob,
    not instantiable member function getAsXMLType return XMLType,
    not instantiable member function getAsJSON_ELEMENT_T  return JSON_ELEMENT_T,
	
	member function getName return varchar2
)
not instantiable not final;
/
