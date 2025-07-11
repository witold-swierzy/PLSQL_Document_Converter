create or replace type DocElement under DocComponent (
    keys KeyArray,
    vals CompArray,

    constructor function DocElement return self as result,
    constructor function DocElement(kName clob, kValue DocComponent) return self as result,
    constructor function DocElement(xDoc XMLType) return self as result,
    constructor function DocElement(jDoc JSON_ELEMENT_T) return self as result,
    
    member procedure addComponent(kName clob,kValue DocComponent),
    member function getLength return integer,
    
    member function getAsXML  (rName clob := null, eName clob := null, aName clob := null) return XMLType,
    member function getAsJSON (rName clob := null, eName clob := null, aName clob := null) return JSON_ELEMENT_T,

    overriding member function getComponentType return integer,
    overriding member function toString(fmt integer, eName clob := null, aName clob := null) return clob 
);
/