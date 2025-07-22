drop table if exists doc_params;

create table doc_params
( p_name varchar2(200) primary key,
  p_value varchar2(200) );

insert into doc_params values
( 'XML_ARRAY_NAME','__doc_conv_array');

insert into doc_params values
( 'XML_ITEM_NAME','__doc_conv_item');

insert into doc_params values
( 'XML_LIST_NAME','__doc_conv_list');

insert into doc_params values
( 'JSON_ATTR_NODE','__doc_conv_attributes');

insert into doc_params values
( 'JSON_NS_NODE','__doc_conv_namespaces');

insert into doc_params values
( 'KEEP_DOC_CONV_FMT','N');

commit;

