-- component : demonstration code
-- type      : anonymous PL/SQL block
-- author    : witold.swierzy@oracle.com

declare
	doc1 DocPrimitiveElement := DocPrimitiveElement('alice','has_cats');
	doc2 DocPrimitiveElement := DocPrimitiveElement('how_many_cats',14);
	doc3 DocPrimitiveElement := DocPrimitiveElement('today',sysdate);
	doc4 DocArrayElement     := DocArrayElement('nested_array01',DocValue('abra1'));
	doc5 DocArrayElement     := DocArrayElement('nested_array02',DocValue('abra2'));
	doc6 DocArrayElement;
	doc7 DocDocumentElement := DocDocumentElement;
begin
	doc4.addComponent(DocValue('kadabra1'));
	doc4.addComponent(DocValue('1231'));
	doc5.addComponent(DocValue('kadabra2'));
	doc5.addComponent(DocValue('1232'));
	doc6 := DocArrayElement('array_of_arrays',doc4);
	doc6.addComponent(doc5); 
	doc7.addElement(doc1);
	doc7.addElement(doc2);
	doc7.addElement(doc5);
	doc7.addElement(doc6);
	dbms_output.put_line(doc7.toString);	
end;
/