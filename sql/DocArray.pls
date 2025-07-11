create or replace type DocArray under DocComponent (
    vals CompArray,

    constructor function DocArray return self as result,
    constructor function DocArray (eValue DocComponent) return self as result,
    constructor function DocArray (xDoc XMLType) return self as result,
    constructor function DocArray (jDoc JSON_ELEMENT_T) return self as result,

    member procedure addComponent(eValue DocComponent),
    member function getLength return integer,

    overriding member function getComponentType return integer,
    overriding member function toString(fmt integer, eName clob := null, aName clob := null) return clob   

);
/