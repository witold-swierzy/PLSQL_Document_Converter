create or replace type DocElement under DocComponent (
    
    XML_ARRAY_NAME    varchar2(2000),
    XML_ITEM_NAME     varchar2(2000),
    XML_LIST_NAME     varchar2(2000),
    JSON_ATTR_NODE    varchar2(2000),
    JSON_NS_NODE      varchar2(2000),
    KEEP_DOC_CONV_FMT varchar2(2000),

    key   clob,
    val   clob,
    vtype integer,
    elems CompArray,
    attrs AttrArray,
    array CompArray,
    xns clob,
    xsd clob,
 
    constructor function DocElement
    return self as result,

    constructor function DocElement(xDoc XMLType) 
    return self as result,
    
    constructor function DocElement(jDoc JSON_ELEMENT_T)
    return self as result,

    member function getElType return integer,
    member function getAsXML  (add_def_tokens boolean := true) return XMLType,
    member function getAsJSON (add_def_tokens boolean := true) return JSON_ELEMENT_T,
    member function hasAttrs return boolean,

    overriding member function getCompType return integer,
    overriding member function toString(fmt integer) return clob
    
);
/
