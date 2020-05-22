%Training code 
%Reece Jones
%151-477

clear all;close all;clc

load('mnist.mat')

%--------------------------------------------------------------------

%%%% Plotting a HandWritten Digit
%for ii = 1:10

% nHold = 60 % I chose the 7th image to show
% IMAGE = reshape(images(nHold,:),28,28)';
% labels(nHold)
% figure,imagesc(IMAGE)
% colormap(flipud(gray(256)))
% axis equal
% set(gca, 'YTick', []);
% set(gca, 'XTick', []);
% axis off

%create matricies with images vectors that correspond to the number that
%the matrix represents
for i = 1:10
    
   tempvec = find(labels == i-1);
   X{i} = images(tempvec,:);
    
end


%have the for loop here for iteration on gamma values
%for k = 1:1
    %gamma = 10^(k-4);
    
    %to keep track of iterations
    count = 1;
    %for putting into matrix form rather than straight into cell array
    temp = 1;
    %gamma hard coded here once found best accuracy 
    gamma = 10^(-4);

for i = 1:9
    
    for j = 10:-1:(i+1)
        
cvx_solver sedumi
cvx_begin quiet
cvx_precision low
    
    variable a(784)
    variable u(size(X{i},1))
    variable v(size(X{j},1))
    variable b(1)

    minimize( norm(a,2) + gamma*(norm(u,1) + norm(v,1)) )
    subject to
        X{i}*a - b >= (1-u)
        X{j}*a - b <= -(1-v)
        u>0
        v>0
        
cvx_end

%in case first solver doesn't work
if cvx_status == 'Failed'

cvx_solver sdpt3
cvx_begin quiet
cvx_precision low
    
    variable a(784)
    variable u(size(X{i},1))
    variable v(size(X{j},1))
    variable b(1)

    minimize( norm(a,2) + gamma*(norm(u,1) + norm(v,1)) )
    subject to
        X{i}*a - b >= (1-u)
        X{j}*a - b <= -(1-v)
        u>0
        v>0
        
cvx_end


end

%have to put into matrix form because it didn't like going straight into
%cell array 
Ahold(temp,:) = a;
Bhold(i,j) = b;

%display what iteration out of 45 currently on 
count
temp = temp + 1;
count = count + 1;

    end
end


%now for transferring matrix form into required cell array form
temp = 1;
for i = 1:9
    
    for j = 10:-1:(i+1)
        
   A{i,j} = Ahold(temp,:);
   B{i,j} = Bhold(i,j);
   
   temp = temp+1;
        
    end
end

%This is for saving multiple As and Bs when testing multiple gammas

% for m = 1:length(tempsaveB)
% 
% Anew = tempsaveA{m};
% Bnew = tempsaveB{m};
%     
% temp = 1;
% 
% for i = 1:9
%     
%     for j = 10:-1:(i+1)
%         
%    Atry{i,j} = Anew(temp,:);
%    Btry{i,j} = Bnew(i,j);
%    
%    temp = temp+1;
%         
%     end
% end


% tempsaveA{k} = A;
% tempsaveB{k} = B;

%save('justatest_Jones' a b)

%end


