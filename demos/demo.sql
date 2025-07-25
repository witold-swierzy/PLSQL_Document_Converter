-- requirements: EMPLOYEES_COL JSON COLLECTION must be created.

-- conversion function creation
create or replace function xml2json(xDoc XMLType) return json
is
    j JSON_ELEMENT_T := DocElement(xDoc).getAsJSON;
begin
    return JSON(j.to_Clob);
end;
/

create or replace function json2xml(doc JSON) return XMLType
is
    jc clob;
    jd JSON_ELEMENT_T;
    ed DocElement;
begin
    select json_serialize(doc)
    into jc;

    jd := JSON_ELEMENT_T.parse(jc);
    ed := DocElement(jd);

    return ed.getAsXML;
end;
/

-- 1. conversion from JSON to XML

create table employees_xml of XMLType;

insert into employees_xml
select json2xml(c.data)
from employees_col c;

commit;

-- 2. querying XML data
select *
form employees_xml;

-- 3. conversion from XML to JSON
select xml2json(value(e)) json_col, value(e) xml_col
from emp_xml_view e;


create or replace json collection view json_v
as 
select xml2json(value(e)) data
from employees_xml e;

select *
from json_v

-- mongosh
db.json_v.find()

-----
-- requirements: HR sample schema
CREATE OR REPLACE VIEW emp_xml_view OF XMLType
  WITH OBJECT ID (XMLCast(XMLQuery('/Emp/employee_id'
                                   PASSING OBJECT_VALUE RETURNING CONTENT)
                          AS BINARY_DOUBLE)) AS
  SELECT XMLElement("Emp",
                    XMLForest( e.employee_id AS "employee_id",
                    		   e.first_name AS "first_name",
                               e.last_name AS "last_name",
                               e.hire_date AS "hiredate"))
  AS "result" FROM hr.employees e;
    
SELECT * FROM emp_xml_view;

select xml2json(value(e)) json_col
from emp_xml_view e;

create or replace json collection view emp_json_view
as
select xml2json(value(e)) data
from emp_xml_view e;

select *
from emp_json_view;

select *
from emp_json_v01;


mongosh :
db.emp_json_view.find()

select json2xml(json(json_serialize(JSON{*})))
      from hr.employees;
      
      
      {"PHONE_NUMBER":"1.515.555.0171",
       "JOB_ID":"AC_ACCOUNT",
       "SALARY":8300,
       "COMMISSION_PCT":null,
       "FIRST_NAME":"William",
       "EMPLOYEE_ID":206,
       "EMAIL":"WGIETZ","LAST_NAME":"Gietz","MANAGER_ID":205,"DEPARTMENT_ID":110,"HIRE_DATE":"2012-06-07T00:00:00"}
 
