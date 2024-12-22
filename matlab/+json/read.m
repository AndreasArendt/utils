function jdata = read(jpath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
            
    fid = fopen(jpath);

    c = onCleanup(@()fclose(fid));

    jfile = fscanf(fid, '%s');    
    jdata = jsondecode(jfile);
end