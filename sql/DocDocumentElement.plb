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
	
	overriding member function toString         return clob
	is		
		result    clob;
	begin
		if elemName is not null then
			result := '"'||elemName||'":{';
		else
			result := '{';
		end if;
		
		for i in 1..valArray.last loop
			if i > 1 then
				result := result||',';
			end if;
			result := result||treat(ValArray(i) as DocElement).toString;
		end loop;
		result := result || '}';
		return result;
	end;
end;
/	


