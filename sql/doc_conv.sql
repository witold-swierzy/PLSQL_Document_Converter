drop table if exists doc_params;
drop type if exists DocArray;
drop type if exists DocElement;
drop type if exists DocValue;
drop type if exists KeyArray;
drop type if exists CompArray;
drop type if exists DocComponent;
drop package if exists doc_utl;

@tables.sql
@doc_utl.pls
@doc_utl.plb
@DocComponent.pls
@arrays.sql
@DocValue.pls
@DocElement.pls
@DocArray.pls
@DocValue.plb
@DocElement.plb
@DocArray.plb