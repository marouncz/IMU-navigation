function F = gravityFun(x, accel, gravityScalar)
F = zeros(6,1); % Allocate return array


F(1) = (accel(1,1)*x(1) + x(2))^2 + (accel(1,2)*x(3) + x(4))^2 + (accel(1,3)*x(5) + x(6))^2 - gravityScalar^2;
F(2) = (accel(2,1)*x(1) + x(2))^2 + (accel(2,2)*x(3) + x(4))^2 + (accel(2,3)*x(5) + x(6))^2 - gravityScalar^2;
F(3) = (accel(3,1)*x(1) + x(2))^2 + (accel(3,2)*x(3) + x(4))^2 + (accel(3,3)*x(5) + x(6))^2 - gravityScalar^2;
F(4) = (accel(4,1)*x(1) + x(2))^2 + (accel(4,2)*x(3) + x(4))^2 + (accel(4,3)*x(5) + x(6))^2 - gravityScalar^2;
F(5) = (accel(5,1)*x(1) + x(2))^2 + (accel(5,2)*x(3) + x(4))^2 + (accel(5,3)*x(5) + x(6))^2 - gravityScalar^2;
F(6) = (accel(6,1)*x(1) + x(2))^2 + (accel(6,2)*x(3) + x(4))^2 + (accel(6,3)*x(5) + x(6))^2 - gravityScalar^2;

end