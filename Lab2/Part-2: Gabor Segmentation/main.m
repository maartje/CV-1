lambda = 10;
psi = 0;

theta = 0;
sigma = 2;
gamma = 0.5;

% theta
% createGabor( sigma, 0, lambda, psi, gamma );
% createGabor( sigma, 2*pi/8, lambda, psi, gamma );
% createGabor( sigma, 4*pi/8, lambda, psi, gamma );

% sigma
createGabor( 1, theta, lambda, psi, gamma );
createGabor( 3, theta, lambda, psi, gamma );

% gamma
% createGabor( sigma, theta, lambda, psi, 0.2 );
% createGabor( sigma, theta, lambda, psi, 1.5 );