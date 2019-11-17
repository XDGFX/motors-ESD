function [TIM] = teethInMesh(N, CD, D, d)
%TEETHINMESH Calculates the number of teeth which will be meshed

TIM = (0.5 - ( (D - d) / (6 * CD) )) * N;

end

