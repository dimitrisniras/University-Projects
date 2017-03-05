function h=pfgrad(x,r)
gradf=[4*x(1)-3*x(2) -3*x(1)+4*x(2)]';
h=gradf+r*pgradf(x);
end