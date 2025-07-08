create or replace package doc_conv_utils
is
    function is_number    (val varchar2) return boolean;
    function is_date      (val varchar2) return boolean;
    function is_primitive (val XMLType) return boolean;
end;
/

create or replace package body doc_conv_utils
is
    function is_number(val varchar2) return boolean
    is
    begin
        declare 
            x number(38);
        begin
            x := to_number(val);
        exception
            when others then
                return false;
        end;
        return true;
    end;
    
    function is_date(val varchar2) return boolean
    is
    begin
        declare
            x date;
        begin
            x := to_date(val);
        exception
            when others then 
                return false;
        end;
        return true;
    end;
    
    function is_primitive (val XMLType) return boolean
    is
    	r_element clob       := val.getrootelement();
    	subnode   number(10) := val.existsnode(r_element||'/*');
    begin
    	if subnode > 0 then
    		return false;
    	else
    		return true;
    	end if;
    end;
end;
/
