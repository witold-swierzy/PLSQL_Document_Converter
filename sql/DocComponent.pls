create or replace type DocComponent as object
( 
    id integer,
    not instantiable member function getComponentType return integer,
    not instantiable member function toString(fmt integer, eName clob := null, aName clob := null) return clob
)
not instantiable not final;
/
