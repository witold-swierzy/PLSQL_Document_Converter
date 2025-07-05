-- component : main script recreating Document Converter
-- type      : SQL script
-- author    : witold.swierzy@oracle.com

drop type if exists DocDocumentElement;
drop type if exists DocArrayElement; 
drop type if exists DocPrimitiveElement;
drop type if exists DocElement;
drop type if exists DocValue;
drop type if exists DocComponentArray;	
drop type if exists DocComponent;

@DocComponent.sql
@DocValue.sql
@DocElement.sql
@DocPrimitiveElement.sql
@DocArrayElement.sql
@DocDocumentElement.sql
