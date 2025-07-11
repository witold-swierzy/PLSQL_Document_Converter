-- 1. creation of XML object table
drop table if exists sample_xml_table;
drop view if exists json_doc;

create table sample_xml_table of XMLType;

insert into sample_xml_table 
values (XMLType('<abra>kadabra</abra>'));

insert into sample_xml_table
values (XMLType('<abra1><abra2>kadabra</abra2></abra1>'));

insert into sample_xml_table
values (
'<kadabra>
    <abra1>aaa</abra1>
    <abra1>bbb</abra1>
    <abra1>ccc</abra1>
</kadabra>');

commit;

create or replace function xml2json(xDoc XMLType) return json
is
    j JSON_ELEMENT_T := DocElement(xDoc).getAsJSON;
begin
    return JSON(j.to_Clob);
end;
/

select value(x) from sample_xml_table x;
select xml2json(value(x)) from sample_xml_table x;

select xml2json(value(t)) json_col, value(t) xml_col
from sample_xml_table t;

create or replace json collection view json_v
as 
select xml2json(value(t)) data
from sample_xml_table t;
