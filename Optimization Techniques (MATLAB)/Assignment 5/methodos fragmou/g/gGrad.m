function h=gGrad(x,r)
gradg=[2*x(1)-2*x(2) -2*x(1)+2*x(2)]';
h=gradg+r*bgGrad(x);
end