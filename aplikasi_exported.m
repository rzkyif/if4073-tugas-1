classdef aplikasi_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        HistogramTab                    matlab.ui.container.Tab
        OutputPanel                     matlab.ui.container.Panel
        ImageHistO                      matlab.ui.control.Image
        UIAxesHistO                     matlab.ui.control.UIAxes
        InputPanel                      matlab.ui.container.Panel
        ShowimhistforComparisonButton   matlab.ui.control.Button
        ImageListBoxHist                matlab.ui.control.ListBox
        ImageListBoxLabel               matlab.ui.control.Label
        ContrastEnhancementTab          matlab.ui.container.Tab
        OutputPanel_2                   matlab.ui.container.Panel
        ResultPanel_2                   matlab.ui.container.Panel
        ImageContR                      matlab.ui.control.Image
        UIAxesContR                     matlab.ui.control.UIAxes
        OriginalPanel_2                 matlab.ui.container.Panel
        ImageContO                      matlab.ui.control.Image
        UIAxesContO                     matlab.ui.control.UIAxes
        InputPanel_2                    matlab.ui.container.Panel
        ImageListBoxCont                matlab.ui.control.ListBox
        ImageListBox_2Label             matlab.ui.control.Label
        HistogramEqualizationTab        matlab.ui.container.Tab
        OutputPanel_3                   matlab.ui.container.Panel
        ResultPanel_3                   matlab.ui.container.Panel
        ImageEquaR                      matlab.ui.control.Image
        UIAxesEquaR                     matlab.ui.control.UIAxes
        OriginalPanel_3                 matlab.ui.container.Panel
        ImageEquaO                      matlab.ui.control.Image
        UIAxesEquaO                     matlab.ui.control.UIAxes
        InputPanel_3                    matlab.ui.container.Panel
        ShowhisteqforComparisonButton   matlab.ui.control.Button
        ImageListBoxEqua                matlab.ui.control.ListBox
        ImageListBox_3Label             matlab.ui.control.Label
        HistogramSpecificationTab       matlab.ui.container.Tab
        OutputPanel_4                   matlab.ui.container.Panel
        ResultPanel_4                   matlab.ui.container.Panel
        ImageSpecR                      matlab.ui.control.Image
        UIAxesSpecR                     matlab.ui.control.UIAxes
        OriginalPanel_4                 matlab.ui.container.Panel
        ImageSpecRef                    matlab.ui.control.Image
        ImageSpecO                      matlab.ui.control.Image
        UIAxesSpecRef                   matlab.ui.control.UIAxes
        UIAxesSpecO                     matlab.ui.control.UIAxes
        InputPanel_4                    matlab.ui.container.Panel
        ShowimhistmatchforComparisonButton  matlab.ui.control.Button
        ReferenceEditField              matlab.ui.control.EditField
        ReferenceEditFieldLabel         matlab.ui.control.Label
        ImageListBoxSpec                matlab.ui.control.ListBox
        ImageListBox_4Label             matlab.ui.control.Label
        HistogramEqHSVTab               matlab.ui.container.Tab
        OutputPanel_5                   matlab.ui.container.Panel
        ResultPanel_5                   matlab.ui.container.Panel
        ImageEquaVR                     matlab.ui.control.Image
        UIAxesEquaVR                    matlab.ui.control.UIAxes
        OriginalPanel_5                 matlab.ui.container.Panel
        ImageEquaVO                     matlab.ui.control.Image
        UIAxesEquaVO                    matlab.ui.control.UIAxes
        InputPanel_5                    matlab.ui.container.Panel
        ShowhisteqforComparisonButtonV  matlab.ui.control.Button
        ImageListBoxEquaV               matlab.ui.control.ListBox
        ImageListBox_3Label_2           matlab.ui.control.Label
    end

    
    properties (Access = private)
        CurrentImage
        EnhancedImage
        EqualizedImage
        ReferenceImage
        SpecifiedImage
    end
    
    methods (Access = private)
        
        % Fungsi generasi histogram
        function results = GenerateHistogram(~, aImage, aAxis)

            % Hitung jumlah tiap gray level dalam gambar
            results = zeros(256,3);
            s = size(aImage);
            for x = 1:s(1)
                for y = 1:s(2)
                    for z = 1:s(3)
                        v = aImage(x,y,z);
                        results(v+1,z) = results(v+1,z) + 1;
                    end
                end
            end
            
            % Tampilkan hasil pada graf
            if exist('aAxis', 'var')
                x = zeros(256,1);
                for i = 1:256
                    x(i) = i-1;
                end
                b = bar(aAxis, x, results, 1, "hist");
                b(1).FaceColor = [1 0 0]; b(1).EdgeColor = 'none';
                b(2).FaceColor = [0 1 0]; b(2).EdgeColor = 'none';
                b(3).FaceColor = [0 0 1]; b(3).EdgeColor = 'none';
                zoom(aAxis,'reset');
            end
        end
        
        % Fungsi peregangan kontras
        function results = Enhance(~, aImage, aImageComponent)

            % Lakukan peregangan kontras pada gambar
            rmin = min(aImage(:));
            rmax = max(aImage(:));
            results = (aImage - rmin).*(255/(rmax - rmin));

            % Tampilkan hasil pada graf
            if exist('aImageComponent', 'var')
                aImageComponent.ImageSource = results;
            end
        end
        
        % Fungsi perataan histogram
        function results = Equalize(~, aImage, aImageComponent)

            % Buat histogram dari gambar
            N = zeros(256,1);
            n = numel(aImage);
            for i = 1:n
                v = aImage(i);
                N(v+1) = N(v+1) + 1;
            end

            % Buat peta transformasi
            map = round(cumsum(N / n) * 255);

            % Terapkan peta transformasi pada gambar
            results = aImage;
            for i = 1:n
                results(i) = map(results(i)+1);
            end

            % Tampilkan hasil pada graf
            if exist('aImageComponent', 'var')
                aImageComponent.ImageSource = results;
            end
        end
        
        % Fungsi perataan histogram pada tiap saluran RGB
        function [rImage,rMap] = EqualizeRGB(~, aImage)

            % Buat histogram dari gambar
            s = size(aImage);
            N = zeros(256,3);
            for x = 1:s(1)
                for y = 1:s(2)
                    for z = 1:s(3)
                        v = aImage(x,y,z);
                        N(v+1,z) = N(v+1,z) + 1;
                    end
                end
            end

            % Buat peta transformasi
            rMap = cumsum(N / (s(1)*s(2))) * 255;
            roundedMap = round(rMap);

            % Terapkan peta transformasi pada gambar
            rImage = aImage;
            for x = 1:s(1)
                for y = 1:s(2)
                    for z = 1:s(3)
                        rImage(x,y,z) = roundedMap(rImage(x,y,z)+1, z);
                    end
                end
            end
        end
        
        % Fungsi spesifikasi histogram
        function results = Specify(app, aImage, aRefImage, aImageComponent)

            % Lakukan perataan histogram pada gambar asal
            S = app.EqualizeRGB(aImage);

            % Lakukan perataan histogram pada gambar referensi
            [~, g] = app.EqualizeRGB(aRefImage);

            % Buat peta transformasi inverse dari hasil perataan 
            % histogram pada gambar referensi
            gg = zeros(256,3);
            for z = 1:3
                for x = 1:256
                    minv = 256;
                    mini = 1;
                    for i = 1:256
                        test = abs(g(i,z) - x);
                        if test < minv
                            minv = test;
                            mini = i;
                        end
                    end
                    gg(x,z) = mini;
                end
            end

            % Terapkan peta transformasi inverse pada hasil perataan
            % histogram pada gambar asal
            results = aImage;
            s = size(aImage);
            for x = 1:s(1)
                for y = 1:s(2)
                    for z = 1:s(3)
                        results(x,y,z) = gg(S(x,y,z)+1,z);
                    end
                end
            end

            % Tampilkan hasil pada graf
            if exist('aImageComponent', 'var')
                aImageComponent.ImageSource = results;
            end
        end

        % Fungsi perataan histogram dalam channel HSV
        function results = EqualizeHSV(~, aImage, aImageComponent)

            % Histogram pada channel HSV
            hsvImage = rgb2hsv(aImage);
            vImage = uint8(hsvImage(:,:,3) * 255);
            s = size(vImage);
            N = zeros(256,1);
            for y = 1:s(1)
                for x = 1:s(2)
                    v = vImage(y,x);
                    N(v+1) = N(v+1) + 1;
                end
            end
        
            % peta transformasi
            map = round(cumsum(N / (s(1)*s(2))) * 255);
        
            for y = 1:s(1)
                for x = 1:s(2)
                    hsvImage(y,x,3) = double(map(vImage(y,x)+1)) / 255;
                end
            end
        
            results = uint8(hsv2rgb(hsvImage) * 255);
        
            if exist('aImageComponent', 'var')
                aImageComponent.ImageSource = results;
            end
        
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Inisialisasi tab histogram
            app.ImageListBoxHistValueChanged()

            % Inisialisasi tab peregangan kontras
            app.ImageListBoxContValueChanged()

            % Inisialisasi tab perataan histogram
            app.ImageListBoxEquaValueChanged()

            % Inisialisasi tab spesifikasi histogram
            app.ImageListBoxSpecValueChanged()
        end

        % Value changed function: ImageListBoxHist
        function ImageListBoxHistValueChanged(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxHist.Value));
            app.ImageHistO.ImageSource = app.CurrentImage;
            app.GenerateHistogram(app.CurrentImage, app.UIAxesHistO);
        end

        % Button pushed function: ShowimhistforComparisonButton
        function ShowimhistforComparisonButtonPushed(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxHist.Value));
            N = [imhist(app.CurrentImage(:,:,1)) imhist(app.CurrentImage(:,:,2)) imhist(app.CurrentImage(:,:,3))];
            b = bar(N, 1, "hist");
            b(1).FaceColor = [1 0 0]; b(1).EdgeColor = 'none';
            b(2).FaceColor = [0 1 0]; b(2).EdgeColor = 'none';
            b(3).FaceColor = [0 0 1]; b(3).EdgeColor = 'none';
        end

        % Value changed function: ImageListBoxCont
        function ImageListBoxContValueChanged(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxCont.Value));
            app.ImageContO.ImageSource = app.CurrentImage;
            app.GenerateHistogram(app.CurrentImage, app.UIAxesContO);
            app.EnhancedImage = app.Enhance(app.CurrentImage, app.ImageContR);
            app.GenerateHistogram(app.EnhancedImage, app.UIAxesContR);
        end

        % Value changed function: ImageListBoxEqua
        function ImageListBoxEquaValueChanged(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxEqua.Value));
            app.ImageEquaO.ImageSource = app.CurrentImage;
            app.GenerateHistogram(app.CurrentImage, app.UIAxesEquaO);
            app.EqualizedImage = app.Equalize(app.CurrentImage, app.ImageEquaR);
            app.GenerateHistogram(app.EqualizedImage, app.UIAxesEquaR);
        end

        % Button pushed function: ShowhisteqforComparisonButton
        function ShowhisteqforComparisonButtonPushed(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxEqua.Value));
            eq = histeq(app.CurrentImage, 256);
            figure,imshow(eq);
            figure
            N = [imhist(eq(:,:,1)) imhist(eq(:,:,2)) imhist(eq(:,:,3))];
            b = bar(N, 1, "hist");
            b(1).FaceColor = [1 0 0]; b(1).EdgeColor = 'none';
            b(2).FaceColor = [0 1 0]; b(2).EdgeColor = 'none';
            b(3).FaceColor = [0 0 1]; b(3).EdgeColor = 'none';
        end

        % Value changed function: ImageListBoxSpec
        function ImageListBoxSpecValueChanged(app, event)
            imagePath = strcat('images/', app.ImageListBoxSpec.Value);
            app.CurrentImage = imread(imagePath);
            app.ReferenceEditField.Value = strrep(imagePath,'_o.','_r.');
            app.ReferenceImage = imread(app.ReferenceEditField.Value);
            app.ImageSpecRef.ImageSource = app.ReferenceImage;
            app.GenerateHistogram(app.ReferenceImage, app.UIAxesSpecRef);
            app.ImageSpecO.ImageSource = app.CurrentImage;
            app.GenerateHistogram(app.CurrentImage, app.UIAxesSpecO);
            app.SpecifiedImage = app.Specify(app.CurrentImage, app.ReferenceImage, app.ImageSpecR);
            app.GenerateHistogram(app.SpecifiedImage, app.UIAxesSpecR);
        end

        % Button pushed function: ShowimhistmatchforComparisonButton
        function ShowimhistmatchforComparisonButtonPushed(app, event)
            imagePath = strcat('images/', app.ImageListBoxSpec.Value);
            app.CurrentImage = imread(imagePath);
            app.ReferenceEditField.Value = strrep(imagePath,'_o.','_r.');
            app.ReferenceImage = imread(app.ReferenceEditField.Value);
            r = imhistmatch(app.CurrentImage, app.ReferenceImage, 256);
            figure,imshow(r);
            figure
            N = [imhist(r(:,:,1)) imhist(r(:,:,2)) imhist(r(:,:,3))];
            b = bar(N, 1, "hist");
            b(1).FaceColor = [1 0 0]; b(1).EdgeColor = 'none';
            b(2).FaceColor = [0 1 0]; b(2).EdgeColor = 'none';
            b(3).FaceColor = [0 0 1]; b(3).EdgeColor = 'none';
        end

        % Value changed function: ImageListBoxEquaV
        function ImageListBoxEquaVValueChanged(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxEquaV.Value));
            app.ImageEquaVO.ImageSource = app.CurrentImage;
            app.GenerateHistogram(app.CurrentImage, app.UIAxesEquaVO);
            app.EqualizedImage = app.EqualizeHSV(app.CurrentImage, app.ImageEquaVR);
            app.GenerateHistogram(app.EqualizedImage, app.UIAxesEquaVR);
        end

        % Button pushed function: ShowhisteqforComparisonButtonV
        function ShowhisteqforComparisonButtonVPushed(app, event)
            app.CurrentImage = imread(strcat('images/', app.ImageListBoxEquaV.Value));
            eq = histeq(app.CurrentImage, 256);
            figure,imshow(eq);
            figure
            N = [imhist(eq(:,:,1)) imhist(eq(:,:,2)) imhist(eq(:,:,3))];
            b = bar(N, 1, "hist");
            b(1).FaceColor = [1 0 0]; b(1).EdgeColor = 'none';
            b(2).FaceColor = [0 1 0]; b(2).EdgeColor = 'none';
            b(3).FaceColor = [0 0 1]; b(3).EdgeColor = 'none';
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 674];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 674];

            % Create HistogramTab
            app.HistogramTab = uitab(app.TabGroup);
            app.HistogramTab.Title = 'Histogram';

            % Create InputPanel
            app.InputPanel = uipanel(app.HistogramTab);
            app.InputPanel.Title = 'Input';
            app.InputPanel.Position = [1 429 639 221];

            % Create ImageListBoxLabel
            app.ImageListBoxLabel = uilabel(app.InputPanel);
            app.ImageListBoxLabel.HorizontalAlignment = 'right';
            app.ImageListBoxLabel.Position = [19 170 39 22];
            app.ImageListBoxLabel.Text = 'Image';

            % Create ImageListBoxHist
            app.ImageListBoxHist = uilistbox(app.InputPanel);
            app.ImageListBoxHist.Items = {'hist_1.png', 'hist_2.jpg', 'hist_3.jpg', 'hist_4.jpg', 'hist_5.png', 'hist_6.png'};
            app.ImageListBoxHist.ValueChangedFcn = createCallbackFcn(app, @ImageListBoxHistValueChanged, true);
            app.ImageListBoxHist.Position = [73 44 553 150];
            app.ImageListBoxHist.Value = 'hist_1.png';

            % Create ShowimhistforComparisonButton
            app.ShowimhistforComparisonButton = uibutton(app.InputPanel, 'push');
            app.ShowimhistforComparisonButton.ButtonPushedFcn = createCallbackFcn(app, @ShowimhistforComparisonButtonPushed, true);
            app.ShowimhistforComparisonButton.Position = [19 13 607 22];
            app.ShowimhistforComparisonButton.Text = 'Show "imhist" for Comparison';

            % Create OutputPanel
            app.OutputPanel = uipanel(app.HistogramTab);
            app.OutputPanel.Title = 'Output';
            app.OutputPanel.Position = [1 1 639 429];

            % Create UIAxesHistO
            app.UIAxesHistO = uiaxes(app.OutputPanel);
            xlabel(app.UIAxesHistO, 'X')
            ylabel(app.UIAxesHistO, 'Y')
            zlabel(app.UIAxesHistO, 'Z')
            app.UIAxesHistO.Position = [1 9 637 210];

            % Create ImageHistO
            app.ImageHistO = uiimage(app.OutputPanel);
            app.ImageHistO.Position = [-1 218 639 182];

            % Create ContrastEnhancementTab
            app.ContrastEnhancementTab = uitab(app.TabGroup);
            app.ContrastEnhancementTab.Title = 'Contrast Enhancement';

            % Create InputPanel_2
            app.InputPanel_2 = uipanel(app.ContrastEnhancementTab);
            app.InputPanel_2.Title = 'Input';
            app.InputPanel_2.Position = [1 429 639 221];

            % Create ImageListBox_2Label
            app.ImageListBox_2Label = uilabel(app.InputPanel_2);
            app.ImageListBox_2Label.HorizontalAlignment = 'right';
            app.ImageListBox_2Label.Position = [19 170 39 22];
            app.ImageListBox_2Label.Text = 'Image';

            % Create ImageListBoxCont
            app.ImageListBoxCont = uilistbox(app.InputPanel_2);
            app.ImageListBoxCont.Items = {'cont_1.jpg', 'cont_2.jpg', 'cont_3.jpg', 'cont_4.jpg', 'cont_5.png', 'cont_6.png'};
            app.ImageListBoxCont.ValueChangedFcn = createCallbackFcn(app, @ImageListBoxContValueChanged, true);
            app.ImageListBoxCont.Position = [73 13 553 181];
            app.ImageListBoxCont.Value = 'cont_1.jpg';

            % Create OutputPanel_2
            app.OutputPanel_2 = uipanel(app.ContrastEnhancementTab);
            app.OutputPanel_2.Title = 'Output';
            app.OutputPanel_2.Position = [1 1 639 429];

            % Create OriginalPanel_2
            app.OriginalPanel_2 = uipanel(app.OutputPanel_2);
            app.OriginalPanel_2.Title = 'Original';
            app.OriginalPanel_2.Position = [1 -1 320 410];

            % Create UIAxesContO
            app.UIAxesContO = uiaxes(app.OriginalPanel_2);
            xlabel(app.UIAxesContO, 'X')
            ylabel(app.UIAxesContO, 'Y')
            zlabel(app.UIAxesContO, 'Z')
            app.UIAxesContO.Position = [1 11 319 190];

            % Create ImageContO
            app.ImageContO = uiimage(app.OriginalPanel_2);
            app.ImageContO.Position = [1 201 321 181];

            % Create ResultPanel_2
            app.ResultPanel_2 = uipanel(app.OutputPanel_2);
            app.ResultPanel_2.Title = 'Result';
            app.ResultPanel_2.Position = [320 -1 318 410];

            % Create UIAxesContR
            app.UIAxesContR = uiaxes(app.ResultPanel_2);
            xlabel(app.UIAxesContR, 'X')
            ylabel(app.UIAxesContR, 'Y')
            zlabel(app.UIAxesContR, 'Z')
            app.UIAxesContR.Position = [2 11 316 190];

            % Create ImageContR
            app.ImageContR = uiimage(app.ResultPanel_2);
            app.ImageContR.Position = [2 201 316 181];

            % Create HistogramEqualizationTab
            app.HistogramEqualizationTab = uitab(app.TabGroup);
            app.HistogramEqualizationTab.Title = 'Histogram Equalization';

            % Create InputPanel_3
            app.InputPanel_3 = uipanel(app.HistogramEqualizationTab);
            app.InputPanel_3.Title = 'Input';
            app.InputPanel_3.Position = [1 429 639 221];

            % Create ImageListBox_3Label
            app.ImageListBox_3Label = uilabel(app.InputPanel_3);
            app.ImageListBox_3Label.HorizontalAlignment = 'right';
            app.ImageListBox_3Label.Position = [19 170 39 22];
            app.ImageListBox_3Label.Text = 'Image';

            % Create ImageListBoxEqua
            app.ImageListBoxEqua = uilistbox(app.InputPanel_3);
            app.ImageListBoxEqua.Items = {'equa_1.jpg', 'equa_2.jpg', 'equa_3.png', 'equa_4.jpg', 'equa_5.png', 'equa_6.png'};
            app.ImageListBoxEqua.ValueChangedFcn = createCallbackFcn(app, @ImageListBoxEquaValueChanged, true);
            app.ImageListBoxEqua.Position = [73 44 553 150];
            app.ImageListBoxEqua.Value = 'equa_1.jpg';

            % Create ShowhisteqforComparisonButton
            app.ShowhisteqforComparisonButton = uibutton(app.InputPanel_3, 'push');
            app.ShowhisteqforComparisonButton.ButtonPushedFcn = createCallbackFcn(app, @ShowhisteqforComparisonButtonPushed, true);
            app.ShowhisteqforComparisonButton.Position = [19 13 607 22];
            app.ShowhisteqforComparisonButton.Text = 'Show "histeq" for Comparison';

            % Create OutputPanel_3
            app.OutputPanel_3 = uipanel(app.HistogramEqualizationTab);
            app.OutputPanel_3.Title = 'Output';
            app.OutputPanel_3.Position = [1 1 639 429];

            % Create OriginalPanel_3
            app.OriginalPanel_3 = uipanel(app.OutputPanel_3);
            app.OriginalPanel_3.Title = 'Original';
            app.OriginalPanel_3.Position = [1 -1 320 410];

            % Create UIAxesEquaO
            app.UIAxesEquaO = uiaxes(app.OriginalPanel_3);
            xlabel(app.UIAxesEquaO, 'X')
            ylabel(app.UIAxesEquaO, 'Y')
            zlabel(app.UIAxesEquaO, 'Z')
            app.UIAxesEquaO.Position = [1 11 319 190];

            % Create ImageEquaO
            app.ImageEquaO = uiimage(app.OriginalPanel_3);
            app.ImageEquaO.Position = [1 201 319 181];

            % Create ResultPanel_3
            app.ResultPanel_3 = uipanel(app.OutputPanel_3);
            app.ResultPanel_3.Title = 'Result';
            app.ResultPanel_3.Position = [320 -1 318 410];

            % Create UIAxesEquaR
            app.UIAxesEquaR = uiaxes(app.ResultPanel_3);
            xlabel(app.UIAxesEquaR, 'X')
            ylabel(app.UIAxesEquaR, 'Y')
            zlabel(app.UIAxesEquaR, 'Z')
            app.UIAxesEquaR.Position = [2 10 316 191];

            % Create ImageEquaR
            app.ImageEquaR = uiimage(app.ResultPanel_3);
            app.ImageEquaR.Position = [2 200 316 181];

            % Create HistogramSpecificationTab
            app.HistogramSpecificationTab = uitab(app.TabGroup);
            app.HistogramSpecificationTab.Title = 'Histogram Specification';

            % Create InputPanel_4
            app.InputPanel_4 = uipanel(app.HistogramSpecificationTab);
            app.InputPanel_4.Title = 'Input';
            app.InputPanel_4.Position = [1 429 639 221];

            % Create ImageListBox_4Label
            app.ImageListBox_4Label = uilabel(app.InputPanel_4);
            app.ImageListBox_4Label.HorizontalAlignment = 'right';
            app.ImageListBox_4Label.Position = [19 170 39 22];
            app.ImageListBox_4Label.Text = 'Image';

            % Create ImageListBoxSpec
            app.ImageListBoxSpec = uilistbox(app.InputPanel_4);
            app.ImageListBoxSpec.Items = {'spec_1_o.png', 'spec_2_o.jpg', 'spec_3_o.png', 'spec_4_o.png'};
            app.ImageListBoxSpec.ValueChangedFcn = createCallbackFcn(app, @ImageListBoxSpecValueChanged, true);
            app.ImageListBoxSpec.Position = [73 73 553 121];
            app.ImageListBoxSpec.Value = 'spec_1_o.png';

            % Create ReferenceEditFieldLabel
            app.ReferenceEditFieldLabel = uilabel(app.InputPanel_4);
            app.ReferenceEditFieldLabel.HorizontalAlignment = 'right';
            app.ReferenceEditFieldLabel.Position = [19 44 61 22];
            app.ReferenceEditFieldLabel.Text = 'Reference';

            % Create ReferenceEditField
            app.ReferenceEditField = uieditfield(app.InputPanel_4, 'text');
            app.ReferenceEditField.Editable = 'off';
            app.ReferenceEditField.Position = [95 44 531 22];
            app.ReferenceEditField.Value = 'spec_1_r.png';

            % Create ShowimhistmatchforComparisonButton
            app.ShowimhistmatchforComparisonButton = uibutton(app.InputPanel_4, 'push');
            app.ShowimhistmatchforComparisonButton.ButtonPushedFcn = createCallbackFcn(app, @ShowimhistmatchforComparisonButtonPushed, true);
            app.ShowimhistmatchforComparisonButton.Position = [19 13 607 22];
            app.ShowimhistmatchforComparisonButton.Text = {'Show "imhistmatch" for Comparison'; ''};

            % Create OutputPanel_4
            app.OutputPanel_4 = uipanel(app.HistogramSpecificationTab);
            app.OutputPanel_4.Title = 'Output';
            app.OutputPanel_4.Position = [1 1 639 429];

            % Create OriginalPanel_4
            app.OriginalPanel_4 = uipanel(app.OutputPanel_4);
            app.OriginalPanel_4.Title = 'Original';
            app.OriginalPanel_4.Position = [1 -1 391 410];

            % Create UIAxesSpecO
            app.UIAxesSpecO = uiaxes(app.OriginalPanel_4);
            xlabel(app.UIAxesSpecO, 'X')
            ylabel(app.UIAxesSpecO, 'Y')
            zlabel(app.UIAxesSpecO, 'Z')
            app.UIAxesSpecO.Position = [1 11 194 190];

            % Create UIAxesSpecRef
            app.UIAxesSpecRef = uiaxes(app.OriginalPanel_4);
            xlabel(app.UIAxesSpecRef, 'X')
            ylabel(app.UIAxesSpecRef, 'Y')
            zlabel(app.UIAxesSpecRef, 'Z')
            app.UIAxesSpecRef.Position = [194 11 197 190];

            % Create ImageSpecO
            app.ImageSpecO = uiimage(app.OriginalPanel_4);
            app.ImageSpecO.Position = [0 201 195 181];

            % Create ImageSpecRef
            app.ImageSpecRef = uiimage(app.OriginalPanel_4);
            app.ImageSpecRef.Position = [194 201 197 181];

            % Create ResultPanel_4
            app.ResultPanel_4 = uipanel(app.OutputPanel_4);
            app.ResultPanel_4.Title = 'Result';
            app.ResultPanel_4.Position = [391 -1 247 410];

            % Create UIAxesSpecR
            app.UIAxesSpecR = uiaxes(app.ResultPanel_4);
            xlabel(app.UIAxesSpecR, 'X')
            ylabel(app.UIAxesSpecR, 'Y')
            zlabel(app.UIAxesSpecR, 'Z')
            app.UIAxesSpecR.Position = [0 10 247 179];

            % Create ImageSpecR
            app.ImageSpecR = uiimage(app.ResultPanel_4);
            app.ImageSpecR.Position = [0 200 247 181];

            % Create HistogramEqHSVTab
            app.HistogramEqHSVTab = uitab(app.TabGroup);
            app.HistogramEqHSVTab.Title = 'Histogram Equalization (HSV)';

            % Create InputPanel_5
            app.InputPanel_5 = uipanel(app.HistogramEqHSVTab);
            app.InputPanel_5.Title = 'Input';
            app.InputPanel_5.Position = [4 429 639 221];

            % Create ImageListBox_3Label_2
            app.ImageListBox_3Label_2 = uilabel(app.InputPanel_5);
            app.ImageListBox_3Label_2.HorizontalAlignment = 'right';
            app.ImageListBox_3Label_2.Position = [19 170 39 22];
            app.ImageListBox_3Label_2.Text = 'Image';

            % Create ImageListBoxEquaV
            app.ImageListBoxEquaV = uilistbox(app.InputPanel_5);
            app.ImageListBoxEquaV.Items = {'equa_1.jpg', 'equa_2.jpg', 'equa_3.png', 'equa_4.jpg', 'equa_5.png', 'equa_6.png'};
            app.ImageListBoxEquaV.ValueChangedFcn = createCallbackFcn(app, @ImageListBoxEquaVValueChanged, true);
            app.ImageListBoxEquaV.Position = [73 44 553 150];
            app.ImageListBoxEquaV.Value = 'equa_1.jpg';

            % Create ShowhisteqforComparisonButtonV
            app.ShowhisteqforComparisonButtonV = uibutton(app.InputPanel_5, 'push');
            app.ShowhisteqforComparisonButtonV.ButtonPushedFcn = createCallbackFcn(app, @ShowhisteqforComparisonButtonVPushed, true);
            app.ShowhisteqforComparisonButtonV.Position = [19 13 607 22];
            app.ShowhisteqforComparisonButtonV.Text = 'Show "histeq" for Comparison';

            % Create OutputPanel_5
            app.OutputPanel_5 = uipanel(app.HistogramEqHSVTab);
            app.OutputPanel_5.Title = 'Output';
            app.OutputPanel_5.Position = [4 1 639 429];

            % Create OriginalPanel_5
            app.OriginalPanel_5 = uipanel(app.OutputPanel_5);
            app.OriginalPanel_5.Title = 'Original';
            app.OriginalPanel_5.Position = [1 -1 320 410];

            % Create UIAxesEquaVO
            app.UIAxesEquaVO = uiaxes(app.OriginalPanel_5);
            xlabel(app.UIAxesEquaVO, 'X')
            ylabel(app.UIAxesEquaVO, 'Y')
            zlabel(app.UIAxesEquaVO, 'Z')
            app.UIAxesEquaVO.Position = [0 11 319 190];

            % Create ImageEquaVO
            app.ImageEquaVO = uiimage(app.OriginalPanel_5);
            app.ImageEquaVO.Position = [0 201 319 181];

            % Create ResultPanel_5
            app.ResultPanel_5 = uipanel(app.OutputPanel_5);
            app.ResultPanel_5.Title = 'Result';
            app.ResultPanel_5.Position = [320 -1 318 410];

            % Create UIAxesEquaVR
            app.UIAxesEquaVR = uiaxes(app.ResultPanel_5);
            xlabel(app.UIAxesEquaVR, 'X')
            ylabel(app.UIAxesEquaVR, 'Y')
            zlabel(app.UIAxesEquaVR, 'Z')
            app.UIAxesEquaVR.Position = [1 10 316 191];

            % Create ImageEquaVR
            app.ImageEquaVR = uiimage(app.ResultPanel_5);
            app.ImageEquaVR.Position = [1 200 316 181];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = aplikasi_exported

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