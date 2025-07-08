-- component : DocDocumentElement class specification
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store whole documents with all their components:
-- primitives, arrays and nested documents

create or replace type DocDocumentElement under DocElement (
	valArray  DocComponentArray,
	
	constructor function DocDocumentElement return self as result,
	constructor function DocDocumentElement(dName varchar2) return self as result,
	constructor function DocDocumentElement(dName varchar2, elem DocElement) return self as result,
	
	member procedure addElement(elem DocElement),
	member function getElement(elemName varchar2) return DocElement,
	
	overriding member function getComponentType      return integer,
	overriding member function getValueType          return integer,
	overriding member function toString(fmt integer) return clob,
	overriding member function getAsXMLType return XMLType,
    overriding member function getAsJSON_ELEMENT_T  return JSON_ELEMENT_T
);
/
