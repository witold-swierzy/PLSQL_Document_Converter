-- component : DocArrayElement class body
-- type      : PL/SQL class
-- author    : witold.swierzy@oracle.com
-- this class is used to store array elements of a document

create or replace type body DocArrayElement 
as
	
		constructor function DocArrayElement(aName varchar2) return self as result
		is
		begin
		    elemName := aName;
			valArray := DocComponentArray();
			valueType    := doc_conv_consts.val_type_nn;
			return;
		end;
		
		constructor function DocArrayElement (aName varchar2,comp DocComponent) return self as result
		is
		begin
			elemName := aName;
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
		
		constructor function DocArrayElement (aName varchar2, vType integer) return self as result
		is
		begin
		    elemName := aName;		
			valArray  := DocComponentArray();
			valueType := vType;
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
		
		overriding member function toString    return clob
		is
		    return_value clob;
		begin
			if length(elemName) > 0 then
				return_value := '"'||elemName||'":';
			end if;
			return_value := return_value||'[';
			if valueType not in (DBMS_TYPES.TYPECODE_TABLE,DBMS_TYPES.TYPECODE_OBJECT) then
				for i in valArray.first..valArray.last loop
					if valueType = DBMS_TYPES.TYPECODE_VARCHAR2 then 
						return_value := return_value || '"' || treat(valArray(i) as DocValue).getAsVarchar2 || '"';
					elsif valueType = DBMS_TYPES.TYPECODE_NUMBER then
						return_value := return_value || treat(valArray(i) as DocValue).getAsNumber;
					elsif valueType = DBMS_TYPES.TYPECODE_DATE then
						return_value := return_value || '"' || treat(valArray(i) as DocValue).getAsDate || '"';
					end if;
					if i < valArray.last then
						return_value := return_value||',';
					end if;
				end loop;
			else
				for i in valArray.first..valArray.last loop
					return_value := return_value || treat(valArray(i) as DocElement).toString;
					if i < valArray.last then
						return_value := return_value||',';
					end if;
				end loop;
			end if;
			return_value := return_value||']';
			return return_value;
		end;		
end;
/
