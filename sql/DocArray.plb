create or replace type body DocArray
as
    constructor function DocArray return self as result
    is
    begin
        vals := CompArray();
        return;
    end;
    
    constructor function DocArray (eValue DocComponent) return self as result
    is
    begin
        vals := CompArray(eValue);
        return;
    end;
    
    constructor function DocArray(xDoc XMLType) return self as result
    is
    begin
        vals := CompArray();
        for r in (select * from TABLE(XMLSEQUENCE(EXTRACT(xDoc,'/node()/*')))) loop
            vals.extend;
            vals(vals.count) := DocElement(r.column_value);
        end loop;
        return;
    end;
    
    constructor function DocArray(jDoc JSON_ELEMENT_T) return self as result
    is
        jClob  clob;
        jArr   JSON_ARRAY_T := JSON_ARRAY_T(jDoc);
        jElem  JSON_ELEMENT_T;
        l      number(38) := jArr.get_Size;
    begin
        vals := CompArray();
        for i in 0..l-1 loop
            vals.extend;
            jElem := jArr.get(i);
            if jElem.is_object then
                vals(vals.count) := DocElement(jElem);
            elsif jElem.is_array then
                vals(vals.count) := DocArray(jElem);
            elsif jElem.is_scalar then
                jClob := jElem.to_Clob;
                vals(vals.count) := DocValue(jClob,doc_utl.scalar_type(jClob));
            end if;
        end loop;
        return;
    end;

    member procedure addComponent(eValue DocComponent)
    is
    begin
        vals.extend;
        vals(vals.count) := eValue;
    end;
    
    member function getLength return integer
    is
    begin
        return vals.count;
    end;

    overriding member function getComponentType return integer
    is
    begin
        return doc_utl.comp_array;
    end;
    
    overriding member function toString(fmt integer, eName clob := null, aName clob := null) return clob   
    is
        res  clob;
        elem clob;
    begin
        -- json : [....]
        -- xml  : <item>...</item><item>...</item>
        if fmt = doc_utl.fmt_json or fmt = doc_utl.fmt_json_doc then
            if aName is not null then
                res := '{"'||aName||'":[';
            elsif doc_utl.get_parameter('APPLY_DEF2JSON') = 'Y' then
                res := '{"'||doc_utl.get_parameter('DEF_ARR_NAME')||'":[';
            else
                res := '[';
            end if;
            for i in 1..vals.count loop
                if i > 1 then
                    res := res||',';
                end if;
                if eName is not null then
                   res := res ||'{"'
                              ||eName
                              ||'":'
                              ||vals(i).toString(doc_utl.fmt_json_doc,eName,aName)
                              ||'}';
                elsif doc_utl.get_parameter('APPLY_DEF2JSON') = 'Y' then
                   res := res ||'{"'
                              ||doc_utl.get_parameter('DEF_ITEM_NAME')
                              ||'":'
                              ||vals(i).toString(doc_utl.fmt_json_doc,eName,aName)
                              ||'}';
                else
                    res := res||vals(i).toString(doc_utl.fmt_json_doc,eName,aName);
                end if;
            end loop;
            if aName is not null or doc_utl.get_parameter('APPLY_DEF2JSON') = 'Y' then
                res := res || ']}';
            else
                res := res || ']';
            end if;
        elsif fmt = doc_utl.fmt_xml then
            if aName is not null then
                res := '<'||aName||'>';
            else
                res := '<'||doc_utl.get_parameter('DEF_ARR_NAME')||'>';
            end if;
            for i in 1..vals.count loop
                if eName is not null then
                    res := res || '<'||eName||'>';
                else
                    res := res || '<'||doc_utl.get_parameter('DEF_ITEM_NAME')||'>';
                end if;
                res := res||vals(i).toString(fmt,eName,aName);
                if eName is not null then
                    res := res || '</'||eName||'>';
                else
                    res := res || '</'||doc_utl.get_parameter('DEF_ITEM_NAME')||'>';
                end if;
            end loop;
            if aName is not null then
                res := res || '</'||aName||'>';
            else
                res := res || '</'||doc_utl.get_parameter('DEF_ARR_NAME')||'>';
            end if;            
        end if;
        return res;
    end;
end;
/

