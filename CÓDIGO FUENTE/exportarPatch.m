function [] = exportarPatch(ncol,nfil,espCol,espFil,X,Y,h,lambda,freq)
%función para exportar un arreglo de antenas tipo patch rectangulares
barra = waitbar(0,'Exportando Arreglo...');
%% Diseño de la antena
f=freq;
Er=2.33;
vo=3e11;
lambda=vo/f;
k0=2*pi/lambda;
W=(vo/(2*freq))*sqrt(2/(Er+1));


Ereff=(Er+1)/2+((Er-1)/2)*(1+12*h/W)^(-0.5);

dL=h*0.412*((Ereff+0.3)*(W/h+0.264))/((Ereff-0.258)*(W/h+0.8));

L=vo/(2*f*(sqrt(Ereff)))-2*dL;


G1=1/90*(W/lambda)^2;%W/(120*lambda)*(1-(k0*h)^2/240);

L1=acos(sqrt(50*2*G1))*L/pi;

espCol=espCol*1000;
espFil=espFil*1000;

%%Exportación a CST
%a=[99 111 109 112 111 110 101 110 116 48 48 48 48];
patch=[80 97 116 99 104 48 48 48 49];
sustrate=[83 117 98 115 116 114 97 116 101 48 48 48 49];
ground=[71 114 111 117 110 100 48 48 48 49];
CST = CST_MicrowaveStudio(cd,'dipole');
CST.setFreq(freq/1e9-0.1,freq/1e9+0.1);
CST.addNormalMaterial('RT duroid 5870',2.33,1,[204/255 0/255 0/255]);
total1=nfil*ncol;
total2=ncol;
conductor=0.017; 
coaxial=20;
coax_int=1/2;
coax_ext=3.57/2;
if nfil==0
    
   for i=0:ncol-1
        waitbar(((100*i+1)/total2)/50,barra,'Exportando arreglo...');
        %Plano de tierra
        CST.addBrick([(-L/2*X+i*espCol) (L/2*X+i*espCol)],[0 conductor],[-W/2*Y W/2*Y],'ground',ground,'PEC');
        CST.addCylinder(coax_ext,0,'y',-L1+i*espCol,[-coaxial-conductor conductor],0,'aux',ground,'PEC');
        component1 = etiqueta2(ground,0);
        component2 = etiqueta2(ground,3);
        CST.subtractObject(component1,component2)
        CST.addCylinder(coax_ext+conductor,coax_ext,'y',-L1+i*espCol,[-coaxial conductor],0,'aux',ground,'PEC');
        CST.mergeCommonSolids(ground)
        ground=etiqueta(ground);
%         %Substrato
        CST.addBrick([(-L/2*X+i*espCol) (L/2*X+i*espCol)],[conductor conductor+h],[-W/2*Y W/2*Y],'substrate',sustrate,'RT duroid 5870');
        CST.addCylinder(coax_int,0,'y',-L1+i*espCol,[conductor conductor+h],0,'aux',sustrate,'RT duroid 5870');
        component1 = etiqueta2(sustrate,2);
        component2 = etiqueta2(sustrate,3);
        CST.subtractObject(component1,component2)
        CST.addCylinder(coax_ext,coax_int,'y',-L1+i*espCol,[-coaxial-conductor conductor],0,'aux',sustrate,'RT duroid 5870');
        CST.mergeCommonSolids(sustrate)
        sustrate=etiqueta(sustrate);
        %Patch
        CST.addBrick([(-L/2+i*espCol) (L/2+i*espCol)],[conductor+h conductor*2+h],[-W/2 W/2],'conductor',patch,'PEC');
        CST.addCylinder(coax_int,0,'y',-L1+i*espCol,[-coaxial-conductor conductor*2+h],0,'aux',patch,'PEC');
        CST.mergeCommonSolids(patch)
        patch=etiqueta(patch);
       CST.addWaveguidePort('ymin',[-coax_ext-conductor+i*espCol-L1 coax_ext+conductor+i*espCol-L1],-coaxial-conductor,[-coax_ext-conductor coax_ext+conductor])
        total2=total2+1;
    end
else
    i2=0;
    for i=0:ncol-1
        for j=0:nfil-1
            waitbar(((100*i2+1)/total1)/50,barra,'Exportando Arreglo...');
            %Plano de tierra
            CST.addBrick([(-L/2*X+i*espCol) (L/2*X+i*espCol)],[0 conductor],[-W/2*Y+j*espFil W/2*Y+j*espFil],'ground',ground,'PEC');
            CST.addCylinder(coax_ext,0,'y',-L1+i*espCol,[-coaxial-conductor conductor],j*espFil,'aux',ground,'PEC');
            component1 = etiqueta2(ground,0);
            component2 = etiqueta2(ground,3);
            CST.subtractObject(component1,component2)
            CST.addCylinder(coax_ext+conductor,coax_ext,'y',-L1+i*espCol,[-coaxial conductor],j*espFil,'aux',ground,'PEC');
            CST.mergeCommonSolids(ground)
            ground=etiqueta(ground);
            %Substrato
            CST.addBrick([(-L/2*X+i*espCol) (L/2*X+i*espCol)],[conductor conductor+h],[-W/2*Y+j*espFil W/2*Y+j*espFil],'substrate',sustrate,'RT duroid 5870');
            CST.addCylinder(coax_int,0,'y',-L1+i*espCol,[conductor conductor+h],j*espFil,'aux',sustrate,'RT duroid 5870');
            component1 = etiqueta2(sustrate,2);
            component2 = etiqueta2(sustrate,3);
            CST.subtractObject(component1,component2)
            CST.addCylinder(coax_ext,coax_int,'y',-L1+i*espCol,[-coaxial-conductor conductor],j*espFil,'aux',sustrate,'RT duroid 5870');
            CST.mergeCommonSolids(sustrate)
            sustrate=etiqueta(sustrate);
            %Patch
            CST.addBrick([(-L/2+i*espCol) (L/2+i*espCol)],[conductor+h conductor*2+h],[-W/2+j*espFil W/2+j*espFil],'conductor',patch,'PEC');
            CST.addCylinder(coax_int,0,'y',-L1+i*espCol,[-coaxial-conductor conductor*2+h],j*espFil,'aux',patch,'PEC');
            CST.mergeCommonSolids(patch)
            patch=etiqueta(patch);
            CST.addWaveguidePort('ymin',[-coax_ext-conductor+i*espCol-L1 coax_ext+conductor+i*espCol-L1],-coaxial-conductor,[-coax_ext-conductor+j*espFil coax_ext+conductor+j*espFil])
            total1=total1+1;
            i2=i2+1;
        end
    end

end
waitbar(1,barra,'El arreglo ha sido exportado con éxito');
% CST.addFieldMonitor('farfield',freq/1e9)
% CST.addFieldMonitor('efield',freq/1e9)
% CST.runSimulation;

end
