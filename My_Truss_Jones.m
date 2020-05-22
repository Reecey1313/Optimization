%Project 1 - Truss Topology 

%Reece Jones
%151-477

close all;clear all;clc

%---------------------------------------------------------------------

rows = 11;
columns = 20;

%initialize vectors
xvec = [];
yvec = [];
plotvecxstart = [];
plotvecxend = [];
plotvecystart = [];
plotvecyend = [];

%Goal is to find vector of change for each unique bar 
%starting from bottom and going to top, moving column by column to
%the right 

%horizontal node element
for f = 1:columns

%vertical node element
for k = 1:rows

%i decreases every time we shift over a row
for i = 1:(columns+1)-f
       
    if i == 1
   
   %start by creating change in x for each unique bar 
   xvec = [xvec,(i-1)*ones(1,rows-k)];
   %important to create start and end points for each unique bar for
   %ploting purposes
   plotvecxstart = [plotvecxstart,(f-1)*ones(1,rows-k)];
   plotvecxend = [plotvecxend, (f-1)*ones(1,rows-k) + (i-1)*ones(1,rows-k)];
   
   %now find change in y for each unique bar 
   yvec = [yvec,1:(rows-k)];
  %start and end of unique bar y value
  plotvecystart = [plotvecystart,(k-1)*ones(1, length(1:(rows-k)) )];
  plotvecyend = [plotvecyend,[(k-1)*ones(1, length(1:(rows-k)))]+ [1:(rows-k)]];
   
  %else case made for every column except the one currently on
    else
        
   xvec = [xvec,(i-1)*ones(1,rows)];
  plotvecxstart = [plotvecxstart,(f-1)*ones(1,rows)];
  plotvecxend = [plotvecxend, (f-1)*ones(1,rows) + (i-1)*ones(1,rows)];
   
   yvec = [yvec,[1:rows]-k];
 plotvecystart = [plotvecystart,(k-1)*ones(1,length([1:rows]-k))];
 plotvecyend = [plotvecyend,[(k-1)*ones(1,length([1:rows]-k))]+[[1:rows]-k] ];
       
    end
   
end

end

end

%create matrix of start and end values for x and y that can easily be
%indexed based on unique element number
xplot = [plotvecxstart' plotvecxend'];
yplot = [plotvecystart' plotvecyend'];


for i = 1:length(xvec)
   
    %creating vectors of sins and cosines for non-duplicates of bars
    totcos(i) = xvec(i)/norm([xvec(i),yvec(i)]);
    totsin(i) = yvec(i)/norm([xvec(i),yvec(i)]);
    
      %create length vectors for each unique bar
      lengthvec(i) = norm([xvec(i),yvec(i)]);
   
end

%now creating each matrix
temp = 1;
%for sum of forces x
A = zeros((rows*columns),length(totcos));
%for sum of forces y
A1 = zeros((rows*columns),length(totcos));
%look at report for description of pattern

for i = 1:rows*columns
       
    %Working on consistent value part of matrix
    tempvec = temp:(temp+(rows*columns)-(i+1));
    %negative since assume in tension 
    A( i,tempvec ) = -totcos( tempvec );
    A1( i,tempvec ) = -totsin( tempvec );
   
    tempspeye = speye(length(tempvec));
    tempspeye1 = speye(length(tempvec));
    for j = 1:length(tempvec)
    %Working on I part of matrix pattern
    tempspeye(j,j) = totcos( tempvec(j) );
    tempspeye1(j,j) = totsin( tempvec(j) );
    end
   
    A( ((i+1):rows*columns),(tempvec) ) = tempspeye;
    A1( ((i+1):rows*columns),(tempvec) ) = tempspeye1;
   
   
    temp = temp + (rows*columns)-i;
   
       
end

%creating final matrix of EQUALITIES for sum of forces x and y

%setting sum of x and y components equal to zero
Aeq1 = [A zeros(rows*columns,length(totcos)) ];
Aeq2 = [A1 zeros(rows*columns,length(totcos)) ];
%delete eqauations for anchors
Aeq1((5:7),:) = [];
Aeq2((5:7),:) = [];

Aeq = [Aeq1;Aeq2];

%subsequent b vector deletion for removal of anchor equations
forcevecx = zeros(1,(rows*columns)-3);
forcevecy = zeros( 1,(rows*columns)-3);
%replace sum of forces equal to zero with given applied force
forcevecy(end-5) = 4;

%creating final matrix of INEQUALITIES for constraints

%Strain constraint (for tension and compression)
Aconstraintpos = [speye(length(totcos)) zeros(length(totcos))];
Aconstraintneg = [-speye(length(totcos)) zeros(length(totcos))];
% now for u - t <= 0
Au1 = [speye(length(totcos)) -speye(length(totcos))];
% and -u - t <= 0
Au2 = [-speye(length(totcos)) -speye(length(totcos))];

Aineq = [Aconstraintpos;Aconstraintneg;Au1;Au2];

%b vec for equalities 

beq = [forcevecx forcevecy];

%b vec for inequalities 

bineq = [8*ones(1,length(totcos)) 8*ones(1,length(totcos))...
    zeros(1,length(totcos)) zeros(1,length(totcos))]; 


%trying to minimize t values one norm WITHOUT length weight
ctot = [zeros(1,length(totcos)) ones(1,length(totcos))];
%trying to minimize t values one norm WITH length weight
ctotlength = [zeros(1,length(totcos)) lengthvec];

%linprog for equality and inequality matricies, NO LENGTH WEIGHT 
%UNCOMMENT THIS FOR OTHER METHOD
%answervec = linprog(ctot',Aineq,bineq',Aeq,beq',0,[]);

%linprog for equality and inequality matricies, NO LENGTH WEIGHT
%UNCOMMENT THIS FOR OTHER METHOD
answervec = linprog(ctotlength',Aineq,bineq',Aeq,beq',0,[]);

%This is the vector of forces for each unique bar
uvec = answervec(1:length(totcos));
barswithforces = find(abs(uvec)>(1e-4));

%find total number of bars used
fprintf('The total number of bars used for this method is %.0f\n',length(barswithforces))
%find total length 
fprintf('The total length of bars used for this method is %.2f\n\n',sum(lengthvec(barswithforces)))


%this is what to aim for to plot vectors
%plot([3 4], [5,6]), pattern reflected in first nested loop

hold on 

%plot based on pattern and start and end points already created
for i = 1:length(barswithforces)
   
    if uvec(barswithforces(i)) > 0
        %Elements in tension since we assumed tension 
        plot([xplot(barswithforces(i),:)],[yplot(barswithforces(i),:)],'b');
    else
        %Elements in compression since we assume tension 
        plot([xplot(barswithforces(i),:)],[yplot(barswithforces(i),:)],'r');
    end
    
end


%Now for plotting the base grid

plot([19 19],[5 3],'r','Linewidth',2)
plot([19 18.5],[3 3.5],'r','Linewidth',2)
plot([19 19.5],[3 3.5],'r','Linewidth',2)
plot([0 -1 -1 0],[6 5.7 6.5 6],'k','Linewidth',2)
plot([0 -1 -1 0],[5 4.7 5.5 5],'k','Linewidth',2)
plot([0 -1 -1 0],[4 3.7 4.5 4],'k','Linewidth',2)
plot([-1.5 -1],[3.5 3.8],'k','Linewidth',2)
plot([-1.5 -1],[3.8 4.1],'k','Linewidth',2)
plot([-1.5 -1],[4.1 4.4],'k','Linewidth',2)
plot([-1.5 -1],[4.5 4.8],'k','Linewidth',2)
plot([-1.5 -1],[4.8 5.1],'k','Linewidth',2)
plot([-1.5 -1],[5.1 5.4],'k','Linewidth',2)
plot([-1.5 -1],[5.5 5.8],'k','Linewidth',2)
plot([-1.5 -1],[5.8 6.1],'k','Linewidth',2)
plot([-1.5 -1],[6.1 6.4],'k','Linewidth',2)
axis equal 

 
 