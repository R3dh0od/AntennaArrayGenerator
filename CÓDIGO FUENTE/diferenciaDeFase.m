function [fase] = diferenciaDeFase(phaseF,phaseC,nElemX,nElemY)
%esta función genera un vector que representa la
%diferencia de fase uniforme según el número de
%elementos del arreglo


if nElemY==0
    nElemY=1;
end

fase(1)=0; %valor de referencia

%%primero se calcula la diferencia de fase en filas
for i=2:nElemX
    for j=1:nElemY
    fase(i,j)=(i-1)*phaseF;
    end
end

%%se clacula la diferencia de fase en columnas de la primera fila
for i=2:nElemY
    fase(1,i)=phaseC+fase(1,i-1);
end


%%se calcula la diferencia de fase en columnas del resto de la matriz de
%%fase
for i=2:nElemX
    for j=2:nElemY
        fase(i,j)=phaseC+fase(i,j-1);
    end
end
 fase1=fase;
%organizo todo con un vector
 fase=reshape(fase',1,[]);
end

