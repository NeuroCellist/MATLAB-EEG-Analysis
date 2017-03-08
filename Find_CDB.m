function [CDB,vals2,potentials] = Find_CDB(vals2)
vals2=round(vals2,4);
f1s=vals2(1:end-1);
CDB=NaN(200,1);
q=1;
potentials = NaN(400,1);
p=1;
tol=.01;
for i = 1:length(f1s)
    f1=f1s(i);
    for c = i+1:length(vals2);
        f2=vals2(c);
        for k = 2:3
            case1=round(((k*f1)-((k-1)*f2)),4);
            potentials(p)=case1;
            p=p+1;
            if case1>0 && ismembertol(case1,vals2,tol)==0 && ismembertol(case1,(vals2*2),tol)==0 && ismembertol(case1,(vals2*3),tol)==0
                CDB(q)=case1;
                q=q+1;
            else
                
            end
        end
    end
end
CDB(isnan(CDB))=[];
end