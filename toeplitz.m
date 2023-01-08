% read data
[Xfull, Fs] = audioread("ManySounds5s170-24b.wav");
samples = [1, 60*Fs];
[X, Fs] = audioread("ManySounds5s170-24b.wav", samples);
X=X(:,1);
 
% cochdata
dX=1/8;
f1=100;
fN=10000;
Fm=750;
OF=2;
Norm='Amp';
dis='n';
ATT=60;
FiltType='GammaTone';
BWType='erb';
NLType='rect';
ModFiltType='bspline';
 
[CochData]=cochleogram(X,Fs,dX,f1,fN,Fm,OF,Norm,dis,ATT,FiltType,BWType,NLType,ModFiltType);
X=log2(CochData.faxis/100);
taxis=CochData.taxis;
S=CochData.S;
imagesc(taxis,X,S)
set(gca,'YDir','normal')
 
A = cell(length(X), length(X));
 
N = 20;
 
for i=1:length(X)
    for j=1:length(X)
        Rxx = xcorr(S(i, :)-mean(S(i, :)), S(j, :)-mean(S(j, :)), N);
        R = Rxx((N+1):end);
        C = Rxx((N+1):-1:1)';
        T = toeplitz(C, R);
        A(i, j) = {T};
    end
    clc
    disp(['Calcluating band ' int2str(i) ' of ' int2str(length(X))])
    pause(0.01)
end
 
Cxx = cell2mat(A);
 
imagesc(Cxx)
