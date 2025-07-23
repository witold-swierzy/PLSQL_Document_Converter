create or replace procedure test
is
    xd XMLType;-- := XMLType
    --(
      --  '<a attra="vala" attrb="valb"><b>abra1</b><bb><c>abra2</c></bb><d><e>abra3</e></d></a>'
    --);

    jd JSON_ELEMENT_T := JSON_ELEMENT_T.parse('{"a":"vala","b":{"valb1":"valb2"},"c":"valc"}');

    ed DocElement; 
    ned DocElement;
    dt integer;
    dtn varchar2(200);
begin
    dt := doc_utl.doc_type(jd);
    dtn := doc_utl.doc_types(dt);
    dbms_output.put_line('jd type : '||dtn);

    ed := DocElement(jd);

    dt := ed.getElType;
    dtn := doc_utl.doc_types(dt);
    xd := ed.getAsXML;
    jd := ed.getAsJSON;
    dbms_output.put_line('after xml  #1 : '||xd.getclobval);
    dbms_output.put_line('after json #1 : '||jd.to_String);
    ed := DocElement(xd);
    xd := ed.getAsXML;
    jd := ed.getAsJSON;
    dbms_output.put_line('after xml  #2 : '||xd.getclobval);
    dbms_output.put_line('after json #2 : '||jd.to_String);

end;