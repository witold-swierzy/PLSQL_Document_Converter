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
	
    constructor function DocPrimitiveElement(element XMLType)              return self as result
    is
        XmlElemValue varchar2(32767);
    begin
        if doc_conv_utils.is_primitive(element) then
           elemName  := element.getrootelement();
           
           select extractvalue(element,'/node()')
           into XmlElemValue;
           
           if doc_conv_utils.is_number(XmlElemValue) then
                elemValue := DocValue(to_number(XmlElemValue));
           elsif doc_conv_utils.is_date(XmlElemValue) then
                elemValue := DocValue(to_date(XmlElemValue));
           else
                elemValue := DocValue(XmlElemValue);
           end if;
        else
            raise_application_error(doc_conv_consts.e_doc_element_not_primitive_no,
                                    doc_conv_consts.e_doc_element_not_primitive_msg);
        end if;
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
	
    overriding member function getAsXMLType        return XMLType
    is
        clob_value clob;
    begin
       clob_value := '<'||elemName||'>'||getAsVarchar2||'</'||elemName||'>';
       return XMLType(clob_value);
    end;
    
    overriding member function getAsJSON_ELEMENT_T return JSON_ELEMENT_T
    is
		clob_value clob;
	begin
		clob_value := '"'||elemName||'":';
		if getValueType = DBMS_TYPES.TYPECODE_VARCHAR2 then
			clob_value := clob_value||'"'||elemValue.getAsVarchar2||'"';
		elsif getValueType = DBMS_TYPES.TYPECODE_NUMBER then
			clob_value := clob_value||to_char(elemValue.getAsNumber);
		elsif getValueType = DBMS_TYPES.TYPECODE_DATE then
			clob_value := clob_value||'"'||to_char(elemValue.getAsDate)||'"';	
		end if;
        return JSON_ELEMENT_T.parse('{'||clob_value||'}');
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
