-- component : DocValue class specification
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store a single value in a document

create or replace type DocValue under DocComponent (
	compValue     AnyData,
	compValueType integer,
	
	constructor function DocValue(cval varchar2) return self as result,
	constructor function DocValue(cval number) return self as result,
	constructor function DocValue(cval date) return self as result,
	
	overriding member function getComponentType return integer,
	overriding member function getValueType     return integer,
	
	member function getAsVarchar2 return varchar2,
	member function getAsNumber   return number,
	member function getAsDate     return date
	
);
/
