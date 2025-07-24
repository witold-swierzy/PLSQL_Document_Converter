create or replace type body DocElement as

    constructor function DocElement
    return self as result
    is
    begin
        XML_ARRAY_NAME      := doc_utl.get_param('XML_ARRAY_NAME');
        XML_ITEM_NAME       := doc_utl.get_param('XML_ITEM_NAME');
        XML_LIST_NAME       := doc_utl.get_param('XML_LIST_NAME');
        JSON_ATTR_NODE      := doc_utl.get_param('JSON_ATTR_NODE');
        JSON_COMMENT        := doc_utl.get_param('JSON_COMMENT');
        JSON_NS_NODE        := doc_utl.get_param('JSON_NS_NODE');
        IGNORE_XML_COMMENTS := doc_utl.get_param('IGNORE_XML_COMMENTS');
        KEEP_DOC_CONV_FMT   := doc_utl.get_param('KEEP_DOC_CONV_FMT');

        key := '';
        val := '';
        vtype := doc_utl.type_null;
        comments := '';

        elems := CompArray();
        attrs := AttrArray();
        array := CompArray();
        return;
    end;

    constructor function DocElement(xDoc XMLType) 
    return self as result
    is
        doc_type integer:= doc_utl.doc_type(xDoc);
        tval     clob;
        nDoc     DocElement;
    begin

        XML_ARRAY_NAME      := doc_utl.get_param('XML_ARRAY_NAME');
        XML_ITEM_NAME       := doc_utl.get_param('XML_ITEM_NAME');
        XML_LIST_NAME       := doc_utl.get_param('XML_LIST_NAME');
        JSON_ATTR_NODE      := doc_utl.get_param('JSON_ATTR_NODE');
        JSON_COMMENT        := doc_utl.get_param('JSON_COMMENT');
        JSON_NS_NODE        := doc_utl.get_param('JSON_NS_NODE');
        IGNORE_XML_COMMENTS := doc_utl.get_param('IGNORE_XML_COMMENTS');
        KEEP_DOC_CONV_FMT   := doc_utl.get_param('KEEP_DOC_CONV_FMT');

        key := '';
        val := '';
        vtype := doc_utl.type_null;
        comments := '';

        elems := CompArray();
        attrs := AttrArray();
        array := CompArray(); 

        -- comments
        if IGNORE_XML_COMMENTS = 'N' then
            SELECT EXTRACT(xDoc, '/node()/comment()').getStringVal()
	        into comments;
            comments := doc_utl.extractComments(comments);
        end if;
        -- namespaces
        -- attributes
        for r in (select * from xmltable('/node()/@*' passing  xDoc
                  columns node_name  clob path 'name()',
		          node_value clob path '.')) loop
            attrs.extend;
            attrs(attrs.count) := DocAttribute(r.node_name,r.node_value);                              
        end loop;

        -- components
        if doc_type=doc_utl.doc_simple then

            key := xDoc.getrootelement();
            select extractvalue(xDoc,'/node()')
            into val;

            vtype := doc_utl.val_type(val);
        elsif doc_type=doc_utl.doc_complex then
            if xDoc.getRootElement <> XML_LIST_NAME or KEEP_DOC_CONV_FMT = 'Y'  then
                key := xDoc.getRootElement();
            end if;

            for r in (select * from TABLE(XMLSEQUENCE(EXTRACT(xDoc,'/node()/*')))) loop
                elems.extend;
                elems(elems.count) := DocElement(r.column_value);
            end loop;

        elsif doc_type=doc_utl.doc_list then

            for r in (select * from TABLE(XMLSEQUENCE(EXTRACT(xDoc,'/*')))) loop
                elems.extend;
                if r.column_value.getRootElement <> XML_ITEM_NAME or KEEP_DOC_CONV_FMT = 'Y' then 
                    elems(elems.count) := DocElement(r.column_value); 
                else
                    nDoc := DocElement(r.column_value);
                    nDoc.key := '';
                    elems(elems.count) := nDoc;
                end if;
            end loop;

        elsif doc_type=doc_utl.doc_array then
            if xDoc.getRootElement <> XML_ARRAY_NAME or KEEP_DOC_CONV_FMT = 'Y' then
                key := xDoc.getrootelement();
            end if;

            for r in (select * from TABLE(XMLSEQUENCE(EXTRACT(xDoc,'/node()/*')))) loop   
                array.extend;
                if r.column_value.getRootElement <> XML_ITEM_NAME or KEEP_DOC_CONV_FMT = 'Y' then
                    array(array.count) := DocElement(r.column_value);
                else
                    nDoc := DocElement(r.column_value);
                    nDoc.key := '';
                    array(array.count) := nDoc;
                end if;
            end loop;           

        end if;    
        return;
    end;

    constructor function DocElement(jDoc JSON_ELEMENT_T)
    return self as result
    is
        doc_type integer; 
        jObj     JSON_OBJECT_T;
        njObj    JSON_OBJECT_T;
        jArr     JSON_ARRAY_T;
        nDoc     JSON_ELEMENT_T;
        jDoc2    JSON_ELEMENT_T;
        nVal     clob;
        jKeys    JSON_KEY_LIST;
        njKeys   JSON_KEY_LIST;
        nElem    DocElement;
    begin
        XML_ARRAY_NAME      := doc_utl.get_param('XML_ARRAY_NAME');
        XML_ITEM_NAME       := doc_utl.get_param('XML_ITEM_NAME');
        XML_LIST_NAME       := doc_utl.get_param('XML_LIST_NAME');
        JSON_ATTR_NODE      := doc_utl.get_param('JSON_ATTR_NODE');
        JSON_COMMENT        := doc_utl.get_param('JSON_COMMENT');
        JSON_NS_NODE        := doc_utl.get_param('JSON_NS_NODE');
        IGNORE_XML_COMMENTS := doc_utl.get_param('IGNORE_XML_COMMENTS');
        KEEP_DOC_CONV_FMT   := doc_utl.get_param('KEEP_DOC_CONV_FMT');

        key := '';
        val := '';
        vtype := doc_utl.type_null;
        jDoc2 := jDoc;
        comments := doc_utl.extractComments(jDoc2);
        doc_type := doc_utl.doc_type(jDoc2);

        elems := CompArray();
        attrs := AttrArray();
        array := CompArray();

        if doc_type = doc_utl.doc_value then
            val := jDoc2.to_Clob;
            vtype := doc_utl.val_type(val);
        elsif doc_type = doc_utl.doc_simple then
            jObj := JSON_OBJECT_T(jDoc2);
            jKeys := jObj.get_Keys;
            key := jKeys(1);
            val := jObj.get_Clob(jKeys(1));
            vtype := doc_utl.val_type(val);
        elsif doc_type = doc_utl.doc_complex then
            jObj := JSON_OBJECT_T(jDoc2);
            jKeys := jObj.get_Keys;
            key := jKeys(1);
            nDoc := jObj.get(key);
            jObj := JSON_OBJECT_T(nDoc);
            jKeys := jObj.get_Keys;
            for i in 1..jKeys.count loop
                nElem := DocElement(jObj.get(jKeys(i)));
                nElem.key := jKeys(i);
                elems.extend;
                elems(elems.count) := nElem;
            end loop;
        elsif doc_type = doc_utl.json_array then
            jArr := JSON_ARRAY_T(jDoc2);
            for i in 0..jArr.get_size-1 loop
                array.extend;
                array(array.count) := DocElement(jArr.get(i));
            end loop;

        elsif doc_type = doc_utl.doc_array then
            jObj := JSON_OBJECT_T(jDoc2);
            jKeys := jObj.get_Keys;
            key := jKeys(1);
            nDoc := jObj.get(jKeys(1));
            jArr := JSON_ARRAY_T(nDoc);
            for i in 0..jArr.get_size-1 loop
                array.extend;
                array(array.count) := DocElement(jArr.get(i));
            end loop;        

        elsif doc_type = doc_utl.doc_list then
            jObj := JSON_OBJECT_T(jDoc2);
            jKeys := jObj.get_Keys;
            for i in 1..jKeys.count loop 
                if jKeys(i) = JSON_ATTR_NODE and KEEP_DOC_CONV_FMT = 'N' then
                   nDoc := jObj.get(jKeys(i));
                   if nDoc.is_Object then
                      njObj := JSON_OBJECT_T(nDoc);
                      njKeys := njObj.get_Keys;
                      for j in 1..njKeys.count loop
                          attrs.extend;
                          attrs(attrs.count) := DocAttribute(njKeys(j),njObj.get_Clob(njKeys(j)));
                      end loop;
                   end if; 
                else
                   nDoc := jObj.get(jKeys(i));
                   if (not nDoc.is_Scalar) or nDoc.is_Number then
                       nVal := '{"'||jKeys(i)||'":'||nDoc.to_String||'}';
                    else
                       nVal := '{"'||jKeys(i)||'":'||nDoc.to_String||'}';
                    end if;
                    elems.extend;
                    elems(elems.count) := DocElement(JSON_ELEMENT_T.parse(nVal));
                end if;
            end loop;
        end if; 
        return;
    end;

    member function getElType return integer
    is
    begin
        if key is null 
        and val is null 
        and elems.count = 0 
        and array.count = 0 then
            return doc_utl.doc_empty;
        elsif key is null 
          and val is not null 
          and elems.count = 0 
          and array.count = 0 then
            return doc_utl.doc_value;
        elsif key is not null 
          and val is not null  
          and elems.count = 0 
          and array.count = 0 then
            return doc_utl.doc_simple;
        elsif key is not null 
          and val is null
          and elems.count > 0 
          and array.count = 0 then
            return doc_utl.doc_complex;
        elsif key is null 
          and val is null 
          and elems.count > 0 
          and array.count = 0 then
            return doc_utl.doc_list;
        elsif key is null
          and val is null 
          and elems.count = 0 
          and array.count > 0 then
            return doc_utl.json_array;
        elsif key is not null
          and val is null
          and elems.count = 0
          and array.count > 0
        then
            return doc_utl.doc_array;
        elsif key is not null
          and val is null
          and elems.count = 0
          and array.count = 0
        then
            return doc_utl.doc_empty_val;
        else
            return doc_utl.doc_unknown;
        end if;
    end;

    overriding member function getCompType return integer
    is
    begin
        return doc_utl.comp_element;
    end;

    overriding member function toString(fmt integer) return clob
    is
        xd XMLType;
        jd JSON_ELEMENT_T;
    begin
        if fmt = doc_utl.fmt_json then
            jd := getAsJSON;
            return jd.to_String;
        elsif fmt = doc_utl.fmt_xml then
            xd := getAsXML;
            return xd.getclobval;
        end if;
    end;

    member function getAsXML(add_def_tokens boolean := true) return XMLType
    is
        doc_type integer := getElType;
        res      clob := '';
        attrsc   clob := '';
        nel      XMLType;
    begin
        if hasAttrs then
            for i in 1..attrs.count loop
                attrsc := attrsc||' '||attrs(i).toString(doc_utl.fmt_xml);
            end loop;
        end if;

        if doc_type = doc_utl.doc_empty then
            return null;
        elsif doc_type = doc_utl.doc_empty_val then
            res := '<'||key||attrsc||'></'||key||'>';
        elsif doc_type = doc_utl.doc_value then
            res := '<'||XML_ITEM_NAME||'>'||getComments(doc_utl.fmt_xml)||val||'</'||XML_ITEM_NAME||'>';
        elsif doc_type = doc_utl.doc_simple then
            res := '<'||key||attrsc||'>'||getComments(doc_utl.fmt_xml)||val||'</'||key||'>';
        elsif doc_type = doc_utl.doc_complex then
            res := '<'||key||attrsc||'>'||getComments(doc_utl.fmt_xml);

            for i in 1..elems.count loop
                nel := treat(elems(i) as DocElement).getAsXML(false);
                res := res||nel.getclobval;
            end loop;

            res := res||'</'||key||'>';
        elsif doc_type = doc_utl.doc_array then
            res := '<'||key||attrsc||'>'||getComments(doc_utl.fmt_xml);

            for i in 1..array.count loop
                nel := treat(array(i) as DocElement).getAsXML(false);
                if instr(nel.getclobval,XML_ITEM_NAME) <> 0 then
                    res := res||nel.getclobval;
                else
                    res := res||'<'||XML_ITEM_NAME||'>'||nel.getclobval||'</'||XML_ITEM_NAME||'>';
                end if;
            end loop;

            res := res||'</'||key||'>';
        elsif doc_type = doc_utl.doc_list then
            if add_def_tokens then
                res := '<'||XML_LIST_NAME||'>';
            else
                res := '';
            end if;
            res := res ||getComments(doc_utl.fmt_xml);
            for i in 1..elems.count loop
                nel := treat(elems(i) as DocElement).getAsXML;                
                res := res||nel.getclobval;
            end loop;

            if add_def_tokens then
                res := res||'</'||XML_LIST_NAME||'>'; -- parameters needed (def list name, item name)
            end if;

        elsif doc_type = doc_utl.json_array then
            res := '<'||XML_ARRAY_NAME||'>'||getComments(doc_utl.fmt_xml);

            for i in 1..array.count loop
                nel := treat(array(i) as DocElement).getAsXML;
                if instr(nel.getclobval,XML_ITEM_NAME) <> 0 then
                    res := res||nel.getclobval;
                else
                    res := res||'<'||XML_ITEM_NAME||'>'||nel.getclobval||'</'||XML_ITEM_NAME||'>';
                end if;
            end loop;

            res := res||'</'||XML_ARRAY_NAME||'>'; -- parameters needed (def list name, item name)
        end if;
        return XMLType(res);
    end;

    member function getAsJSON(add_def_tokens boolean := true) return JSON_ELEMENT_T
    is
        doc_type integer := getElType;
        res      clob    := '';
        attrsc   clob    := '';
        tval     clob    := '';
        nJson    JSON_ELEMENT_T;
        nDoc     DocElement;
        ctype varchar2(2000);
    begin
        if hasAttrs then
            attrsc := '"'||JSON_ATTR_NODE||'":{';

            for i in 1..attrs.count loop
                if i > 1 then
                    attrsc := attrsc||',';
                end if;
                attrsc := attrsc||' '||attrs(i).toString(doc_utl.fmt_json); 
            end loop;
            attrsc := attrsc||'}';
        end if;

        if doc_type = doc_utl.doc_empty then
            return null;
        elsif doc_type = doc_utl.doc_empty_val then
            res := '{';
            if hasComments then
                res := res||getComments(doc_utl.fmt_json)||',';
            end if;
            res := res||'"'||key||'":null}';
        elsif doc_type = doc_utl.doc_value then
            if vtype <> doc_utl.type_number then
                res := '"'||val||'"';
            else
                res := val;
            end if;
        elsif doc_type = doc_utl.doc_simple then
            res := '{';
            if hasComments then
                res := res||getComments(doc_utl.fmt_json)||',';
            end if;
            if hasAttrs then
                res := res || attrsc||',';
            end if;
            res := res||'"'||key||'":';
            if doc_utl.val_type(val) <> doc_utl.type_number then
                tval := '"'||val||'"';
            else
                tval := val;
            end if;
            res := res || tval ||'}';
        elsif doc_type = doc_utl.doc_complex then
            res := '{';
            if hasComments then
                res := res||getComments(doc_utl.fmt_json)||',';
            end if;
            if hasAttrs then
                res := res || attrsc||',';
            end if;
            res := res||'"'||key||'":{';
            for i in 1..elems.count loop
                if i > 1 then
                    res := res ||',';
                end if;
                nJson := treat(elems(i) as DocElement).getAsJSON;
                tval := nJson.to_String;
                tval := substr(tval,2);
                tval := substr(tval,1,length(tval)-1);
                res := res||tval;
            end loop;
            res := res || '}}';
        elsif doc_type = doc_utl.doc_array then
            res := '{';
            if hasComments then
                res := res||getComments(doc_utl.fmt_json)||',';
            end if;
            if hasAttrs then
                res := res || attrsc||',';
            end if;
            res := res||'"'||key||'":[';
            for i in 1..array.count loop
                if i > 1 then
                    res := res ||',';
                end if;

                nDoc := treat(array(i) as DocElement);
                if nDoc.getElType <> doc_utl.doc_value then
                    nJson := nDoc.getAsJSON;
                    tval := nJSon.to_String;
                else
                    if nDoc.vtype <> doc_utl.type_number then
                        tval := '"'||nDoc.val||'"';
                    else
                        tval := '"'||nDoc.val||'"';
                    end if;
                end if;
                res := res||tval;
            end loop;

            res := res || ']}';
        elsif doc_type = doc_utl.doc_list then
            res := '{';
            if hasComments then
                res := res||getComments(doc_utl.fmt_json)||',';
            end if;
            for i in 1..elems.count loop
                if i > 1 then
                    res := res ||',';
                end if;
                nDoc := treat(elems(i) as DocElement);
                nJson := nDoc.getAsJSON;
                tval := nJson.to_String;
                tval := substr(tval,2);
                tval := substr(tval,1,length(tval)-1);
                res := res || tval;
            end loop;
            res := res||'}';
        elsif doc_type = doc_utl.json_array then
            res := '[';
            for i in 1..array.count loop
                if i > 1 then
                    res := res ||',';
                end if;

                nDoc := treat(array(i) as DocElement);
                if nDoc.getElType = doc_utl.doc_value then
                    if nDoc.vtype = doc_utl.type_number then
                        tval := nDoc.val;
                    else
                        tval := '"'||nDoc.val||'"';
                    end if;
                else
                    nJson := nDoc.getAsJSON;
                    tval := nJson.to_String;
                end if;
                res := res || tval;
            end loop;
            res := res||']';
        end if;
        return JSON_ELEMENT_T.parse(res);
    end;

    member function hasAttrs return boolean
    is
    begin
        if attrs.count > 0 then
            return true;
        end if;
        return false;
    end;

    member function hasComments return boolean
    is
    begin
        if comments is not null then
            return true;
        end if;
        return false;
    end;

    member function getComments(fmt integer) return clob
    is
    begin
        if fmt = doc_utl.fmt_xml and hasComments then
            return '<!--'||comments||'-->';
        elsif fmt = doc_utl.fmt_json and hasComments then
            return '"'||JSON_COMMENT||'":"'||comments||'"';
        end if;
        return '';
    end;
end;
/
