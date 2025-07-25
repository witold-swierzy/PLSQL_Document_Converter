create or replace package body doc_conv
is
    function xml2json_element_t(xDoc XMLType) return JSON_ELEMENT_T
    is
    begin
        return DocElement(xDoc).getAsJSON;
    end;

    function xml2json(xDoc XMLType) return JSON
    is
    begin
        return JSON(xml2json_element_t(xDoc).to_Clob);
    end;

    function json_element_t2xml(jDoc JSON_ELEMENT_T) return XMLType
    is
    begin
        return DocElement(jDoc).getAsXML;
    end;

    function json2xml(jDoc JSON) return XMLType
    is
        jc clob;
        jd JSON_ELEMENT_T;
    begin
        select JSON_SERIALIZE(jDoc)
        into jc;

        jd := JSON_ELEMENT_T.parse(jc);

        return json_element_t2xml(jd);
    end;
end;