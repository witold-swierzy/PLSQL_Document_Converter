create or replace package body doc_utl
is
    procedure set_parameter(p_param integer, p_val varchar2)
    is
        v_name varchar2(200);
    begin
        if p_param = p_def_arr_name then
            v_name := 'def_arr_name';
        elsif p_param = p_def_item_name then
            v_name := 'def_item_name';
        elsif p_param = p_def_root_name then
            v_name := 'def_root_name';
        elsif p_param = p_apply_def2json then
            v_name := 'apply_def2json';
        end if;
        update doc_params
        set p_value = p_val
        where p_name = v_name;

        commit;
    end;

    function  doc_type     (doc XMLType)  return number
    is
        root       clob := doc.getRootElement;
        n_nodes    number(38);
        n_name     clob := '';
        n_old_name clob := '';
        i          integer := 0;
    begin
        if root is null then
            return xml_fragment;
        end if;
        
        select count(*)
        into n_nodes
        from (select * 
              from table(XMLSEQUENCE(EXTRACT(doc,'/node()/*'))));
        
        if n_nodes = 0 then
            return xml_value;
        end if;
        
        for r in (select * 
                  from TABLE(XMLSEQUENCE(EXTRACT(doc,'/node()/*')))) loop
            n_name := r.column_value.getrootelement;    
            if i = 0 then
                n_old_name := n_name;
            elsif n_name <> n_old_name then
                return xml_document;
            end if;
            i := i+1;
        end loop;
        if i = 1 then
            return xml_document;
        end if;
        return xml_array;
    end;
    
    function  scalar_type  (val clob) return number
    is
    begin
        declare
            vn number(38);
        begin
            vn := to_number(val);
            return DBMS_TYPES.TYPECODE_NUMBER;
        exception
            when others then null;
        end;
        
        declare
            vd date;
        begin
            vd := to_date(val);
            return DBMS_TYPES.TYPECODE_DATE;
        exception
            when others then null;
        end;        
        
        return DBMS_TYPES.TYPECODE_VARCHAR2;
        
    end;
    
begin
    for r in (select * from doc_params) loop
        if r.p_name = 'def_arr_name' then
            def_arr_name := r.p_value;
        elsif r.p_name = 'def_item_name' then
            def_item_name := r.p_value;
        elsif r.p_name = 'def_root_name' then
            def_root_name := r.p_value;
        elsif r.p_name = 'apply_def2json' then
            if r.p_value = 'N' then
                apply_def2json := false;
            elsif r.p_value = 'Y' then
                apply_def2json := true;
            end if;
        end if;
    end loop;
end;
/