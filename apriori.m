%% laoding dataset
disp('Loading dataset');
[mx , sz] = findMax('retail.dat');
A = fileRead('retail.dat');

% SUPPORT
Sup = 0.1*sz;

%% Creating C1 candidate set
disp('creating frequent 1-itemsets');

C1 = zeros(mx+1,1);
for i = 1:sz
    l = sscanf(A{i},'%lu');
    for k = 1:size(l)
        a = l(k);
        C1(a + 1) = C1(a + 1) + 1;
    end
    clear l ;     
end
        
%% creating L1 set

[Lt I] = sort(C1,'descend');

%L = [I;Lt]

for i = 1:mx+1
    if Lt(i) >= Sup
        L(i,1) = I(i);
        L(i,2) = Lt(i);
    end
end


%% creating table
L1 = L(:,1);
Li = L(:,2);

%freqItems{1} = mat2str(L1);
freqItems{1} = L1;
%% apriori pseudocode
disp('creating frequent 2-itemsets');
% candidate 2-item set
if 1
j = 0;
for p = 1:length(L1)
    for q = p+1:length(L1)        %join step
        C2(j+1,1) = L1(p);
        C2(j+1,2) = L1(q);
        count = 0;
        
        for i = 1:length(A)
            a = int2str(L1(p));
            b = int2str(L1(q));
            if ~isequal(strfind(A(i),a),{[]}) && ~isequal(strfind(A(i),b),{[]}) 
                count = count +1;
            end
        end
        C2(j+1,3) = count;
        j = j+1;
    end
end
L2 = zeros(1,3);
j = 0;
for i = 1:length(C2)               %prune step
    if C2(i,3) >= Sup
        L2(j+1,:) = C2(i,:);
    end
    j = j+1;
end

%freqItems{2} = mat2str(L2);
freqItems{2} = L2;


if 0
len = 2;        
%% generating k-item candidate set
Ck = L2;
Lk_1 = ones(1,1);
item = 2;

disp('creating frequent k-itemsets');
while ~isempty(Lk_1)
    
    clear Ck_1;
    clear Lk_1;
    s = 1;
    for p = 1:size(Ck,1)
        for q = p+1:size(Ck,1)
            E = Ck(p,1:len-1);
            D = Ck(q,1:len-1);
            if size(setdiff(E,D)) == size(setdiff(D,E)) == 1
                %join step
                Ck_1(s) = union(Ck(p),Ck(q));
                count = 0;
                for i = 1:length(A)
                
                    equa = 0;
                    if len == 2
                        if ~isequal(strfind(A(i),int2str(Ck_1(s))),{[]})
                            
                            equa = equa + 1;
                            continue;
                        else
                            break;
                        end
                        
                    else
                        for j = 1:len+1
                            if ~isequal(strfind(A(i),int2str(Ck_1(s,j))),{[]})
                                equa = equa + 1;
                                continue;
                            else
                                    break;
                            end
                                    
                            
                        end
                    
                    end
                    if eq(equa,len+1)
                                 count = count + 1;
                    end
                end
                Ck_1(s,len+1) = count; 
            end
            s = s+1;
        end
    end
len = len+1;

%prune step

j = 0;
Lk_1 = Ck;
for i = 1:size(Ck_1,1)
    
    if Ck_1(i,len) >= Sup
        Lk_1(j+1) = Ck_1;
    end
end

freqItems{item + 1} = mat2str(Lk_1);
item = item + 1;
end
end
end
