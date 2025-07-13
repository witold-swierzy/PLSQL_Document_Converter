create table doc_params
( p_name varchar2(200) primary key,
  p_value varchar2(200) );

insert into doc_params values
( 'DEF_ARR_NAME','array');

insert into doc_params values
( 'DEF_ITEM_NAME','item');

insert into doc_params values
( 'DEF_ROOT_NAME','root');

insert into doc_params values
( 'APPLY_DEF2JSON','N');

insert into doc_params values
( 'XML_ATTR_FORMAT','doc_conv@%element%@%attribute%');

insert into doc_params values
( 'XML_ATTR_PREFIX','xml_attribute' );

commit;

