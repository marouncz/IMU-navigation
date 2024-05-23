function [x,fval] = AccelCalSolver(accel, gravityScalar) %#codegen
% The directive %#codegen indicates that the function
% is intended for code generation
arguments
    accel (6,3) double
    gravityScalar   (1,1) double
end


fun = @(x)gravityFun(x, accel, gravityScalar);%gravity function handler
x0 = [1 0 1 0 1 0]; % Initial point - gain=1, offset=0
options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','off');
[x,fval] = fsolve(fun, x0, options);

end