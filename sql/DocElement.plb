create or replace type body DocElement
as
    constructor function DocElement return self as result
    is
    begin
        keys := KeyArray();
        vals := CompArray();
        return;
    end;

    constructor function DocElement(kName clob, kValue DocComponent) return self as result
    is
    begin
        keys := KeyArray(kName);
        vals := CompArray(kValue);
        return;
    end;

    constructor function DocElement(xDoc XMLType) return self as result
    is
        doc_type  integer;
        frag_type integer;
        doc_val   clob;
        frag_val  clob;
        doc_xml   XMLType;
        doc_name  clob;
    begin
        keys := keyArray();
        vals := compArray();

        doc_type := doc_utl.doc_type(xDoc);
        
        if doc_type = doc_utl.xml_value then
            keys.extend;
            vals.extend;
            doc_name := xDoc.getrootelement();
            select extractvalue(xDoc,'/node()')
            into doc_val;
            keys(keys.count) := doc_name;
            vals(vals.count) := DocValue(doc_val,doc_utl.scalar_type(doc_val));
        elsif doc_type = doc_utl.xml_fragment then
            for r in (select * from TABLE(XMLSEQUENCE(EXTRACT(xDoc,'/*')))) loop
                keys.extend;
                vals.extend;
                keys(keys.count) := r.column_value.getrootelement;
                frag_type := doc_utl.doc_type(r.column_value);
                if frag_type = doc_utl.xml_value then
                        select extractvalue(r.column_value,'/node()')
                        into frag_val;
                        vals(vals.count) := DocValue(frag_val,doc_utl.scalar_type(frag_val));
                elsif frag_type = doc_utl.xml_document then
                        vals(vals.count) := DocElement(r.column_value);
                end if;
            end loop;
        elsif doc_type = doc_utl.xml_array then
            keys.extend;
            vals.extend;
            keys(keys.count) := xDoc.getrootelement();
            vals(vals.count) := DocArray(xDoc);
        elsif doc_type = doc_utl.xml_document then
            for r in (select * from xmltable('/*' 
                                        passing  xDoc
                                        columns 
                                          node_name  clob path 'name()',
				                          node_value xmltype path 'node()')) loop
                keys.extend;
                vals.extend;
                keys(keys.count) := r.node_name;
                vals(vals.count) := DocElement(r.node_value);
            end loop;
        end if;
        
        return;
    end;

    constructor function DocElement(jDoc JSON_ELEMENT_T) return self as result
    is
       jClob  clob;
       jObj   JSON_OBJECT_T := JSON_OBJECT_T(jDoc);
       jElem  JSON_ELEMENT_T;
       jKeys  JSON_KEY_LIST;
    begin
       keys := KeyArray();
       vals := CompArray();
       jKeys := jObj.get_keys;
            
       for i in jKeys.first..jKeys.last loop
            keys.extend;
            vals.extend;
            jElem := jObj.get(jKeys(i));
            if jElem.is_object then
                keys(keys.count) := jKeys(i);
                vals(vals.count) := DocElement(jElem);
            elsif jElem.is_array then
                keys(keys.count) := jKeys(i);
                vals(vals.count) := DocArray(jElem);
            elsif jElem.is_scalar then
                keys(keys.count) := jKeys(i);
                jClob := jElem.to_Clob;
                vals(vals.count) := DocValue(jClob,doc_utl.scalar_type(jClob));
            end if;
       end loop;
       return;
    end;

    member procedure addComponent(kName clob,kValue DocComponent)
    is
    begin
        keys.extend;
        vals.extend;
        keys(keys.count) := kName;
        vals(vals.count) := kValue;
    end;

    member function getLength return integer
    is
    begin
        return keys.count;
    end;
    
    member function getAsXML  (rName clob := null, eName clob := null, aName clob := null) return XMLType
    is
        res clob := toString(doc_utl.fmt_xml,aName,eName);
    begin
        if rName is not null then
            res := '<'||rName||'>'||res||'</'||rName||'>';
        else
            res := '<'||doc_utl.def_root_name||'>'||res||'</'||doc_utl.def_root_name||'>';
        end if;
        return XMLType(res);
    end;

    member function getAsJSON (rName clob := null, eName clob := null, aName clob := null) return JSON_ELEMENT_T
    is
        res clob := toString(doc_utl.fmt_json_doc,aName,eName);
    begin
        if rName is not null then
            res := '{"'||rName||'":'||res||'}';
        elsif doc_utl.apply_def2json then
            res := '{"'||doc_utl.def_root_name||'":'||res||'}';
        end if;
        return JSON_ELEMENT_T.parse(res);
    end;

    overriding member function getComponentType return integer
    is
    begin
        return doc_utl.comp_element;
    end;

    overriding member function toString(fmt integer, eName clob := null, aName clob := null) return clob
    is
        res   clob := '';
    begin
        if fmt = doc_utl.fmt_json or fmt = doc_utl.fmt_json_doc then 
            for i in 1..keys.count loop
                if i > 1 then
                    res := res || ',';
                end if;              
                res := res || '"'||keys(i)||'":'||vals(i).toString(doc_utl.fmt_json_doc,eName,aName);
            end loop;
            if fmt = doc_utl.fmt_json_doc then
                res := '{'||res||'}';
            end if;
        elsif fmt = doc_utl.fmt_xml then
            for i in 1..keys.count loop
                res := res||'<'||keys(i)||'>'
                          ||vals(i).toString(doc_utl.fmt_xml,eName,aName)
                          ||'</'||keys(i)||'>';
            end loop;
        end if;
        return res;
    end;
end;
/