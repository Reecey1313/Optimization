
function[out] = Sudoku_Jones(given) 

% Sudoko solver project
% Reece Jones
% 151-477

%clear all;close all;clc;

%--------------------------------------------------------------------

%Final constraint to have 3D elements of each cell add up to 1

for i = 1:81
    
  Acell(i,((i-1)*9)+1:((i-1)*9)+1 + 8) = 1;
    
end


%This is for the rows rule that each element in 3rd dimension can only be
%represented once
for i = 1:9
for j = 1+(i-1)*81:9:((i-1)*81+81)
    
newrows((i-1)*9+1:((i-1)*9)+9,(j:j+8)) = eye(9);
    
end
end


%This is for the columns rule that each element in 3rd dimension can only be
%represented once
for i = 1:9
    
newcolumns(1:81,((i-1)*81)+1:((i-1)*81)+81) = eye(81);
    
end


%Now for square equalities where element in 3rd dimension can only be
%represented one for each 3 by 3 square
temp = 1;
%Quad 4 loop! This pattern was tough and had to cheat a bit with the temp
%variable 
for m = 1:3
    for i = 1:3
        for j = 1:3
            for k = 1:3
    
    
            newsquares( (temp-1)*9+linspace(1,9,9),...
        243*(m-1)+27*(i-1)+81*(j-1)+9*(k-1)+linspace(1,9,9) ) = eye(9);
        
    
            end
        end
    temp = temp + 1;
    end
end


%Now call function to replace given elements from sudoku with "binary"
%values
Areplace = replace(given);
[rowstemp columnstemp] = size(Areplace);

%now for b vec from sudoku rule constraints
bcolumns = ones(81,1);
brows = ones(81,1);
bsquares = ones(81,1);
bcell = ones(81,1);
breplace = ones(rowstemp,1);

%concatenate b vector
btot = [bcolumns;brows;breplace;bsquares;bcell];
%Concatenate A matricies
Atot = [newcolumns;newrows;Areplace;newsquares;Acell];
%trying to minimize sum of variables so c vector is simply 
%Given that we constraint x to between 0 and 1
ctot = ones(1,9^3)';

tempans = linprog(ctot,[],[],Atot,btot,zeros(1,729),ones(1,729))'
%call function to replace ones with actual numbers and create matrix
out = numbers(tempans);

end


%This function creates new equivilancy matrix that assigns x values from
%given matrix 
%Use this matrix as equality constraint in linprog
function[out] = replace(in)
   
    whatis = transpose(in);
    wherein = find(transpose(in)~=0);
    Areplace = zeros(length(wherein),9^3);
    for i = 1:length(wherein)
    
        Areplace(i,(wherein(i)-1)*9 + whatis(wherein(i))) = 1;
    
    end

    out = Areplace;
    
end



%This function replaces the ones with their respective numbers to construct
%the final output matrix
function[out] = numbers(in)

finalmat = zeros(9,9);
temp = 1;

for i = 1:81
   
    for j = 1:9
       
        if in((i-1)*9 + j) ~=0
            
            finalmat(temp) = j;
            temp = temp + 1;
            
        end
        
    end
    
end

%have to transpose it because of the way that matlab defines element
%indicies of a matrix
out = finalmat';

end


