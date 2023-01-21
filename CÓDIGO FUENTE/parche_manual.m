

% Turn on farfield array using VBA commands
% This doesnt really use any features of the CST_MicrowaveStudio software but it will show you how to activate 
% the farfield array in CST 

% First set up a simple simulation

clear,clc
clear CST
CST = CST_MicrowaveStudio(cd,'dipole');
 CST.setFreq(2.4,2.5);
lamda = 3e11/2.4e9;
h=3.175;
fop=2.4;
fop1=2.4e9;
freq=fop1;
f=freq;
Er=2.33;
vo=3e11;
lambda=vo/f;
k0=2*pi/lambda;
W=(vo/(2*freq))*sqrt(2/(Er+1));
X=2;
Y=2;

Ereff=(Er+1)/2+((Er-1)/2)*(1+12*h/W)^(-0.5);

dL=h*0.412*((Ereff+0.3)*(W/h+0.264))/((Ereff-0.258)*(W/h+0.8));

L=vo/(2*f*(sqrt(Ereff)))-2*dL;


G1=1/90*(W/lambda)^2;%W/(120*lambda)*(1-(k0*h)^2/240);
espCol=0;
espFil=0;

L1=acos(sqrt(50*2*G1))*L/pi;
% for i=1:2
%  clear CST
% CST = CST_MicrowaveStudio(cd,'dipole');
% CST.setFreq(2.35,2.45);
% lamda = 3e11/2.4e9;
% 
% CST.addDiscretePort([0 0],[0 0],[-lamda/10 lamda/10],0.1,75);
% 
% CST.addCylinder(1,0,'z',0,0,[lamda/10 lamda/4],'p1','component1','PEC');
% CST.addCylinder(1,0,'z',0,0,[-lamda/10 -lamda/4],'p2','component1','PEC');

patch=[80 97 116 99 104 48 48 48 49];
sustrate=[83 117 98 115 116 114 97 116 101 48 48 48 49];
ground=[71 114 111 117 110 100 48 48 48 49];
%CST = CST_MicrowaveStudio(cd,'dipole');
% CST.setFreq(freq/1e9-0.1,freq/1e9+0.1);
CST.addNormalMaterial('RT duroid 5870',2.33,1,[204/255 0/255 0/255]);

conductor=0.017; 
coaxial=20;
coax_int=1/2;
coax_ext=3.57/2;

i=1; 
   
%         waitbar(((100*i+1)/total2)/50,barra,'Exportando arreglo...');
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


% CST.setBoundaryCondition('xmin','open add space','xmax','open add space','ymin','open add space',...
%     'ymax','open add space','zmin','open add space','zmax','open add space')
% 


%%
%Get handle to farfield array object in CST;
farfieldArray = CST.mws.invoke('FarfieldArray');
% Where the results are stored
ResultPath = CST.mws.invoke('GetProjectPath',("Result"))
% ant=i
% Create a 4 x 1 element array along the y-axis with elements spaced lamda/2 mm apart with 0 phase shift)
%
farfieldArray.invoke('Reset');
farfieldArray.invoke('UseArray',true);
farfieldArray.invoke('XSet',3, lamda, 60);
farfieldArray.invoke('SetList');
farfieldArray.invoke('ArrayType','edit');
%farfieldArray.invoke('Antenna',0, 0, 0, 1, 0);
% end

%% Create a 3 x 3 element array along the x/z plane with elements spaced lamda/4 apart with 45 phase shift in x axis
% % %
% farfieldArray.invoke('Reset');
% farfieldArray.invoke('UseArray',true);
% farfieldArray.invoke('XSet',2, lamda*0.7, 0);
% farfieldArray.invoke('ZSet',2, lamda*0.5, 0);
% farfieldArray.invoke('SetList');
% farfieldArray.invoke('ArrayType','edit');
% farfieldArray.invoke('Antenna',0, 0, 0, 1, 0);

CST.addFieldMonitor('farfield',fop)
CST.addFieldMonitor('efield',fop)
CST.runSimulation;


