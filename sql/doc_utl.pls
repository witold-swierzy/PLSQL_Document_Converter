create or replace package doc_utl
is
    comp_component constant integer := 1;
    comp_value     constant integer := 2;
    comp_element   constant integer := 3;
    comp_array     constant integer := 4;

    fmt_json       constant integer := 1;
    fmt_json_doc   constant integer := 2;   
    fmt_xml        constant integer := 3;
    fmt_xml_doc    constant integer := 4;

    p_def_arr_name   constant integer := 1;
    p_def_item_name  constant integer := 2;
    p_def_root_name  constant integer := 3;
    p_apply_def2json constant integer := 4;

    xml_value    constant integer := 1;
    xml_fragment constant integer := 2;
    xml_array    constant integer := 3;
    xml_document constant integer := 4;
      
    def_arr_name   varchar2(200);
    def_item_name  varchar2(200);
    def_root_name  varchar2(200);
    apply_def2json boolean; 

    procedure set_parameter(p_param integer, p_val varchar2);
    function  doc_type     (doc XMLType)  return number;
    function  scalar_type  (val clob) return number;
end;
/