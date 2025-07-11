create or replace type DocValue under DocComponent (
    compVal  AnyData,
    compType integer,

    constructor function DocValue(val clob, vtype integer)   return self as result,
  
    member function getAsClob   return clob,
    member function getAsNumber return number,
    member function getAsDate   return date,

    overriding member function getComponentType return integer,
    overriding member function toString(fmt integer, eName clob := null, aName clob := null) return clob
);
/