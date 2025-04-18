classdef factorgraph < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties (SetAccess=private, GetAccess=public)
        % Factor graph
        y_prior = sparse(0,0);
        y_dyn   = sparse(0,0);
        y_meas  = sparse(0,0);

        A_prior = sparse(0,0);
        A_dyn   = sparse(0,0);
        A_meas  = sparse(0,0);

        W_prior = sparse(0,0);
        W_dyn   = sparse(0,0);
        W_meas  = sparse(0,0);

        % Meta
        nStates % number of states in system
    end

    properties(Dependent)
        A
        y
        W
    end

    methods
        function obj = factorgraph(X0, P0, options)
            arguments(Input)
                X0 (:,1) {mustBeNumeric}
                P0 (:,:) {mustBeNumeric}
                options.H
                options.z
                options.R (1,:)
            end

            obj.y_prior = X0;
            obj.nStates = numel(X0);
            obj.A_prior = eye(obj.nStates);
            obj.W_prior = P0;

            if isfield(options, 'H') && isfield(options, 'z') && isfield(options, 'R')
                obj.addMeasurement(options.H, options.z, options.R)
            else
                obj.addMeasurement(eye(2),[0; 0], eye(2));                
            end
        end

        function addStep(obj, F, B, u, Q, options)
            arguments(Input)
                obj
                F
                B
                u (:,1)
                Q
                options.H
                options.z
                options.R (1,:)
            end

            % System Dynamics
            obj.addDynamics(F, B, u, Q);

            % Add Measurement if given
            if isfield(options, 'H') && isfield(options, 'z') && isfield(options, 'R')
                obj.addMeasurement(options.H, options.z, options.R);
            else
                obj.addMeasurement(zeros(1, obj.nStates), 0, 0);
            end

            obj.updatePriorDimensions();
        end

        function [x_est, sigma] = solve(obj)
            [x_hat, sigma_x, residuals] = estimation.lls(obj.A, obj.y, R=obj.W);

            x_est = reshape(full(x_hat), obj.nStates, [])';
            sigma = reshape(diag(sigma_x), obj.nStates, [])';
            % res = full(residuals(end-numel(z)+1:end));
        end
    end

    methods(Access=private)
        function addMeasurement(obj, H, z, R)
            % Update Design Matrix
            [rH, cH] = size(H);
            if isempty(obj.A_meas)
                obj.A_meas = H;
            else
                [rA, cA] = size(obj.A_meas);
                obj.A_meas(rA+1:rA+rH,cA+1:cH+cA) = H;
            end

            % Add Measurement
            obj.y_meas(end+1:end+size(z,1),:) = z;

            % Update Measurement Covariance
            [rW, cW] = size(obj.W_meas);
            [rR, cR] = size(R);
            obj.W_meas(rW+1:rW+rR,cW+1:cW+cR) = R;
        end

        function addDynamics(obj, F, B, u, Q)
            % Update Design Matrix
            [rA, cA] = size(obj.A_dyn);

            idx_r_F = rA+1:rA+obj.nStates;
            idx_c_F = max(1, cA+1-obj.nStates):max(cA, obj.nStates);

            % Add State dynamic model
            obj.A_dyn(idx_r_F, idx_c_F)             = -F;            
            obj.A_dyn(idx_r_F, idx_c_F+obj.nStates) = eye(obj.nStates);

            % Update Predicition
            obj.y_dyn = [obj.y_dyn; B * u];

            % Update Process Covariance
            [rW, cW] = size(obj.W_dyn);
            [rR, cR] = size(Q);
            obj.W_dyn(rW+1:rW+rR,cW+1:cW+cR) = Q;
        end

        function updatePriorDimensions(obj)
            % Extend Prior Design Matrix
            rA = size(obj.A_dyn) - size(obj.A_prior);
            obj.A_prior(:,end+rA(2)) = 0;
            obj.W_prior(:,end+rA(2)) = 0;
        end
    end

    methods
        function value = get.A(obj)
            value = [obj.A_prior; obj.A_dyn; obj.A_meas];
        end
        function value = get.y(obj)
            value = [obj.y_prior; obj.y_dyn; obj.y_meas];
        end
        function value = get.W(obj)
            % Initializing
            sz_w_prior = size(obj.W_prior);
            sz_w_dyn   = size(obj.W_dyn);
            sz_w_meas  = size(obj.W_meas);

            value = sparse(zeros(sz_w_prior(1)+sz_w_dyn(1)+sz_w_meas(1)));

            % Prior
            value(1:sz_w_prior(1),1:sz_w_prior(2)) = obj.W_prior;

            % Dyn
            value(sz_w_prior(1)+1:sz_w_prior(1)+sz_w_dyn(1), ...
              sz_w_prior(1)+1:sz_w_prior(1)+sz_w_dyn(2)) = obj.W_dyn;

            % Meas
            value(sz_w_prior(1)+sz_w_dyn(1)+1:sz_w_prior(1)+sz_w_dyn(1)+sz_w_meas(1), ...
              sz_w_prior(1)+sz_w_dyn(1)+1:sz_w_prior(1)+sz_w_dyn(2)+sz_w_meas(1)) = obj.W_meas;

            % at the moment - only diagonal matrices are working
            value = diag(diag(value));
        end 
    end
end