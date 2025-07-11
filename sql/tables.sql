create table doc_params
( p_name varchar2(200) primary key,
  p_value varchar2(200) );

insert into doc_params values
( 'def_arr_name','array');

insert into doc_params values
( 'def_item_name','item');

insert into doc_params values
( 'def_root_name','root');

insert into doc_params values
( 'apply_def2json','N');

commit;

