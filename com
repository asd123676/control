clear all;close all;
mB=0.029;mb=0.334;
rB=0.0095;
l=0.4;
d=0.04;
JB=1.05e-6;Jb=0.0178;
Kb=0.1491;Kt=0.1491;
Ra=18.91;
n=4.2;
g=9.8;
Td=1;
dt=1e-3;
pMF1=[-1 0 1];
pMf2=[-1 0 1];
R=1;
L=0.5;
J=0.01;
B=0.1;
K=0.01;
i=0;
X1=0;%球的位置
X2=0;%球的速度
X3=0;%桿子角度
X4=0;%角速度
K1=(1+mB^-1*JB*rB^-2)^-1
K2=Kb*Kt*l^2(Ra*d^2)^-1
K3=n*Kb*l(Ra*d)^-1
K4(X1)=(JB+Jb+mB*X1^2)^-1
X_1=X2;
X_2=(X1*X4*X4-g*sin(X3))K1;
X_3=X4;
X_4=K4(X1)*cos(X3)*[K2*X4*cos(l*X3/d)+K3*cos(l*X3/d)*u-0.5*l*mb*g-mB*g*X1]-2*mB*X1*X2*X4*K4(X1);


KP=10;%控制器
RR=0;%控制器
in1=-1;

for t=0:dt:Td
  i=i+1;
if(in1<pMF1(1))
  uMf11=1;
  uMf12=0;
  uMf13=0;
elseif((pMF1(1)<in1)&&in1<pMf1(2))
  uMF11=((pMF(2)-in1)/(pMF(2)-pMF(1)));
  uMF12=1-uMF11;
  uMF13=0;
elseif((pMF1(2)<in1)&&in1<pMf1(3))
  uMF11=0;
  uMF12=((pMF1(2)-in1)/(pMF1(2)-pMF1(1)));
  uMF13=1-uMF11;
else
  uMf11=1;
  uMf12=0;
  uMf13=0;
endif
RR(i)=0.1;
T(i)=t;
err=RR(i)-W(i);
E(i)=err*KP;
TL(i)=0;
endfor
Len=length(T);
figure,plot(T,I(1:Len))
figure,plot(T,W(1:Len))
figure,plot(T,Q(1:Len))
