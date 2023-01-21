function [] = exportarDipolo(ncol,nfil,espCol,espFil,radio,lambda,freq)
%función para exportar un arreglo de dipolos de media longitud de onda
barra = waitbar(0,'Exportando Arreglo...');
a=[99 111 109 112 111 110 101 110 116 48 48 48 48];
CST = CST_MicrowaveStudio(cd,'dipole');
CST.setFreq(freq-1,freq+1);
total1=nfil*ncol;
total2=ncol;
espCol=espCol*10000;
espFil=espFil*10000;
lambda=3e12/freq;
if nfil==0
    for i=0:ncol-1
        
        CST.addDiscretePort([i*espCol i*espCol],[0 0],[-lambda/20 lambda/20],radio,50);
        CST.addCylinder(radio,0,'z',i*espCol,0,[lambda/20 lambda/4],char(a),a,'PEC');
        a=etiqueta(a);
        CST.addCylinder(radio,0,'z',i*espCol,0,[-lambda/20 -lambda/4],char(a),a,'PEC');
        a=etiqueta(a);
        waitbar(((100*i+1)/total2)/50,barra,'Exportando arreglo...');
        total2=total2+1;
    end
else
    i2=0;
    for i=0:ncol-1
        for j=0:nfil-1
            CST.setBoundaryCondition('xmin','open add space','xmax','open add space','ymin','open add space',...
    'ymax','open add space','zmin','open add space','zmax','open add space')
            CST.addDiscretePort([i*espCol i*espCol],[0 0],[-lambda/20+j*espFil lambda/20+j*espFil],radio,50);
            CST.addCylinder(radio,0,'z',i*espCol,0,[lambda/20+j*espFil lambda/4+j*espFil],char(a),a,'PEC');
            a=etiqueta(a);
            CST.addCylinder(radio,0,'z',i*espCol,0,[-lambda/20+j*espFil -lambda/4+j*espFil],char(a),a,'PEC');
            a=etiqueta(a);
            waitbar(((100*i2+1)/total1)/50,barra,'Exportando Arreglo...');
            total1=total1+1;
            i2=i2+1;
        end
    end

end
waitbar(1,barra,'El arreglo ha sido exportado con éxito');
% CST.addFieldMonitor('farfield',freq)
% CST.addFieldMonitor('efield',freq)
% 
% CST.runSimulation;
end

