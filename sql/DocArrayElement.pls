-- component : DocArrayElement class specification
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store array elements of a document

create or replace type DocArrayElement under DocElement (
	valArray  DocComponentArray,
	valueType integer,
	itemName  varchar2(32767), 
	
	constructor function DocArrayElement (aName varchar2, iName varchar2 := '')                    return self as result,
	constructor function DocArrayElement (aName varchar2, comp DocComponent, iName varchar2 := '')          return self as result,
	constructor function DocArrayElement (aName varchar2, vType integer, iName varchar2 := '') return self as result,
	
	member procedure setValueType(vType integer),
	member procedure addComponent(comp DocComponent),
	
	member function getComponent(i integer)     return DocComponent,
	
	overriding member function getComponentType      return integer,
	overriding member function getValueType          return integer,
	overriding member function toString(fmt integer) return clob,
    overriding member function getAsXMLType return XMLType,
    overriding member function getAsJSON_ELEMENT_T  return JSON_ELEMENT_T

);
/