-- component : DocDocumentElement class body
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store whole documents with all their components:
-- primitives, arrays and nested documents

create or replace type body DocDocumentElement 
as
	constructor function DocDocumentElement return self as result
	is
	begin
		valArray := DocComponentArray();
		return;
	end;
	
	constructor function DocDocumentElement(dName varchar2) return self as result
	is
	begin
		elemName := dName;
		valArray := DocComponentArray();
		return;
	end;
	
	constructor function DocDocumentElement(dName varchar2, elem DocElement) return self as result
	is
	begin
		elemName := dName;		
		valArray := DocComponentArray(elem);
		return;
	end;
	
	member procedure addElement(elem DocElement)
	is
	begin
		for i in 1..valArray.count loop
			if treat(valArray(i) as DocElement).getName = elem.getName then
				raise_application_error(doc_conv_consts.e_doc_element_exists_no,doc_conv_consts.e_doc_element_exists_msg);
			end if;
		end loop;
		valArray.extend;
		valArray(valArray.last) := elem;
	end;
	
	member function getElement(elemName varchar2) return DocElement
	is
	begin
		for i in 1..valArray.count loop
			if treat(valArray(i) as DocElement).getName = elemName then
				return treat(valArray(i) as DocElement);
			end if;
		end loop;
		raise_application_error(doc_conv_consts.e_doc_element_not_exists_no,doc_conv_consts.e_doc_element_not_exists_msg);
	end;
	
	overriding member function getComponentType return integer
	is
	begin
		return doc_conv_consts.comp_type_document;
	end;
	
	overriding member function getValueType     return integer
	is
	begin
		return doc_conv_consts.val_type_na;
	end;
	
	overriding member function toString(fmt integer) return clob
	is		
		result    clob;
	begin
        if fmt = doc_conv_consts.fmt_json then
            result := '{';
            
            for i in 1..valArray.last loop
                if i > 1 then
                    result := result||',';
                end if;
                if valArray(i).getComponentType <> doc_conv_consts.comp_type_primitive then
                    result := result||'"'||treat(valArray(i) as DocElement).getName||'":'||valArray(i).toString(fmt);
                else
                    result := result||valArray(i).toString(doc_conv_consts.fmt_json_primitive);
                end if;
            end loop;
            result := result || '}';
        elsif fmt = doc_conv_consts.fmt_xml then
            result := '<'||elemName||'>';
            for i in 1..valArray.last loop
                result := result||valArray(i).toString(fmt);
            end loop;
            result := result||'</'||elemName||'>';
        else
            raise_application_error(doc_conv_consts.e_unknown_fmt_no,
			                        doc_conv_consts.e_unknown_fmt_msg);
        end if;
		return result;
	end;

	overriding member function getAsXMLType return XMLType
	is
	begin
		return null;
	end;

    overriding member function getAsJSON_ELEMENT_T  return JSON_ELEMENT_T
	is
	begin
		return null;
	end;
end;
/	



