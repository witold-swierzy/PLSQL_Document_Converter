-- component : DocArrayElement class body
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store array elements of a document

create or replace type body DocArrayElement 
as
	
		constructor function DocArrayElement (aName varchar2, iName varchar2 := '')                    return self as result
		is
		begin
		    elemName := aName;
			if length(iName) > 0 then 
				itemName :=iName;
			else
				itemName := 'item';
			end if;
			valArray := DocComponentArray();
			valueType    := doc_conv_consts.val_type_nn;
			return;
		end;
		
		constructor function DocArrayElement (aName varchar2, comp DocComponent, iName varchar2 := '')          return self as result
		is
		begin
			elemName := aName;
            if length(iName) > 0 then 
				itemName := iName;
			else
				itemName := 'item';
			end if;
			valArray  := DocComponentArray(comp);
			if comp.getComponentType = doc_conv_consts.comp_type_value then
				valueType := comp.getValueType;
			elsif comp.getComponentType = doc_conv_consts.comp_type_array then
				valueType := DBMS_TYPES.TYPECODE_TABLE;
			elsif comp.getComponentType = doc_conv_consts.comp_type_document then
				valueType := DBMS_TYPES.TYPECODE_OBJECT;
			end if;
			return;
		end;
		
		constructor function DocArrayElement (aName varchar2, vType integer, iName varchar2 := '') return self as result
		is
		begin
		    elemName := aName;		
			valArray  := DocComponentArray();
			valueType := vType;
			if length(iName) > 0 then
				itemName := iName;
			else
				itemName := 'item';
			end if;
			return;
		end;
				
		member procedure setValueType(vType integer)
		is
		begin
			valueType := vType;
		end;
		
		member procedure addComponent(comp DocComponent)
		is
		begin
			if valueType = doc_conv_consts.comp_type_nn then
				if comp.getComponentType = doc_conv_consts.comp_type_value then
					valueType := comp.getValueType;
				elsif comp.getComponentType = doc_conv_consts.comp_type_array then
					valueType := DBMS_TYPES.TYPECODE_TABLE;
				elsif comp.getComponentType = doc_conv_consts.comp_type_document then
					valueType := DBMS_TYPES.TYPECODE_OBJECT;
				end if;
			elsif valueType <> comp.getValueType 
			  and valueType <> DBMS_TYPES.TYPECODE_TABLE
			  and valueType <> DBMS_TYPES.TYPECODE_OBJECT then
				raise_application_error(doc_conv_consts.e_incompatible_types_no,doc_conv_consts.e_incompatible_types_msg);
			end if;
			valArray.extend;
			valArray(valArray.last)  := comp;
		end;
		
		member function getComponent(i integer) return DocComponent
		is
		begin
			return valArray(i);
		end;

		overriding member function getComponentType return integer
		is
		begin
			return doc_conv_consts.comp_type_array;
		end;

		overriding member function getValueType return integer
		is
		begin
			return valueType;
		end;
		
		overriding member function toString(fmt integer) return clob
		is
		    return_value clob := '';
		begin
            if fmt = doc_conv_consts.fmt_json then
                return_value := '[';
                for i in valArray.first..valArray.last loop
                    --if ValArray(i).getComponentType <> doc_conv_consts.comp_type_primitive then
                        return_value := return_value||valArray(i).toString(doc_conv_consts.fmt_json);
                    --else
                        --return_value := return_value||valArray(i).toString(doc_conv_consts.fmt_json_primitive);
                    --end if;
                    if i < valArray.last then
                            return_value := return_value||',';
                    end if;
                end loop;
                return_value := return_value||']';
            elsif fmt = doc_conv_consts.fmt_xml then
                return_value := '<'||elemName||'>';
                for i in valArray.first..valArray.last loop
                    return_value := return_value||'<'||itemName||'>'||valArray(i).toString(fmt)||'</'||itemName||'>';
                end loop;
                return_value := return_value||'</'||elemName||'>';
            else
                raise_application_error(doc_conv_consts.e_unknown_fmt_no,
			                            doc_conv_consts.e_unknown_fmt_msg);
            end if;
			return return_value;
		end;

    overriding member function getAsXMLType return XMLType
	is
	begin 
		return XMLType(toString(doc_conv_consts.fmt_xml));
	end;
    
	overriding member function getAsJSON_ELEMENT_T  return JSON_ELEMENT_T
	is 
	begin 
		return JSON_ARRAY_T.parse(toString(doc_conv_consts.fmt_json));
	end;
		
end;
/