function[M,sz] =  findMax(file);

M = 0;
FP = fopen(file);
sz = 0;
while ~feof(FP)

    sz = sz + 1;
lineStr = fgets(FP);

clear A;

A = sscanf(lineStr,'%lu');
maxm = max(A);
if maxm > M
    M = maxm;
end

end

fclose(FP);

