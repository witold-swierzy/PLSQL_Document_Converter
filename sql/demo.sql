-- component : demonstration code
-- type      : anonymous PL/SQL block
-- author    : witold.swierzy@oracle.com

declare
	val1 DocValue := DocValue(123);
	val2 DocValue := DocValue(345);
	doc1 DocPrimitiveElement := DocPrimitiveElement('alice','has_cats');
	doc2 DocPrimitiveElement := DocPrimitiveElement('how_many_cats',14);
	doc3 DocPrimitiveElement := DocPrimitiveElement('today',sysdate);
	doc4 DocArrayElement     := DocArrayElement('array01');
	doc5 DocArrayElement     := DocArrayElement('array02');
	doc6 DocDocumentElement  := DocDocumentElement('Document01');
	t json_element_t;
	x XMLType;
begin
	--dbms_output.put_line(doc1.toString(doc_conv_consts.fmt_json));
	--dbms_output.put_line(doc1.toString(doc_conv_consts.fmt_json_primitive));
	--doc4.addComponent(doc1);
	--doc4.addComponent(doc2);
	--doc4.addComponent(doc3);
	--dbms_output.put_line(doc4.toString(doc_conv_consts.fmt_json));
	--dbms_output.put_line(doc4.toString(doc_conv_consts.fmt_xml));
	--t := doc4.getAsJSON_ELEMENT_T;
	--x := doc4.getAsXMLType;
	--dbms_output.put_line(t.to_String);
	--dbms_output.put_line(x.getclobval);
	--dbms_output.put_line(doc1.toString(doc_conv_consts.fmt_json));
	--dbms_output.put_line(doc1.toString(doc_conv_consts.fmt_json_primitive));
	--doc5.addComponent(val1);
	--doc5.addComponent(val2);
	doc6.addElement(doc1);
	doc6.addElement(doc2);
	dbms_output.put_line(doc6.tostring(doc_conv_consts.fmt_json));
	dbms_output.put_line(doc6.tostring(doc_conv_consts.fmt_xml));
end;
/