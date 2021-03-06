% Let's test some code!

clear all;close all;clc

% MEDIUM LEVEL
MatrixInitial1 = [0 5 0 0 2 0 3 7 0; 
                  0 3 0 9 4 0 0 0 1;  
                  0 0 0 7 0 0 0 0 0;  
                  0 0 5 8 0 0 9 2 0; 
                  3 0 0 0 0 0 0 0 5; 
                  0 7 8 0 0 9 1 0 0;  
                  0 0 0 0 0 2 0 0 0;   
                  8 0 0 0 7 6 0 5 0;    
                  0 2 1 0 8 0 0 6 0];

              
 % EVIL LEVEL
 MatrixInitial2 = [0 6 9 7 0 0 4 3 0;   
                   0 1 0 0 0 0 0 7 0;          
                   3 0 0 0 0 5 0 0 2;       
                   0 3 0 0 0 0 0 0 1;        
                   0 0 0 0 9 0 0 0 0;       
                   6 0 0 0 0 0 0 2 0;        
                   7 0 0 2 0 0 0 0 3;         
                   0 9 0 0 0 0 0 4 0;        
                   0 4 2 0 0 3 5 1 0];
             
        
 % %EVIL LEVEL
 MatrixInitial3 = [0 9 0 4 0 8 5 0 0;   
                   0 0 0 0 0 0 0 0 6;    
                   2 0 1 0 7 0 9 0 0;     
                   5 0 0 0 8 0 0 0 7;      
                   0 0 7 9 0 4 1 0 0;       
                   8 0 0 0 2 0 0 0 9;      
                   0 0 2 0 3 0 4 0 5;       
                   4 0 0 0 0 0 0 0 0;       
                   0 0 5 8 0 7 0 9 0];
               
                
 % %Hardest Sudoku Ever
 MatrixInitial4 = [8 0 0 0 0 0 0 0 0;    
                   0 0 3 6 0 0 0 0 0;          
                   0 7 0 0 9 0 2 0 0;       
                   0 5 0 0 0 7 0 0 0;        
                   0 0 0 0 4 5 7 0 0;       
                   0 0 0 1 0 0 0 3 0;            
                   0 0 1 0 0 0 0 6 8;         
                   0 0 8 5 0 0 0 1 0;        
                   0 9 0 0 0 0 4 0 0];
               
               
 tic
 Sudoku_Jones(MatrixInitial4)
 time = toc

