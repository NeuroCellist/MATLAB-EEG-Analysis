function [QDB,vals2,potentials] = Find_QDB(vals2)
vals2=round(vals2,4);
f1s=vals2(1:end-1);
QDB=NaN(200,1);
q=1;
potentials = NaN(400,1);
p=1;
tol=.01;
for i = 1:length(f1s)
    f1=f1s(i);
    for c = i+1:length(vals2);
        f2=vals2(c);
        for k = 1:3
            case1=round(((k*f2)-(k*f1)),4);
            case2=round(((k*f2)+(k*f1)),4);
            potentials(p)=case1;
            potentials(p+1)=case2;
            p=p+2;
            if case1>0 && ismembertol(case1,vals2,tol)==0 && ismembertol(case1,(vals2*2),tol)==0 && ismembertol(case1,(vals2*3),tol)==0
                QDB(q)=case1;
                q=q+1;
            elseif case2>0 && ismembertol(case2,vals2,tol)==0 && ismembertol(case2,(vals2*2),tol)==0 && ismembertol(case2,(vals2*3),tol)==0
                QDB(q)=case2;
                q=q+1;
            else
                
            end
        end
    end
end
QDB(isnan(QDB))=[];
end