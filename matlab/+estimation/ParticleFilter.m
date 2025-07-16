classdef ParticleFilter < handle

    properties(SetAccess=private, GetAccess=public)
        NumberParticles
        NumberStates

        x_t
        w_t
    end

    methods
        function obj = ParticleFilter(numParticles, numStates, x_t0)
            obj.NumberParticles = numParticles;
            obj.NumberStates    = numStates;
            
            obj.x_t = x_t0;            
            obj.w_t = ones(numParticles, 1) ./ numParticles;
        end

        function Predict(obj, u_t, options)                        
            arguments(Input)
                obj
                u_t % Input                
                options.Q = 0.001;
            end
                        
            r = randn(obj.NumberParticles, obj.NumberStates) .* options.Q;
            obj.x_t = obj.x_t + u_t + r;
        end

        function Correct(obj, dy, sigma)                        
            for ii = 1:obj.NumberParticles
                obj.w_t(ii) = likelihood.gauss(dy(ii), sigma);
            end

            obj.w_t = obj.w_t / sum(obj.w_t) + 1e-9;
        end
      
        % optimized Roulette Wheel Sampling
        function LowVarianceSampling(obj)        
            x_new = NaN(obj.NumberParticles, obj.NumberStates);

            % Normalize weights
            w = obj.w_t ./ sum(obj.w_t);

            % Initialize variables
            r = rand / obj.NumberParticles;
            c = w(1);
            ii = 1;

            for m = 1:obj.NumberParticles
                U = r + (m - 1) / obj.NumberParticles;
                while U > c
                    ii = ii + 1;
                    c = c + w(ii);
                end
                x_new(m, :) = obj.x_t(ii, :);
            end

            obj.x_t = x_new;
        end
    end
end