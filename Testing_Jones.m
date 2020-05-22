%Testing Script
%Reece Jones
%151-477

clear all;close all;clc

%---------------------------------------------------------------------

load('mnist.mat')
load('DAG_Jones.mat')

%count how many were right, add to count when code correctly identifies
accuracycount = 0;

for k = 1:size(images_test,1)

%vec of number possibilities.. delete elements when determined NOT the answer    
tempvec = 0:9;
i = 1;
j = 2;

while length(tempvec) > 1
    
    if double(images_test(k,:))*A{i,j}' - B{i,j} < 0
        %implies NOT (i-1), so must delete from tempvec
        
        tempdel = find(tempvec == (i-1));
        %makes sure it hasn't already been deleted 
        if tempdel > 0
           tempvec(tempdel) = [];  
        end
        
        %Go down a row
        i = i + 1;
        j = i + 1;        
        
    else
        %implies NOT (j-1), so must delete from tempvec
        
         tempdel = find(tempvec == (j-1));
        %makes sure it hasn't already been deleted 
        if tempdel > 0
           tempvec(tempdel) = [];  
        end
        
        %Go across row
        j = j + 1;
   
    end
    
end

%add to count if the solver worked 
if labels_test(k) == tempvec
   
   accuracycount = accuracycount + 1; 
    
end

end

accuracy = 100*accuracycount/10000
