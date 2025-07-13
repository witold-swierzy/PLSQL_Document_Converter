-- 1 DocValue
declare
    v1 DocValue := DocValue('text',doc_utl.type_string);
    v2 DocValue := DocValue(to_char(sysdate),doc_utl.type_date);
    v3 DocValue := DocValue('100',doc_utl.type_number);
begin
    dbms_output.put_line(v1.toString(doc_utl.fmt_json));
    dbms_output.put_line(v2.toString(doc_utl.fmt_json));
    dbms_output.put_line(v3.toString(doc_utl.fmt_json));
end;
/

-- 2. DocElement
declare
    v1 DocValue := DocValue('text',doc_utl.type_string);
    v2 DocValue := DocValue(to_char(sysdate),doc_utl_type_date);
    v3 DocValue := DocValue('100',doc_utl.type_number);
    d1 DocElement;
    d2 DocElement;
    d3 DocElement;
    j1 JSON_ELEMENT_T;
    x1 XMLType;
begin
    d1 := DocElement('el01',v1);
    d1.addComponent('el02',v2); 
    d2 := DocElement('el03',v3);
    d1.addComponent('d2',d2);  
    dbms_output.put_line(d1.toString(doc_utl.fmt_xml));
    x1 := d1.getAsXML;
    dbms_output.put_line(x1.getclobval);
    j1 := d1.getAsJSON;
    dbms_output.put_line(j1.to_String);
end;
/   

-- 3.DocArray
declare 
    v1 DocValue := DocValue('text',doc_utl.type_string);
    v2 DocValue := DocValue(to_char(sysdate),doc_utl.type_date);
    a1 DocArray := DocArray();
    a2 DocArray := DocArray();
    d1 DocElement := DocElement();
begin
    a1.addComponent(v1);
    a1.addComponent(v2);
    a2.addComponent(v1);
    a2.addComponent(v2);
    dbms_output.put_line(a1.toString(doc_utl.fmt_xml));
    d1.addComponent('v1',v1);
    d1.addComponent('v2',v2);
    a1.addComponent(d1);
    a1.addComponent(a2);
    dbms_output.put_line(a1.toString(doc_utl.fmt_xml));
    --d1.addComponent('a1',a1);
    --dbms_output.put_line(d1.toString(doc_utl.fmt_json,'abra','kadabra'));
    --dbms_output.put_line(a1.toString(doc_utl.fmt_json_doc,'item','atem'));
    --dbms_output.put_line(a1.toString(doc_utl.fmt_json,'abra','kadabra'));
end;
/

-- 4. xml type
declare
    d1 DocElement := DocElement();
    v1 DocValue := DocValue('text',doc_utl.type_string);
    v2 DocValue := DocValue(to_char(sysdate),doc_utl.type_date);
    x1 XMLType;
    xml_type integer;
begin
    d1.addComponent('v1',v1);
    d1.addComponent('v1',v2);
    
    --x1 := d1.getAsXML;    
    x1 := XMLType('<a>aaa</a>');

    dbms_output.put_line(x1.getclobval);

    xml_type := doc_utl.doc_type(x1);

    if xml_type = doc_utl.xml_value then
        dbms_output.put_line('XML_VALUE : '||xml_type);
    elsif xml_type = doc_utl.xml_fragment then
        dbms_output.put_line('XML_FRAGMENT : '||xml_type);
    elsif xml_type = doc_utl.xml_array then
        dbms_output.put_line('XML_ARRAY : '||xml_type);
    elsif xml_type = doc_utl.xml_document then
        dbms_output.put_line('XML_DOCUMENT : '||xml_type);
    else
        dbms_output.put_line('UNKNOWN : '||xml_type);
    end if;
end;
/

-- 5 scalar_type function from doc_utl package

declare
    type tc is table of clob index by binary_integer;

    vc tc;
    ti integer;
begin
    vc(1) := to_char(sysdate);
    vc(2) := to_char(123.12);
    vc(3) := 'abc';

    for i in 1..3 loop
        ti := doc_utl.scalar_type(vc(i));
        if ti = doc_utl.type_strin then
            dbms_output.put_line(vc(i)||' : varchar2');
        elsif ti = doc_utl.type_number then
            dbms_output.put_line(vc(i)||' : number');
        elsif ti = doc_utl.type_date then
            dbms_output.put_line(vc(i)||' : date');
        end if;
    end loop;
end;
/
            

-- 6. DocElement XMLType constructor
declare
    x1 XMLType;
    e1 DocElement;
    j1 JSON_ELEMENT_T;
begin
    x1 := XMLType(
'<kadabra>
    <abra1>aaa</abra1>
    <abra2><nabra2>bbb</nabra2></abra2>
</kadabra>');
    e1 := DocElement(x1);
    j1 := e1.getAsJSON;
    dbms_output.put_line(e1.toString(doc_utl.fmt_json_doc));
    dbms_output.put_line(j1.to_String);
end;
/

-- 7 ArrayElement XMLType constructor
declare
    x1 XMLType;
    e1 DocElement;
    j1 JSON_ELEMENT_T;
begin
    x1 := XMLType(
'<kadabra>
    <abra1>aaa</abra1>
    <abra1>bbb</abra1>
    <abra1>ccc</abra1>
</kadabra>');
    e1 := DocElement(x1);
    j1 := e1.getAsJSON;
    dbms_output.put_line(e1.toString(doc_utl.fmt_json_doc));
    dbms_output.put_line(j1.to_String);
end;
/

-- 8. DocElement JSON_ELEMENT_T constructor
declare
    j1 JSON_ELEMENT_T := JSON_ELEMENT_T.parse('{"abra1":"kadabra","abra2":{"nabra2":"kadabra2"},"abra3":["arr1","arr2"]}');
    d1 DocElement := DocElement(j1);
    x1 XMLType := d1.getAsXML;
begin
    dbms_output.put_line(x1.getclobval);
    d1 := DocElement(x1);
    j1 := d1.getAsJSON;
    dbms_output.put_line(j1.to_String);
end;
/

-- 9. attributes
