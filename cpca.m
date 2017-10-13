function [timeDomain,PLVs,f]=cpca(X,NFFT,fs)
dbg=0;
if dbg, toc;end

X=fft(X,NFFT);

number=floor(size(X,1)/2);
f=linspace(0,fs/2,number);
freqComponents=zeros(size(X,1),number);
if dbg, toc;end

% if size(X,3)>1
%     newX=zeros(size(X,2),size(X,1));
%     for i=1:size(X,1)
%         temp=squeeze(X(i,:,:)).';
%         for j=1:number
%             C=temp(j,:)'*temp(j,:);
%             [vecs,vals]=eig(C);
%             freqComponents(:,j)=temp*vecs(:,end);
%             if dbg, disp(j);end
%         end
%         newX(i,:)=mean(freqComponents,2);
%         if dbg, disp(i);end
%     endy
%     X=newX;
% else
%     X=X.';
% end


PLVs=zeros(number,1);

for i=1:number
    
%     C=(X(i,:)'*X(i,:))./(abs(X(i,:))*abs(X(i,:)'));   %this was commented
%     out
    C=X(i,:)'*X(i,:);   %what karl had 
    
    [vecs,vals]=eig(C);
    
    freqComponents(:,i)=X*vecs(:,end);
    
    PLVs(i)=vals(end,end);
    
end

if dbg, toc;end

timeDomain=real(ifft(mean(freqComponents,2)));
