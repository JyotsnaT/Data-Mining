function trans = fileRead(file)

FP = fopen(file);
i = 0;

while ~feof(FP)

    i = i + 1;
lineStr = fgets(FP);
trans{i} = lineStr;




end

fclose(FP);

end
