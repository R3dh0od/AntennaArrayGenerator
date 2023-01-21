function [tag] = etiqueta(tag)
%esta función permite generar etiquetas en orden ascendente
x=tag;
y=length(x);
    if x(y)<57
        x(y)=x(y)+1;
    else
        x(y)=48;
        if x(y-1)<57
            x(y-1)=x(y-1)+1;
        else
            x(y-1)=48;
            if x(y-2)<57
                x(y-2)=x(y-2)+1;
            else
                x(y-2)=48;
                if x(y-3)<57
                    x(y-3)=x(y-3)+1;
                else
                    x(y-3)=48;
                    x(y-2)=48;
                    x(y-1)=48;
                    x(y)=48;
                end
            end
        end
    end

tag=x;
end

