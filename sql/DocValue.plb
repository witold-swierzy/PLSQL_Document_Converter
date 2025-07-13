create or replace type body DocValue 
as
    constructor function DocValue(val clob, vtype integer)   return self as result
    is
    begin
        compType := vtype;
        compVal  := AnyData.convertclob(val);
        return;
    end;

    member function getAsClob   return clob
    is
        cres clob;
        dres date;
        res  integer;
        
    begin
        res := compVal.getclob(cres);
        return cres;
    end;

    member function getAsNumber return number
    is
        cres clob;
        res  integer;
    begin
        res := compVal.getclob(cres);
        return to_number(cres);
    end;

    member function getAsDate   return date
    is
        cres clob;
        res  integer;
    begin
        res := compVal.getClob(cres);
        return to_date(cres);
    end;

    overriding member function getComponentType return integer
    is
    begin
        return doc_utl.comp_value;
    end;

    overriding member function toString(fmt integer, eName clob := null, aName clob := null) return clob
    is
        res clob;
        i   integer;
    begin
        i := compVal.getClob(res);
        if (fmt = doc_utl.fmt_json or fmt = doc_utl.fmt_json_doc)
        and compType in (doc_utl.type_string,doc_utl.type_date) then
            res := '"'||res||'"';
        end if;
        return res;
    end;
    
end;
/
