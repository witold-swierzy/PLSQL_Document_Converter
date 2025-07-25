create or replace package doc_conv
is
    function xml2json_element_t(xDoc XMLType) return JSON_ELEMENT_T;
    function xml2json(xDoc XMLType) return JSON;
    function json_element_t2xml(jDoc JSON_ELEMENT_T) return XMLType;
    function json2xml(jDoc JSON) return XMLType;
end;