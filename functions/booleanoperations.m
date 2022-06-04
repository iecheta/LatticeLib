function [union]=booleanoperations(varargin)
% Perform boolean union on n fields

union = varargin{1};
    for i = 1:nargin-1       
        union = min(union,varargin{i+1});
    end
end
