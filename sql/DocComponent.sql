-- component : DocComponent
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this is abstract class, which is used as a root for all classes 
-- of PL/SQL document converter

create or replace type DocComponent as object (
	compId integer,
	not instantiable member function getComponentType  return integer,
	not instantiable member function getValueType return integer
)
not instantiable not final;
/


create or replace type DocComponentArray as table of DocComponent;
/
