classdef array_generator < matlab.apps.AppBase
%%
%Desarrollado por Ricardo Mera López
%%
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        TipodeantenaSwitchLabel        matlab.ui.control.Label
        TipodeantenaSwitch             matlab.ui.control.Switch
        CatactersticasdelarregloPanel  matlab.ui.container.Panel
        Unidades                       matlab.ui.control.ListBox
        FrecuenciaEditFieldLabel       matlab.ui.control.Label
        Frecuencia                     matlab.ui.control.NumericEditField
        DirectividaddBLabel            matlab.ui.control.Label
        Directividad                   matlab.ui.control.NumericEditField
        ToleranciaLabel                matlab.ui.control.Label
        Tolerancia                     matlab.ui.control.NumericEditField
        AzimuthgradosLabel             matlab.ui.control.Label
        azimuth                        matlab.ui.control.NumericEditField
        ElevacingradosLabel            matlab.ui.control.Label
        elevacion                      matlab.ui.control.NumericEditField
        ParmetrosdelaantenaPanel       matlab.ui.container.Panel
        RadiommLabel                   matlab.ui.control.Label
        Radio                          matlab.ui.control.NumericEditField
        PlanodetierraXvecesLabel       matlab.ui.control.Label
        GroundX                        matlab.ui.control.NumericEditField
        PlanodetierraYvecesLabel       matlab.ui.control.Label
        GroundY                        matlab.ui.control.NumericEditField
        SeparacinentreconductoresmmLabel  matlab.ui.control.Label
        Separacion                     matlab.ui.control.DropDown
        ExportaraCSTButton             matlab.ui.control.Button
        CalcularButton                 matlab.ui.control.Button
        CenterPanel                    matlab.ui.container.Panel
        UIAxes                         matlab.ui.control.UIAxes
        tipoDeGrafico                  matlab.ui.control.DiscreteKnob
        RightPanel                     matlab.ui.container.Panel
        TipodearregloLabel             matlab.ui.control.Label
        TipodearregloSwitch            matlab.ui.control.Switch
        ColumnasPanel                  matlab.ui.container.Panel
        fase1                          matlab.ui.control.NumericEditField
        spaceY1                        matlab.ui.control.NumericEditField
        FasegradosLabel_2              matlab.ui.control.Label
        Fase                           matlab.ui.control.Knob
        EspaciamientolongituddeondaLabel_2  matlab.ui.control.Label
        spaceY                         matlab.ui.control.Knob
        NmerodeelementosLabel          matlab.ui.control.Label
        NelemY                         matlab.ui.control.Spinner
        FilasPanel                     matlab.ui.container.Panel
        spaceX1                        matlab.ui.control.NumericEditField
        fase1_2                        matlab.ui.control.NumericEditField
        EspaciamientolongituddeondaLabel  matlab.ui.control.Label
        spaceX                         matlab.ui.control.Knob
        NmerodeelementosLabel_2        matlab.ui.control.Label
        NelemX                         matlab.ui.control.Spinner
        FasegradosLabel                matlab.ui.control.Label
        Fase_2                         matlab.ui.control.Knob
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end

    
    properties (Access = private)
        f % frecuencia
        espX % espaciamiento en X
        espY %espaciamiento en Y
        phase %diferencia de fase en columnas
        phaseFila %diferencia de fase en filas
        campoDipolo %patron de radiacion dipolo
        lambda %longitud de onda
        direc %directividad  
        direc2
        toleracia
        azi%azimuth
        elev%elevación
        cont1=0 %variable auxiliar
        aux2=0%auxiliar2
        
    end
    
    methods (Access = private)
        function graficos(app)
            app.UIAxes.Color='none';
            app.UIAxes.XColor='none';
            app.UIAxes.YColor='none';
            app.UIAxes.ZColor='none';
         
        end
        
        function activarDipolo(app)
            tipoDeAntena=app.TipodeantenaSwitch.Value;
            load patrones2.mat E E2
            if tipoDeAntena=="Patch"
                app.campoDipolo=E2+abs(min(min(E2)));
                app.Radio.Enable='off';
                app.GroundX.Enable='on';
                app.GroundY.Enable='on';
                app.Separacion.Enable='on';
            else
                app.campoDipolo=E;
                app.Radio.Enable='on';
                app.GroundX.Enable='off';
                app.GroundY.Enable='off';
                app.Separacion.Enable='off';
            end
        end
        
        function Arreglo(app)
            tipoDeArreglo=app.TipodearregloSwitch.Value;
            if app.tipoDeGrafico.Value=="Antena"
                app.spaceX.Enable='off';
                app.spaceX1.Enable='off';
                app.spaceY.Enable='off';
                app.spaceY1.Enable='off';
                app.TipodearregloSwitch.Enable='off';
                app.NelemX.Enable='off';
                app.NelemY.Enable='off';
                app.Fase.Enable='off';
                app.fase1.Enable='off';
                app.fase1_2.Enable='off';
                app.Fase_2.Enable='off';
                app.CalcularButton.Enable='off';
                app.ExportaraCSTButton.Enable='off';

            else
                app.TipodearregloSwitch.Enable='on';
                app.CalcularButton.Enable='on';
                app.ExportaraCSTButton.Enable='on';
                app.Fase.Enable='on';
                app.fase1.Enable='on';
                app.fase1_2.Enable='on';
                app.Fase_2.Enable='on';
                app.spaceX.Enable='on';
                app.spaceX1.Enable='on';
                app.NelemX.Enable='on';
                if tipoDeArreglo=="Lineal"
                    app.spaceY.Enable='off';
                    app.spaceY1.Enable='off';                    
                    app.NelemY.Enable='off';
                    app.Fase.Enable='off';
                    app.fase1.Enable='off';
                else
                    app.spaceY.Enable='on';
                    app.spaceY1.Enable='on';                    
                    app.NelemY.Enable='on';
                    app.Fase.Enable='on';
                    app.fase1.Enable='on';
                end
            end
        end
                     
        function  parametros(app)
            f1=app.Frecuencia.Value;
            f2=str2double(app.Unidades.Value);
            app.f=f1*f2;
            app.lambda=3e8/(f1*f2);
            if app.spaceX.Value==0
                app.espX=1/1000;
            else
                app.espX = app.lambda*(app.spaceX.Value);
            end
            if app.TipodearregloSwitch.Value=="Planar"
                app.aux2=app.NelemY.Value;
                if app.spaceY.Value==0
                    app.espY=1/1000;
                else
                    app.espY = app.lambda*(app.spaceY.Value);
                end
            else
                app.aux2=0;
            end
            app.azi=app.azimuth.Value;
            app.elev=app.elevacion.Value;
            app.toleracia=10*log10(1-app.Tolerancia.Value/100);
            app.direc=app.Directividad.Value;
            app.phase=app.Fase.Value;
            app.phaseFila=app.Fase_2.Value;
            app.fase1.Value = app.Fase.Value;
            app.fase1_2.Value=app.Fase_2.Value;
            app.spaceX1.Value=app.spaceX.Value;
            app.spaceY1.Value=app.spaceY.Value;
            
            
      
        end
        
          
         
        function calcular(app)
            if app.TipodearregloSwitch.Value=="Lineal"
                
                h = linearArray('ElementSpacing',app.espX);
                if app.cont1==0
                h.NumElements=app.NelemX.Value;
                h.PhaseShift=diferenciaDeFase(app.phaseFila,0,app.NelemX.Value,0);
%                layout(h)
                else
                    barra = waitbar(0,'Buscando una configuración óptima...');
                    barra2=0;
                    direc2=0;
                    h.NumElements=2;
                    
                    while direc2<=app.direc+app.toleracia
                        waitbar(barra2+0.2,barra,'Buscando una configuración óptima...');
                        h.PhaseShift=phaseShift(h,app.f,[app.azi;app.elev]);
                        h.PhaseShift;
                        [y,y2,y3]=arrayFactor(h,app.f,-180:2:180,-90:2:90);
                        app.toleracia;
                        direc2=5.9147867+0.9830405*max(max(y))+0.0021399*app.NelemX.Value-4.2767338-0.6414347;
                        h.NumElements=h.NumElements+1;
                        barra2=barra2+0.05;
                                if barra2>0.5
                                    barra2=0.5;
                                end
                    end
                    h.NumElements=h.NumElements-1;
                    h.PhaseShift=phaseShift(h,app.f,[app.azi;app.elev]);
                    h.PhaseShift
                    app.NelemX.Value=h.NumElements;
                    waitbar(1,barra,'Optimización terminada');
                end
                    
            else
                h= rectangularArray;                
                h.ColumnSpacing=app.espY;
                h.RowSpacing=app.espX;
                if app.cont1==0
                h.Size=[app.NelemX.Value app.NelemY.Value];

                h.PhaseShift=diferenciaDeFase(app.phaseFila,app.phase,app.NelemX.Value,app.NelemY.Value);

                else
                    barra = waitbar(0,'Buscando una configuración óptima...');
                    barra2=0;
                    n=4;
                    direc2=0;
                    while direc2<=app.direc+app.toleracia                        
                        if isprime(n)==0
                            p=conf_arreglo(n);                    
                            for i=1:numel(p)/2
                                waitbar(barra2+0.2,barra,'Buscando una configuración óptima...');
                                if direc2<=app.direc+app.toleracia
                                    app.NelemX.Value=p(i,1);
                                    app.NelemY.Value=p(i,2);
                                    h.Size=[app.NelemX.Value app.NelemY.Value];
                                    h.PhaseShift=phaseShift(h,app.f,[app.azi;app.elev]);
                                    h.PhaseShift;
                                    [y,y2,y3]=arrayFactor(h,app.f,-180:2:180,-90:2:90);
                                    if app.TipodeantenaSwitch.Value=="Patch"
                                        direc2=5.9147867+0.9830405*max(max(y))+0.0021399*app.NelemX.Value-4.2767338-0.6414347;
                                    else
                                        direc2=max(max(y));
                                    end
                                end
                                barra2=barra2+0.05;
                                if barra2>0.5
                                    barra2=0.5;
                                end
                            end
                            
                        end
                        n=n+1;
                    end
                    h.PhaseShift
                    waitbar(1,barra,'Optimización terminada');    
                end                
            end
            
            [y,y2,y3]=arrayFactor(h,app.f,-180:2:180,-90:2:90);
            app.direc2=max(max(y));
            max(max(y));
            y1=y+abs(min(min(y)));
            p1 = deg2rad(y2);
            t1 = deg2rad(y3);
            [p1,t1] = meshgrid(p1,t1);
            if app.tipoDeGrafico.Value=="Arreglo"
                y1=y1.*app.campoDipolo;
                max(max(y.*app.campoDipolo));
            elseif app.tipoDeGrafico.Value=="Antena"
                y1=abs(app.campoDipolo);
            end
            [X,Y,Z] = sph2cart(p1,t1,y1);
            surf(app.UIAxes,X,Y,Z,y1,'edgealpha',0.2)
            colorbar(app.UIAxes,'southoutside','color','w');
            
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            activarDipolo(app)
            Arreglo(app)
            graficos(app)
            parametros(app)
            calcular(app)
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {578, 578, 578};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {578, 578};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {268, '1x', 364};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end

        % Value changed function: TipodeantenaSwitch
        function TipodeantenaSwitchValueChanged(app, event)
            activarDipolo(app)
            Arreglo(app)
            parametros(app)
            calcular(app)           
        end

        % Value changed function: TipodearregloSwitch
        function TipodearregloSwitchValueChanged(app, event)
            Arreglo(app)
            parametros(app)
            calcular(app)  
        end

        % Value changing function: Fase
        function FaseValueChanging(app, event)
            app.Fase.Value = event.Value;
            parametros(app)
            calcular(app)       
        end

        % Value changing function: spaceX
        function spaceXValueChanging(app, event)
            app.spaceX.Value = event.Value;           
            parametros(app)
            calcular(app)
        end

        % Value changed function: tipoDeGrafico
        function tipoDeGraficoValueChanged(app, event)
            Arreglo(app)
            parametros(app)
            calcular(app)            
        end

        % Value changed function: spaceX1
        function spaceX1ValueChanged(app, event)
            app.spaceX.Value=app.spaceX1.Value;
            parametros(app)
            calcular(app)
        end

        % Value changed function: fase1
        function fase1ValueChanged(app, event)
            app.Fase.Value = app.fase1.Value;   
            parametros(app)
            calcular(app)
        end

        % Value changed function: Radio
        function RadioValueChanged(app, event)
      
        end

        % Value changing function: spaceY
        function spaceYValueChanging(app, event)
            app.spaceY.Value = event.Value;           
            parametros(app)
            calcular(app)
        end

        % Value changed function: spaceY1
        function spaceY1ValueChanged(app, event)
            app.spaceY.Value=app.spaceY1.Value;
            parametros(app)
            calcular(app)
        end

        % Value changing function: NelemX
        function NelemXValueChanging(app, event)
            app.NelemX.Value = event.Value;
            parametros(app)
            calcular(app)            
        end

        % Value changing function: NelemY
        function NelemYValueChanging(app, event)
            app.NelemY.Value = event.Value;
            parametros(app)
            calcular(app)
        end

        % Value changing function: Fase_2
        function Fase_2ValueChanging(app, event)
            app.Fase_2.Value = event.Value;
            parametros(app)
            calcular(app)  
        end

        % Value changed function: fase1_2
        function fase1_2ValueChanged(app, event)
            app.Fase_2.Value = app.fase1_2.Value;   
            parametros(app)
            calcular(app)
        end

        % Button pushed function: CalcularButton
        function CalcularButtonPushed(app, event)
            parametros(app)
            app.cont1=1;
            calcular(app)
            error=abs((app.direc2-app.direc)/app.direc)*100;
            x=(app.direc2);
            app.cont1=0;            
        end

        % Button pushed function: ExportaraCSTButton
        function ExportaraCSTButtonPushed(app, event)
            parametros(app)
            calcular(app)
            tipoDeAntena=app.TipodeantenaSwitch.Value;
            h=str2double(app.Separacion.Value);
            if tipoDeAntena=="Patch"
                exportarPatch(app.NelemX.Value,app.aux2,app.espX,app.espY,app.GroundX.Value...
                ,app.GroundY.Value,h,app.lambda,app.f); 
            else
                exportarDipolo(app.NelemX.Value,app.aux2,app.espX,app.espY,app.Radio.Value ...
                ,app.lambda,app.f);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1077 578];
            app.UIFigure.Name = 'Generador de Arreglos de Antenas';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {268, '1x', 364};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create TipodeantenaSwitchLabel
            app.TipodeantenaSwitchLabel = uilabel(app.LeftPanel);
            app.TipodeantenaSwitchLabel.HorizontalAlignment = 'center';
            app.TipodeantenaSwitchLabel.Position = [27 295 85 22];
            app.TipodeantenaSwitchLabel.Text = 'Tipo de antena';

            % Create TipodeantenaSwitch
            app.TipodeantenaSwitch = uiswitch(app.LeftPanel, 'slider');
            app.TipodeantenaSwitch.Items = {'Patch', 'Dipolo'};
            app.TipodeantenaSwitch.ValueChangedFcn = createCallbackFcn(app, @TipodeantenaSwitchValueChanged, true);
            app.TipodeantenaSwitch.Position = [47 276 45 20];
            app.TipodeantenaSwitch.Value = 'Dipolo';

            % Create CatactersticasdelarregloPanel
            app.CatactersticasdelarregloPanel = uipanel(app.LeftPanel);
            app.CatactersticasdelarregloPanel.Title = 'Catacterísticas del arreglo';
            app.CatactersticasdelarregloPanel.Position = [7 321 270 254];

            % Create Unidades
            app.Unidades = uilistbox(app.CatactersticasdelarregloPanel);
            app.Unidades.Items = {'MHz', 'GHz'};
            app.Unidades.ItemsData = {'1e6', '1e9'};
            app.Unidades.Position = [159 153 89 39];
            app.Unidades.Value = '1e9';

            % Create FrecuenciaEditFieldLabel
            app.FrecuenciaEditFieldLabel = uilabel(app.CatactersticasdelarregloPanel);
            app.FrecuenciaEditFieldLabel.HorizontalAlignment = 'right';
            app.FrecuenciaEditFieldLabel.Position = [74 199 65 22];
            app.FrecuenciaEditFieldLabel.Text = 'Frecuencia';

            % Create Frecuencia
            app.Frecuencia = uieditfield(app.CatactersticasdelarregloPanel, 'numeric');
            app.Frecuencia.Limits = [1 Inf];
            app.Frecuencia.Position = [154 199 94 22];
            app.Frecuencia.Value = 1;

            % Create DirectividaddBLabel
            app.DirectividaddBLabel = uilabel(app.CatactersticasdelarregloPanel);
            app.DirectividaddBLabel.HorizontalAlignment = 'right';
            app.DirectividaddBLabel.Position = [46 120 93 22];
            app.DirectividaddBLabel.Text = 'Directividad [dBi]';

            % Create Directividad
            app.Directividad = uieditfield(app.CatactersticasdelarregloPanel, 'numeric');
            app.Directividad.Limits = [4 Inf];
            app.Directividad.Position = [154 120 94 22];
            app.Directividad.Value = 4;

            % Create ToleranciaLabel
            app.ToleranciaLabel = uilabel(app.CatactersticasdelarregloPanel);
            app.ToleranciaLabel.HorizontalAlignment = 'right';
            app.ToleranciaLabel.Position = [58 88 81 22];
            app.ToleranciaLabel.Text = 'Tolerancia [%]';

            % Create Tolerancia
            app.Tolerancia = uieditfield(app.CatactersticasdelarregloPanel, 'numeric');
            app.Tolerancia.Limits = [0 100];
            app.Tolerancia.Position = [154 88 94 22];
            app.Tolerancia.Value = 1;

            % Create AzimuthgradosLabel
            app.AzimuthgradosLabel = uilabel(app.CatactersticasdelarregloPanel);
            app.AzimuthgradosLabel.HorizontalAlignment = 'right';
            app.AzimuthgradosLabel.Position = [43 56 96 22];
            app.AzimuthgradosLabel.Text = 'Azimuth [grados]';

            % Create azimuth
            app.azimuth = uieditfield(app.CatactersticasdelarregloPanel, 'numeric');
            app.azimuth.Limits = [0 360];
            app.azimuth.Position = [154 56 94 22];
            app.azimuth.Value = 1;

            % Create ElevacingradosLabel
            app.ElevacingradosLabel = uilabel(app.CatactersticasdelarregloPanel);
            app.ElevacingradosLabel.HorizontalAlignment = 'right';
            app.ElevacingradosLabel.Position = [35 20 104 22];
            app.ElevacingradosLabel.Text = 'Elevación [grados]';

            % Create elevacion
            app.elevacion = uieditfield(app.CatactersticasdelarregloPanel, 'numeric');
            app.elevacion.Limits = [0 360];
            app.elevacion.Position = [154 19 94 22];
            app.elevacion.Value = 1;

            % Create ParmetrosdelaantenaPanel
            app.ParmetrosdelaantenaPanel = uipanel(app.LeftPanel);
            app.ParmetrosdelaantenaPanel.Title = 'Parámetros de la antena';
            app.ParmetrosdelaantenaPanel.Position = [6 58 270 209];

            % Create RadiommLabel
            app.RadiommLabel = uilabel(app.ParmetrosdelaantenaPanel);
            app.RadiommLabel.HorizontalAlignment = 'right';
            app.RadiommLabel.Position = [73 154 67 22];
            app.RadiommLabel.Text = 'Radio [mm]';

            % Create Radio
            app.Radio = uieditfield(app.ParmetrosdelaantenaPanel, 'numeric');
            app.Radio.Limits = [1e-12 Inf];
            app.Radio.ValueChangedFcn = createCallbackFcn(app, @RadioValueChanged, true);
            app.Radio.Position = [155 154 94 22];
            app.Radio.Value = 1;

            % Create PlanodetierraXvecesLabel
            app.PlanodetierraXvecesLabel = uilabel(app.ParmetrosdelaantenaPanel);
            app.PlanodetierraXvecesLabel.HorizontalAlignment = 'right';
            app.PlanodetierraXvecesLabel.Position = [4 114 136 22];
            app.PlanodetierraXvecesLabel.Text = 'Plano de masa X [veces]';

            % Create GroundX
            app.GroundX = uieditfield(app.ParmetrosdelaantenaPanel, 'numeric');
            app.GroundX.Limits = [1 Inf];
            app.GroundX.Position = [155 114 94 22];
            app.GroundX.Value = 1;

            % Create PlanodetierraYvecesLabel
            app.PlanodetierraYvecesLabel = uilabel(app.ParmetrosdelaantenaPanel);
            app.PlanodetierraYvecesLabel.HorizontalAlignment = 'right';
            app.PlanodetierraYvecesLabel.Position = [4 74 136 22];
            app.PlanodetierraYvecesLabel.Text = 'Plano de masa Y [veces]';

            % Create GroundY
            app.GroundY = uieditfield(app.ParmetrosdelaantenaPanel, 'numeric');
            app.GroundY.Limits = [1 Inf];
            app.GroundY.Position = [155 74 94 22];
            app.GroundY.Value = 1;

            % Create SeparacinentreconductoresmmLabel
            app.SeparacinentreconductoresmmLabel = uilabel(app.ParmetrosdelaantenaPanel);
            app.SeparacinentreconductoresmmLabel.HorizontalAlignment = 'right';
            app.SeparacinentreconductoresmmLabel.Position = [67 4 71 56];
            app.SeparacinentreconductoresmmLabel.Text = {'Separación '; 'entre'; 'conductores'; '[mm]'};

            % Create Separacion
            app.Separacion = uidropdown(app.ParmetrosdelaantenaPanel);
            app.Separacion.Items = {'0.127', '0.254', '0.381', '0.508', '0.787', '1.575', '3.175'};
            app.Separacion.Position = [152 21 100 22];
            app.Separacion.Value = '0.127';

            % Create ExportaraCSTButton
            app.ExportaraCSTButton = uibutton(app.LeftPanel, 'push');
            app.ExportaraCSTButton.ButtonPushedFcn = createCallbackFcn(app, @ExportaraCSTButtonPushed, true);
            app.ExportaraCSTButton.Position = [90 23 100 22];
            app.ExportaraCSTButton.Text = 'Exportar a CST';

            % Create CalcularButton
            app.CalcularButton = uibutton(app.LeftPanel, 'push');
            app.CalcularButton.ButtonPushedFcn = createCallbackFcn(app, @CalcularButtonPushed, true);
            app.CalcularButton.Position = [155 278 100 22];
            app.CalcularButton.Text = 'Calcular';

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.BackgroundColor = [0 0 0];
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.CenterPanel);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.PlotBoxAspectRatio = [1 1.07474226804124 1];
            app.UIAxes.Color = 'none';
            app.UIAxes.BackgroundColor = [0 0 0];
            app.UIAxes.Position = [1 116 435 459];

            % Create tipoDeGrafico
            app.tipoDeGrafico = uiknob(app.CenterPanel, 'discrete');
            app.tipoDeGrafico.Items = {'Antena', 'Factor de arreglo', 'Arreglo'};
            app.tipoDeGrafico.ValueChangedFcn = createCallbackFcn(app, @tipoDeGraficoValueChanged, true);
            app.tipoDeGrafico.Tooltip = {'Permite seleccionar el patrón de radiación que se desea visualizar'};
            app.tipoDeGrafico.FontColor = [1 1 1];
            app.tipoDeGrafico.Position = [178 27 60 60];
            app.tipoDeGrafico.Value = 'Antena';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create TipodearregloLabel
            app.TipodearregloLabel = uilabel(app.RightPanel);
            app.TipodearregloLabel.HorizontalAlignment = 'center';
            app.TipodearregloLabel.Position = [79 513 43 42];
            app.TipodearregloLabel.Text = {'Tipo'; 'de'; 'arreglo'};

            % Create TipodearregloSwitch
            app.TipodearregloSwitch = uiswitch(app.RightPanel, 'slider');
            app.TipodearregloSwitch.Items = {'Lineal', 'Planar'};
            app.TipodearregloSwitch.ValueChangedFcn = createCallbackFcn(app, @TipodearregloSwitchValueChanged, true);
            app.TipodearregloSwitch.Position = [167 522 45 20];
            app.TipodearregloSwitch.Value = 'Lineal';

            % Create ColumnasPanel
            app.ColumnasPanel = uipanel(app.RightPanel);
            app.ColumnasPanel.Title = 'Columnas';
            app.ColumnasPanel.Position = [185 6 170 493];

            % Create fase1
            app.fase1 = uieditfield(app.ColumnasPanel, 'numeric');
            app.fase1.Limits = [0 Inf];
            app.fase1.ValueChangedFcn = createCallbackFcn(app, @fase1ValueChanged, true);
            app.fase1.Position = [35 439 94 22];
            app.fase1.Value = 1;

            % Create spaceY1
            app.spaceY1 = uieditfield(app.ColumnasPanel, 'numeric');
            app.spaceY1.Limits = [0 Inf];
            app.spaceY1.ValueChangedFcn = createCallbackFcn(app, @spaceY1ValueChanged, true);
            app.spaceY1.Position = [37 249 94 22];
            app.spaceY1.Value = 1;

            % Create FasegradosLabel_2
            app.FasegradosLabel_2 = uilabel(app.ColumnasPanel);
            app.FasegradosLabel_2.HorizontalAlignment = 'center';
            app.FasegradosLabel_2.Position = [43.5 281 79 22];
            app.FasegradosLabel_2.Text = 'Fase [grados]';

            % Create Fase
            app.Fase = uiknob(app.ColumnasPanel, 'continuous');
            app.Fase.Limits = [0 360];
            app.Fase.MajorTicks = [0 30 60 90 120 150 180 210 240 270 300 330 360];
            app.Fase.ValueChangingFcn = createCallbackFcn(app, @FaseValueChanging, true);
            app.Fase.Tooltip = {'Valor del desplazamiento de fase uniforme en grados'; ''};
            app.Fase.Position = [52 337 60 60];

            % Create EspaciamientolongituddeondaLabel_2
            app.EspaciamientolongituddeondaLabel_2 = uilabel(app.ColumnasPanel);
            app.EspaciamientolongituddeondaLabel_2.HorizontalAlignment = 'center';
            app.EspaciamientolongituddeondaLabel_2.Position = [34.5 85 101 28];
            app.EspaciamientolongituddeondaLabel_2.Text = {'Espaciamiento'; '[longitud de onda]'};

            % Create spaceY
            app.spaceY = uiknob(app.ColumnasPanel, 'continuous');
            app.spaceY.Limits = [0 5];
            app.spaceY.MajorTicks = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5];
            app.spaceY.ValueChangingFcn = createCallbackFcn(app, @spaceYValueChanging, true);
            app.spaceY.Tooltip = {'Valor del espaciamiento entre elementos en función de la longitud de onda'};
            app.spaceY.Position = [54 147 60 60];

            % Create NmerodeelementosLabel
            app.NmerodeelementosLabel = uilabel(app.ColumnasPanel);
            app.NmerodeelementosLabel.HorizontalAlignment = 'center';
            app.NmerodeelementosLabel.Position = [47 11 65 28];
            app.NmerodeelementosLabel.Text = {'Número de'; 'elementos'};

            % Create NelemY
            app.NelemY = uispinner(app.ColumnasPanel);
            app.NelemY.ValueChangingFcn = createCallbackFcn(app, @NelemYValueChanging, true);
            app.NelemY.Limits = [2 Inf];
            app.NelemY.Position = [36 44 100 22];
            app.NelemY.Value = 2;

            % Create FilasPanel
            app.FilasPanel = uipanel(app.RightPanel);
            app.FilasPanel.Title = 'Filas';
            app.FilasPanel.Position = [6 6 180 493];

            % Create spaceX1
            app.spaceX1 = uieditfield(app.FilasPanel, 'numeric');
            app.spaceX1.Limits = [0 Inf];
            app.spaceX1.ValueChangedFcn = createCallbackFcn(app, @spaceX1ValueChanged, true);
            app.spaceX1.Position = [43 249 94 22];
            app.spaceX1.Value = 1;

            % Create fase1_2
            app.fase1_2 = uieditfield(app.FilasPanel, 'numeric');
            app.fase1_2.Limits = [0 Inf];
            app.fase1_2.ValueChangedFcn = createCallbackFcn(app, @fase1_2ValueChanged, true);
            app.fase1_2.Position = [42 439 94 22];
            app.fase1_2.Value = 1;

            % Create EspaciamientolongituddeondaLabel
            app.EspaciamientolongituddeondaLabel = uilabel(app.FilasPanel);
            app.EspaciamientolongituddeondaLabel.HorizontalAlignment = 'center';
            app.EspaciamientolongituddeondaLabel.Position = [41 85 101 28];
            app.EspaciamientolongituddeondaLabel.Text = {'Espaciamiento'; '[longitud de onda]'};

            % Create spaceX
            app.spaceX = uiknob(app.FilasPanel, 'continuous');
            app.spaceX.Limits = [0 5];
            app.spaceX.MajorTicks = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5];
            app.spaceX.ValueChangingFcn = createCallbackFcn(app, @spaceXValueChanging, true);
            app.spaceX.Tooltip = {'Valor del espaciamiento entre elementos en función de la longitud de onda'};
            app.spaceX.Position = [60 147 60 60];

            % Create NmerodeelementosLabel_2
            app.NmerodeelementosLabel_2 = uilabel(app.FilasPanel);
            app.NmerodeelementosLabel_2.HorizontalAlignment = 'center';
            app.NmerodeelementosLabel_2.Position = [56 11 65 28];
            app.NmerodeelementosLabel_2.Text = {'Número de'; 'elementos'};

            % Create NelemX
            app.NelemX = uispinner(app.FilasPanel);
            app.NelemX.ValueChangingFcn = createCallbackFcn(app, @NelemXValueChanging, true);
            app.NelemX.Limits = [2 Inf];
            app.NelemX.Position = [45 44 100 22];
            app.NelemX.Value = 2;

            % Create FasegradosLabel
            app.FasegradosLabel = uilabel(app.FilasPanel);
            app.FasegradosLabel.HorizontalAlignment = 'center';
            app.FasegradosLabel.Position = [49 281 82 22];
            app.FasegradosLabel.Text = 'Fase [grados] ';

            % Create Fase_2
            app.Fase_2 = uiknob(app.FilasPanel, 'continuous');
            app.Fase_2.Limits = [0 360];
            app.Fase_2.MajorTicks = [0 30 60 90 120 150 180 210 240 270 300 330 360];
            app.Fase_2.ValueChangingFcn = createCallbackFcn(app, @Fase_2ValueChanging, true);
            app.Fase_2.Tooltip = {'Valor del desplazamiento de fase uniforme en grados'; ''};
            app.Fase_2.Position = [59 337 60 60];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = array_generator

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end