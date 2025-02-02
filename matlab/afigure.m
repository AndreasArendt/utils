classdef afigure < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=public)
        handle
    end

    properties(Access=private)
        vBar = []
    end
    
    methods
        function obj = afigure(varargin)
            obj.handle = figure(varargin{:});
            set(obj.handle,'WindowButtonDownFcn', @obj.AxisClick_Callback);
        end                

        function linkaxes(obj, axes)
            idx = arrayfun(@(h) isa(h, 'matlab.graphics.axis.Axes'), obj.handle.Children);
            linkaxes(obj.handle.Children(idx), axes);
        end
      
        function showlegend(obj)
            for ax = obj.handle.Children.'
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
                idx = arrayfun(@(h) isa(h, 'matlab.graphics.axis.Axes'), obj.handle.Children);
                for c = hObject.Children(idx).'
                    obj.vBar(end+1) = xline(c, eventdata.Source.CurrentAxes.CurrentPoint(1), 'Color', Color.RED);
                end  
            end
        end
    end
end