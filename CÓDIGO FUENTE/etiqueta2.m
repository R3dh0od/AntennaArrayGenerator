function [x] = etiqueta2(x,y)
z=length(x);
if y==1
    x(z+1)=58;
    x(z+2)='c';
    x(z+3)='o';
    x(z+4)='n';
    x(z+5)='d';
    x(z+6)='u';
    x(z+7)='c';
    x(z+8)='t';
    x(z+9)='o';
    x(z+10)='r';
elseif y==2
    x(z+1)=58;
    x(z+2)='s';
    x(z+3)='u';
    x(z+4)='b';
    x(z+5)='s';
    x(z+6)='t';
    x(z+7)='r';
    x(z+8)='a';
    x(z+9)='t';
    x(z+10)='e';
elseif y==0
    x(z+1)=58;
    x(z+2)='g';
    x(z+3)='r';
    x(z+4)='o';
    x(z+5)='u';
    x(z+6)='n';
    x(z+7)='d';
else
    x(z+1)=58;
    x(z+2)='a';
    x(z+3)='u';
    x(z+4)='x';
end
end

