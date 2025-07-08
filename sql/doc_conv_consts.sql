-- component: doc_conv_consts
-- type     : PL/SQL package
-- author   : witold.swierzy@oracle.com
-- this package defines constants used by document converter

create or replace package doc_conv_consts
is
	fmt_json			constant integer := 1;
	fmt_xml				constant integer := 2;
	fmt_json_primitive	constant integer := 3;

	comp_type_nn        constant integer := -1;
	comp_type_component constant integer := 0;
	comp_type_value     constant integer := 1;
	comp_type_element   constant integer := 2;
	comp_type_primitive constant integer := 3;
	comp_type_array     constant integer := 4;
	comp_type_document  constant integer := 5;

    val_type_na        constant integer := -2;
 	val_type_nn        constant integer := -1;
    val_type_element   constant integer := 0;
		
	e_incompatible_types_no        constant integer := -20001;
	e_doc_element_exists_no        constant integer := -20002;
	e_doc_element_not_exists_no    constant integer := -20003;
	e_doc_element_not_primitive_no constant integer := -20004;
	e_unknown_fmt_no               constant integer := -20005;
	
	e_incompatible_types_msg        constant varchar2(32767) := 'incombatible datatype of component';
	e_doc_element_exists_msg        constant varchar2(32767) := 'element with the name provided already exists';
	e_doc_element_not_exists_msg    constant varchar2(32767) := 'element with the name provided does not exist';
	e_doc_element_not_primitive_msg constant varchar2(32767) := 'element is not primitive';
	e_unknown_fmt_msg				constant varchar2(32767) := 'unknown document format';
end;
/