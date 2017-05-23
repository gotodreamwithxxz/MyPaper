function [changeA,changeB] = function1(Alice,Bob)
      len = length(Alice);     %Alice的长度
      H = [1 0 1 1 1 0 0;1 1 0 1 0 1 0;1 1 1 0 0 0 1];  %一致校验矩阵
      %a1-a7,错误码Sc分别为001.010.100.110.101.011.111
      %奇偶校验码
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
            %汉明码
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
            Alice(8*j-4)=[];
            Alice(8*j-6)=[];
            Alice(8*j-7)=[];
            Bob(8*j-4)=[];
            Bob(8*j-6)=[];
            Bob(8*j-7)=[];
            
        end
      end
  
changeA=Alice;
changeB=Bob;