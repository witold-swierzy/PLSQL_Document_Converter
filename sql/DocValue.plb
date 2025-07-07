-- component : DocValue
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store a single value in a document

create or replace type body DocValue 
as
	constructor function DocValue(cval varchar2) return self as result
	is
	begin
		compValue     := AnyData.convertvarchar2(cval);
		compValueType := DBMS_TYPES.TYPECODE_VARCHAR2;
		return;
	end;

	constructor function DocValue(cval number) return self as result
	is
	begin
		compValue     := AnyData.convertvarchar2(to_char(cval));
		compValueType := DBMS_TYPES.TYPECODE_NUMBER;
		return;
	end;	
	
	constructor function DocValue(cval date) return self as result
	is
	begin
		compValue     := AnyData.convertdate(cval);
		compValueType := DBMS_TYPES.TYPECODE_DATE;
		return;
	end;
	
	overriding member function getComponentType return integer
	is
	begin
		return doc_conv_consts.comp_type_value;
	end;
	
	overriding member function getValueType  return integer
	is
	begin
		return compValueType;
	end;
	
	member function getAsVarchar2 return varchar2
	is
		result integer;
		return_value varchar2(32767);
	begin
		result := compValue.getvarchar2(return_value);
		return return_value;
	end;
	
	member function getAsNumber return number
	is
		result integer;
		return_value varchar2(32767);
	begin
		result := compValue.getvarchar2(return_value);
		return to_number(return_value);
	end;
	
	member function getAsDate return date
	is
		result integer;
		return_value date;
	begin
		result := compValue.getdate(return_value);
		return return_value;
	end;
end;
/

