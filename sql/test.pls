create or replace procedure test
is
    xd XMLType := XMLType
    (
        '<a attra="vala" attrb="valb"><b>abra1</b><bb><c>abra2</c></bb><d><e>abra3</e></d></a>'
    );

    jd JSON_ELEMENT_T := JSON_ELEMENT_T.parse('["a",{"b":{"ala":"eee"}},"c"]');

    ed DocElement; 
    ned DocElement;
    dt integer;
    dtn varchar2(200);
begin
    dt := doc_utl.doc_type(xd);
    dtn := doc_utl.doc_types(dt);
    dbms_output.put_line('xd type : '||dtn);

    ed := DocElement(xd);

    dt := ed.getElType;
    dtn := doc_utl.doc_types(dt);
    xd := ed.getAsXML;
    jd := ed.getAsJSON;
    dbms_output.put_line('after xml  : '||xd.getclobval);
    dbms_output.put_line('after json : '||jd.to_String);
end;