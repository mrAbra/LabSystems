function [ovsf_code] = wcdma_ovsf_generator(ovsf_num, sf)

    %% Definition of current parameters
    % Number of iterations
    level = log2(sf);
    
    % OVSF code initial value
    ovsf_code = zeros(1, sf);
    ovsf_code(1) = 1;
    
    % OVSF code length
    ovsf_code_size = 1;
    
    % The first row number of the OVSF code table
    first = 1;
    % The last row number of the OVSF code table
    last = sf;

    %% Code definition
    for j = 1 : level
        
        % The centre row number of the OVSF code table
        centre = (first + last - 1) / 2;
        
        if ((ovsf_num + 1) <= centre)
            ovsf_code(ovsf_code_size + 1 : 2 * ovsf_code_size) =  ovsf_code(1 : ovsf_code_size);
            last = centre;
        else
            ovsf_code(ovsf_code_size + 1 : 2 * ovsf_code_size) = -ovsf_code(1 : ovsf_code_size);
            first = centre + 1;
        end
        
        ovsf_code_size = ovsf_code_size * 2;

    end

end


