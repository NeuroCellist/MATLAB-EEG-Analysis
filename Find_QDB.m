function [QDB] = Find_QDB(vals)

f1s=vals(1:end-1);
QDB=NaN(200,1);
q=1;
for i = 1:length(f1s)
    f1=f1s(i);
    for c = i+1:length(vals);
        f2=vals(c);
        
        for k = 1:3
            case1=((k*f1)-(k*f2));
            case2=((k*f1)+(k*f2));
            if case1>0 & case1~=vals & case1~=(vals*2) & case1~=(vals*3)
                QDB(q)=case1;
                q=q+1;
            elseif case2>0 & case2~=vals & case2~=(vals*2) & case2~=(vals*3)
                QDB(q)=case2;
                q=q+1;
                
            end
        end
    end
end
QDB(isnan(QDB))=[];
end