create or replace package doc_utl
is
    type t_param_table is table of varchar2(200) index by varchar2(200);

    type_string constant integer := DBMS_TYPES.TYPECODE_VARCHAR2;
    type_number constant integer := DBMS_TYPES.TYPECODE_NUMBER;
    type_date   constant integer := DBMS_TYPES.TYPECODE_DATE;
    type_bool   constant integer := -1;

    comp_component constant integer := 1;
    comp_value     constant integer := 2;
    comp_element   constant integer := 3;
    comp_array     constant integer := 4;

    fmt_json       constant integer := 1;
    fmt_json_doc   constant integer := 2;   
    fmt_xml        constant integer := 3;
    fmt_xml_doc    constant integer := 4;

    xml_value    constant integer := 1;
    xml_fragment constant integer := 2;
    xml_array    constant integer := 3;
    xml_document constant integer := 4;

    param_table t_param_table;

    procedure set_parameter(p_param integer, p_val varchar2);
    function  get_parameter(p_param varchar2) return varchar2;

    function  doc_type     (doc XMLType)  return number;
    function  scalar_type  (val clob) return number;
end;
/