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

@doc_conv_consts.sql
@doc_conv_utils.sql

@DocComponent.pls
@DocValue.pls
@DocElement.pls
@DocPrimitiveElement.pls
@DocArrayElement.pls
@DocDocumentElement.pls

@DocComponentArray.sql

@DocValue.plb
@DocElement.plb
@DocPrimitiveElement.plb
@DocArrayElement.plb
@DocDocumentElement.plb