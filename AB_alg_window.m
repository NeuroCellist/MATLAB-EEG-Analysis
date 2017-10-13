function  CleanEEG = AB_alg_window(EEGdata,fs,threshold,approach)
%function  CleanEEG = AB_alg_window(EEGdata)
%This function cleans EEG data from high amplitude artifacts using the
%artifact blocking (AB) algorithm.
% The input parameters are:
% EEGdata : the original EEG data
% fs      : The sampling frequency of the EEG data
% threshold: This is a threshold that distingush high amplitude artifacts
%           from EEG data
% approach : This is the approach folowed by AB for cleaning the EEG data.
%           It has two different values; 'total' or 'window'. If approach =
%           'total' then one blocking matrix is estimated for the whole EEG
%           data set, while if approach = 'window' the EEG data is
%           partitioned into overlabed windows each of length 10*fs, and a
%           blocking matrix is estimated for each window. The default value
%           of the apprach argument is 'window'. The length of the window
%           can be changed as explained below
%
% By: Nasser Mourad
% 10/7/2007
% McMaster University, Canada;
% Aswan University, Egypt.
%
%T=time-series
%N=channels

[T,N] = size(EEGdata);
if nargin < 4; approach = 'total'; end
if nargin < 3; threshold = 50; end
if (nargin < 2 && strncmp(approach,'window',5))
    error(' The sampling frequency must be provided for the "window" approach ...\n')
end

if strncmp(approach,'total',5)
    LWind = T;
elseif strncmp(approach,'window',5)
    LWind = fix(12*fs);  %window of 12 seconds [you can change the window length from this line]
else
    error('Unknown approach for AB algorithm ...\n')
end


[T,N] = size(EEGdata);

%======================================================================
% removing the mean value of the input data
%======================================================================
for i = 1:N
    meanValue = mean(EEGdata(:,i));
    EEGdata(:,i) = EEGdata(:,i) - meanValue ;
end
%======================================================================
% Removing the artifacts
%======================================================================
if LWind == T
    CleanEEG =  AB_correct(EEGdata,threshold);
else
    CleanEEG = zeros(T,N);
    Iin = 1;
    Ifin = LWind + 1;
    r = 0.02;
    while 1
        ind = 1;
        LWind2 = LWind;
        if Iin == 1;
            ind = 0;
        end
        if Ifin > T;
            ind = 2;
            Ifin = T;
            LWind2 = Ifin - Iin;
        end
        W = mywindow(LWind,r,ind,LWind2);
        %W = W(:)';
        X = EEGdata(Iin:Ifin -1,:);
        
        [size(X) size(W)];
        
        for i = 1:N
            X(:,i) = W(:,1).*X(:,i);
        end
        %     [size(CleanEEG(:,Iin:Ifin-1)) size(X)]
        if LWind2 < 3*fs
            CleanEEG(Iin:Ifin-1,:) = CleanEEG(Iin:Ifin-1,:) + X;  %do not run AB over the last window if it is shorter than 3 seconds
        else
            CleanEEG(Iin:Ifin-1,:) = CleanEEG(Iin:Ifin-1,:) + AB_correct(X,threshold);
        end
        if Ifin >= T; break; end
        Iin = Ifin - fix(r*LWind/4) + 1;
        Ifin = Iin + LWind;
        %     [T Ifin]
    end
end



%#####################################################################
function CleanEEG = AB_correct(X,threshold);
[M,N]=  size(X);
if M > N
    D = find(abs(X) >= threshold);
    Y = X;
    Y(D) = 0 ;
    Rxx = X*X';
    Ryx = Y*X';
    %W = Ryx * inv(Rxx);
    W = Ryx/Rxx;
    CleanEEG = W * X;
else
    CleanEEG = zeros(N,M);
end
%=========================================================================
function W = mywindow(N,r,ind,N1);
%function W = mywindow(N,r,ind);
% This function generates tukeywin window of length N and ratio r.
% Based on the value of index, the window can take 3 different shapes. if
% ind = 1, the window is a regular tukeywin window with two tails, while
% ind = 0 (2) generates a tukeywin with the leading (trailing) tail
% truncated, respectively.
if nargin < 4; N1 = N;  end

if ind == 0
    W = tukeywin(N,r);
    W(1:fix(r*N/2)) = 1;
elseif ind == 1
    W = tukeywin(N,r);
elseif ind == 2
    W = ones(1,N1);
    W1 = tukeywin(N,r);
    %W(1:r*N/2) = W1(1:r*N/2);
    W(1:N1) = W1(1:N1);
end



