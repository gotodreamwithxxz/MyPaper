function [changeA,changeB] = function1(Alice,Bob)
      len = length(Alice);     %Alice�ĳ���
      H = [1 0 1 1 1 0 0;1 1 0 1 0 1 0;1 1 1 0 0 0 1];  
      jj=floor(len/2);
      for i=1:1:jj
        A(i)=Alice(2*i-1);
        A(jj+i)=Alice(2*i);
        B(i)=Bob(2*i-1);
        B(jj+i)=Bob(2*i);
      end
      %����û�
      Alice=A;
      Bob=B;
      %һ��У�����
      %a1-a7,������Sc�ֱ�Ϊ001.010.100.110.101.011.111
      %��żУ����
      length1=floor(len/8);
      for i=1:1:length1
        Aarr8 = Alice(8*i-7:8*i);
        Barr8 =   Bob(8*i-7:8*i);
        Acheck(i)=mod(sum(Aarr8),2);
        Bcheck(i)=mod(sum(Barr8),2); 
      end
      
      for j=length1:-1:1
        if Acheck(j)==Bcheck(j)
            Alice(8*j-7)=[];
            Bob(8*j-7)=[];
        else
            Alice(8*j-7)=[];
            Bob(8*j-7)=[];
            %������
            Ia=Alice(8*j-7:8*j-1);
            Ib=Bob(8*j-7:8*j-1);
            Sa=Ia*H';
            Sb=Ib*H';
            Sc=mod((Sa+Sb),2);
            num=Sc(1)*4+Sc(2)*2+Sc(3);
            switch num
                case 1
                    Bob(8*j-1)=Alice(8*j-1);
                case 2
                    Bob(8*j-2)=Alice(8*j-2);
                case 3
                    Bob(8*j-6)=Alice(8*j-6);
                case 4
                    Bob(8*j-3)=Alice(8*j-3);
                case 5
                    Bob(8*j-5)=Alice(8*j-5);
                case 6
                    Bob(8*j-4)=Alice(8*j-4);
                case 7
                    Bob(8*j-7)=Alice(8*j-7);
            end

        end
      end
  
changeA=Alice;
changeB=Bob;