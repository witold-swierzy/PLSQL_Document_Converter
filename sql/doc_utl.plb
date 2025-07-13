create or replace package body doc_utl
is
    procedure set_parameter(p_param integer, p_val varchar2)
    is
        v_name varchar2(200);
    begin
        v_name := upper(trim(' ' from p_param));
        
        if (param_table.exists(v_name)) then
            param_table(v_name) := p_val;
            
            update doc_params
            set p_value = p_val
            where p_name = v_name;

            commit;
        end if;
    end;

    function  get_parameter(p_param varchar2) return varchar2
    is
    begin
        return param_table(upper(trim(' ' from p_param)));
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
            return type_number;
        exception
            when others then null;
        end;
        
        declare
            vd date;
        begin
            vd := to_date(val);
            return type_date;
        exception
            when others then null;
        end;        
        
        if upper(trim(' ' from val)) = 'TRUE'
        or upper(trim(' ' from val)) = 'FALSE' then
            return type_bool;
        end if;

        return type_string;
        
    end;
    
begin
    for r in (select * from doc_params) loop
        param_table(r.p_name) := r.p_value;
    end loop;
end;
/