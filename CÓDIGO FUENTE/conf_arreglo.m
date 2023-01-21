function [conf] = conf_arreglo(n)
%esta función entrega todas las combinaciones posibles
%para generar un arreglo con n elementos
j=1;
for i=2:1:n/2
    if mod(n,i)==0
        y(j)=i;
        j=j+1;
    end
end

y2=n./y;
a3=(cat(1,y,y2))';
if length(a3)<=3
    conf=a3([1:ceil(length(a3)/2)],[1,2]);
else
    conf=a3([floor(length(a3)/2)+1:length(a3)],[1,2]);
end

