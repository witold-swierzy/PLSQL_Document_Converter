-- component : DocPrimitiveElement class body
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this is class used to store primitive document elements



create or replace type body DocPrimitiveElement 
as
	constructor function DocPrimitiveElement(eName varchar2,cval varchar2) return self as result
	is
	begin
	    elemName  := eName;
		elemValue := DocValue(cval);
		return;
	end;
	
	constructor function DocPrimitiveElement(eName varchar2,cval number  ) return self as result
	is
	begin
		elemName  := eName;
		elemValue := DocValue(cval);
		return;
	end;

	constructor function DocPrimitiveElement(eName varchar2,cval date    ) return self as result
	is
	begin
		elemName  := eName;
		elemValue := DocValue(cval);
		return;
	end;
	
	overriding member function getComponentType return integer
	is
	begin
		return doc_conv_consts.comp_type_primitive;
	end;
	
	overriding member function getValueType return integer
	is
	begin
		return elemValue.getValueType;
	end;
	
	member function getAsVarchar2 return varchar2
	is
	begin
		return elemValue.getAsVarchar2;
	end;
	
	overriding member function toString    return clob
	is
		return_value clob;
	begin
		return_value := '"'||elemName||'":';
		if getValueType = DBMS_TYPES.TYPECODE_VARCHAR2 then
			return_value := return_value||'"'||elemValue.getAsVarchar2||'"';
		elsif getValueType = DBMS_TYPES.TYPECODE_NUMBER then
			return_value := return_value||to_char(elemValue.getAsNumber);
		elsif getValueType = DBMS_TYPES.TYPECODE_DATE then
			return_value := return_value||'"'||to_char(elemValue.getAsDate)||'"';	
		end if;
		return return_value;
	end;
	
	member function getAsNumber   return number
	is
	begin	
		return elemValue.getAsNumber;
	end;
	
	member function getAsDate     return date	
	is
	begin
		return elemValue.getAsDate;
	end;
end;
/
