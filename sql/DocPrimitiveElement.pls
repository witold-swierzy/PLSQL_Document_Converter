-- component : DocPrimitiveElement class specification
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this is class used to store primitive document elements

create or replace type DocPrimitiveElement under DocElement (
	elemValue   DocValue,

	constructor function DocPrimitiveElement(eName varchar2,cval varchar2) return self as result,
	constructor function DocPrimitiveElement(eName varchar2,cval number  ) return self as result,
	constructor function DocPrimitiveElement(eName varchar2,cval date    ) return self as result,
    constructor function DocPrimitiveElement(element XMLType)              return self as result,
	
	overriding member function getComponentType    return integer,
	overriding member function getValueType        return integer,
	overriding member function toString            return clob,
    overriding member function getAsXMLType        return XMLType,
    overriding member function getAsJSON_ELEMENT_T return JSON_ELEMENT_T,
	
    member function getAsVarchar2 return varchar2,
	member function getAsNumber   return number,
	member function getAsDate     return date
    
);
/
