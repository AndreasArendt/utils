classdef afigure < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=public)
        handle        
    end

    properties(Access=private)
        vBar = []
    end
    
    properties(Dependent)
        Children
    end

    methods
        function obj = afigure(varargin)
            obj.handle = figure(varargin{:});
            set(obj.handle,'WindowButtonDownFcn', @obj.AxisClick_Callback);
        end                

        function linkaxes(obj, axes)     
            ch = obj.Children; %dependent property, read only once
            idx = arrayfun(@(h) isa(h, 'matlab.graphics.axis.Axes'), ch);
            linkaxes(ch(idx), axes);
        end
      
        function showlegend(obj)
            for ax = obj.Children.'
                if isa(ax, 'matlab.graphics.axis.Axes')
                    legend(ax, 'show');
                end
            end
        end
    end

    methods (Access = protected)
        function AxisClick_Callback(obj, hObject, eventdata)             
            % in case outside of axis is clicked (e.g. plus/minus sign)
            if eventdata.Source.CurrentAxes.CurrentPoint(1,2) > eventdata.Source.CurrentAxes.YLim
                return;
            end

            if ~isempty(obj.vBar)
                % delete line
                for ii = 1:numel(obj.vBar)
                    set(obj.vBar(ii), 'Value', eventdata.Source.CurrentAxes.CurrentPoint(1));                    
                end
            else
                % plot line
                idx = arrayfun(@(h) isa(h, 'matlab.graphics.axis.Axes'), obj.Children);

                if isa(hObject.Children, 'matlab.graphics.layout.TiledChartLayout')
                    hchildren = hObject.Children.Children;                
                else
                    hchildren = hObject.Children;                
                end

                for c = hchildren(idx).'
                    obj.vBar(end+1) = xline(c, eventdata.Source.CurrentAxes.CurrentPoint(1), 'Color', Color.RED);
                end  
            end
        end
    end

    methods
        function children = get.Children(obj)
            if isa( obj.handle.Children, 'matlab.graphics.layout.TiledChartLayout')
                children = obj.handle.Children.Children;                
            else
                children = obj.handle.Children;                
            end
        end
    end
end