-- this demo demonstrates comments and attributes support 
-- requirements: HR sample schema

-- 1. Comments
drop table if exists dept_xml_table;

create table dept_xml_table
as
select department_id, doc_conv.json2xml(JSON{*}) department
from hr.departments;

select *
from dept_xml_table;

declare
    cursor c_dept is select * from dept_xml_table for update;
    de DocElement;
    dj JSON_ELEMENT_T;
    dx XMLType;
    i integer := 0;
begin
    for r in c_dept loop
    
        i := i+1;
        
        de := DocElement(r.department);
        de.addComment('Comment for department : '||r.department_id);
        
        dx := de.getAsXML;
        
        update dept_xml_table
        set department = dx
        where current of c_dept;
    
    end loop;
    commit;
end;
/

select *
from dept_xml_table;

create or replace json collection view dept_json_view
as
select doc_conv.xml2json(department)
from dept_xml_table;

select *
from dept_json_view;

select doc_conv.json2xml(data)
from dept_json_view;




-- 2.Attributes
declare
    cursor c_dept is select * from dept_xml_table for update;
    de DocElement;
    dj JSON_ELEMENT_T;
    dx XMLType;
    da DocAttribute;
    i integer := 0;
begin
    for r in c_dept loop
        de := DocElement(r.department);
        
        select count(*)
        into i
        from hr.employees
        where department_id = r.department_id;
        
        da := DocAttribute('no_of_emps',to_clob(i));
        dbms_output.put_line('i = '||i);
        dbms_output.put_line('key = '||da.key||' val = '||da.val);
        
        de.addAttr(da);
        dx := de.getAsXML;        
        
        update dept_xml_table
        set department = dx
        where current of c_dept;
    
    end loop;
    commit;
end;
/

select *
from dept_xml_table;

select *
from dept_json_view;

select doc_conv.json2xml(data)
from dept_json_view;

