clear all                       
close all
clc
for num=1:1:100
    for k=10:1:30
        N=1000;%信号长度
        signal=randi([0,1],1,N);
        psksignal = pskmod(signal,2); %bpsk调制
        f= 2.4*10^9; %载波频率 单位Hz
        ts=0.0002; %采样周期
        Snr = k;%信噪比  

        %合法方间接受信号幅值的对比
        v=60;%合法方相对速度
        c=3*10^8; %光速
        fd=v*f/c;%最大多普勒频移 
        chan=rayleighchan(ts,fd);
        y1=filter(chan,psksignal);%通过瑞利衰落信道
        y2=y1; 
        rsignal1 = awgn(y1,Snr);  
        rsignal2 =awgn(y2,Snr);
        re1=real(rsignal1);
        im1=imag(rsignal1);
        yy1=atan2(re1,im1);%Alice接收到的信号幅值
        re2=real(rsignal2);
        im2=imag(rsignal2);
        yy2=atan2(re2,im2);%Bob接收到的信号幅值
 
        %CQG=====================================================================================
               g=0.25;  %小区间占比
               A11=pi/2+g*pi/2;A12=pi/2-g*pi/2;  %小区间门限
               A21=g*pi/2;A22=-g*pi/2;
               A31=-pi/2+g*pi/2;A32=-pi/2-g*pi/2;
               A41=-pi+g*pi/2;A42=pi-g*pi/2;
               ind=1;
               for i=1:1:N
                   if yy1(i)<A42&&yy1(i)>A11|| yy1(i)<A12&&yy1(i)>A21|| yy1(i)<A22&&yy1(i)>A31|| yy1(i)<A32&&yy1(i)>A41
                       if  yy2(i)<A42&&yy2(i)>A11|| yy2(i)<A12&&yy2(i)>A21|| yy2(i)<A22&&yy2(i)>A31|| yy2(i)<A32&&yy2(i)>A41
                           %yy1和yy2都在区间范围内
                           if  yy1(i)<A42&&yy1(i)>A11
                               q1(2*ind-1)=0;
                               q1(2*ind)=0;
                           end
                           if   yy1(i)<A12&&yy1(i)>A21
                               q1(2*ind-1)=0;
                               q1(2*ind)=1;
                           end  
                           if yy1(i)<A22&&yy1(i)>A31
                               q1(2*ind-1)=1;
                               q1(2*ind)=1;
                           end   
                           if yy1(i)<A32&&yy1(i)>A41
                               q1(2*ind-1)=1;
                               q1(2*ind)=0;
                           end  

                           if    yy2(i)<A42&&yy2(i)>A11 
                               q2(2*ind-1)=0;
                               q2(2*ind)=0;
                           end
                           if  yy2(i)<A12&&yy2(i)>A21
                               q2(2*ind-1)=0;
                               q2(2*ind)=1;
                           end  
                           if  yy2(i)<A22&&yy2(i)>A31
                               q2(2*ind-1)=1;
                               q2(2*ind)=1;
                           end   
                           if yy2(i)<A32&&yy2(i)>A41
                               q2(2*ind-1)=1;
                               q2(2*ind)=0;
                           end

                            ind=ind+1;
                       end %yy2的if结束
                   end %yy1的if结束   
               end %for循环判断结束

      BE=0;
        for  j=1:1:(2*(ind-1))
            if   q1(j)~=q2(j);
                BE=BE+1;
            end
        end
        BER(Snr)=BE/((ind-1)*2); %比特不一致率
       R(Snr)=((ind-1)*2)/N;  %生成速率
     %  sum=0;      %熵值
     %   for i=1:1:(2*(ind-1))
      %      if q2(i)==1
       %         sum=sum+1;
        %    end
       % end
      %  p=sum/(2*(ind-1));
       % E(Snr)=-p*log2(p)-(1-p)*log2(1-p);
       
       
       %CQA======================================================================
     for i=1:1:N
                   if  yy1(i)<pi&&yy1(i)>5*pi/6|| yy1(i)<pi/2&&yy1(i)>pi/3|| yy1(i)<0&&yy1(i)>-pi/6|| yy1(i)<-pi/2&&yy1(i)>-2*pi/3
                       L(i)=0;
                   end
                    if  yy1(i)<5*pi/6&&yy1(i)>2*pi/3|| yy1(i)<pi/3&&yy1(i)>pi/6|| yy1(i)<-pi/6&&yy1(i)>-pi/3|| yy1(i)<-2*pi/3&&yy1(i)>-5*pi/6  
                         L(i)=1;  
                    end
                    if  yy1(i)<2*pi/3&&yy1(i)>pi/2|| yy1(i)<pi/6&&yy1(i)>0|| yy1(i)<-pi/3&&yy1(i)>-pi/2|| yy1(i)<-5*pi/6&&yy1(i)>-pi
                       L(i)=2;
                    end
     end
     in=1;
        for i=1:1:N
            if L(i)==0;
                if yy2(i)<-5*pi/6&&yy2(i)>-pi|| yy2(i)<pi&&yy2(i)>2*pi/3
                   cq2(2*in-1)=0;   cq2(2*in)=0;
                end
                if yy2(i)<2*pi/3&&yy2(i)>pi/6
                   cq2(2*in-1)=0;   cq2(2*in)=1;
                end
                if yy2(i)<pi/6&&yy2(i)>-pi/3
                   cq2(2*in-1)=1;   cq2(2*in)=1;  
                end
                if yy2(i)<-pi/3&&yy2(i)>-5*pi/6
                   cq2(2*in-1)=1;   cq2(2*in)=0;
                end
            end
             if L(i)==1;
                if yy2(i)<pi&&yy2(i)>pi/2
                   cq2(2*in-1)=0;   cq2(2*in)=0;
                end
                if yy2(i)<pi/2&&yy2(i)>0
                   cq2(2*in-1)=0;   cq2(2*in)=1;
                end
                if yy2(i)<0&&yy2(i)>-pi/2
                   cq2(2*in-1)=1;   cq2(2*in)=1;  
                end
                if yy2(i)<-pi/2&&yy2(i)>-pi
                   cq2(2*in-1)=1;   cq2(2*in)=0;
                end
             end
             if L(i)==2;
                if yy2(i)<5*pi/6&&yy2(i)>pi/3
                   cq2(2*in-1)=0;   cq2(2*in)=0;
                end
                if yy2(i)<pi/3&&yy2(i)>-pi/6
                   cq2(2*in-1)=0;   cq2(2*in)=1;
                end
                if yy2(i)<-pi/6&&yy2(i)>-2*pi/3
                   cq2(2*in-1)=1;   cq2(2*in)=1;  
                end
                if yy2(i)<-2*pi/3&&yy2(i)>-pi||yy2(i)<pi&&yy2(i)>5*pi/6
                   cq2(2*in-1)=1;   cq2(2*in)=0;
                end
             end
             in=in+1;
        end
        index=1;
         for i=1:1:N
           if yy1(i)<pi&&yy1(i)>pi/2
                   cq1(2*index-1)=0;   cq1(2*index)=0;
                end
                if yy1(i)<pi/2&&yy1(i)>0
                   cq1(2*index-1)=0;   cq1(2*index)=1;
                end
                if yy1(i)<0&&yy1(i)>-pi/2
                   cq1(2*index-1)=1;   cq1(2*index)=1;  
                end
                if yy1(i)<-pi/2&&yy1(i)>-pi
                   cq1(2*index-1)=1;   cq1(2*index)=0;
                end 
                index=index+1;
         end
          cBE=0;
        for  j=1:1:(2*N)
            if   cq1(j)~=cq2(j);
                cBE=cBE+1;
            end
        end
        cBER(Snr)=cBE/(N*2); %比特不一致率
        %生成速率为2
         
       %MAQ======================================================================================
       In=1;
        for i=1:1:N
            if yy1(i)<-7*pi/8&&yy1(i)>-pi
                e(i)=0;
               mq1(2*In-1)=0;   mq1(2*In)=0;
            end
            if yy1(i)<-3*pi/4&&yy1(i)>-7*pi/8
                e(i)=1;
                mq1(2*In-1)=0;   mq1(2*In)=0;
            end  
            if yy1(i)<-5*pi/8&&yy1(i)>-3*pi/4
                e(i)=1;
                mq1(2*In-1)=0;   mq1(2*In)=0;
            end    
            if yy1(i)<-pi/2&&yy1(i)>-5*pi/8
                e(i)=0;
                mq1(2*In-1)=1;   mq1(2*In)=0;
            end     
             if yy1(i)<-3*pi/8&&yy1(i)>-pi/2
                e(i)=0;
                mq1(2*In-1)=1;   mq1(2*In)=0;
             end  
            if yy1(i)<-pi/4&&yy1(i)>-3*pi/8
                e(i)=1;
                mq1(2*In-1)=1;   mq1(2*In)=0;
            end 
            if yy1(i)<-pi/8&&yy1(i)>-pi/4
                e(i)=1;
                mq1(2*In-1)=1;   mq1(2*In)=0;
            end 
            if yy1(i)<0&&yy1(i)>-pi/8
                e(i)=0;
                mq1(2*In-1)=1;   mq1(2*In)=1;
            end 
            if yy1(i)<pi/8&&yy1(i)>0
                e(i)=0;
                mq1(2*In-1)=1;   mq1(2*In)=1;
            end 
            if yy1(i)<pi/4&&yy1(i)>pi/8
                e(i)=1;
                mq1(2*In-1)=1;   mq1(2*In)=1;
            end 
            if yy1(i)<3*pi/8&&yy1(i)>pi/4
                e(i)=1;
                mq1(2*In-1)=1;   mq1(2*In)=1;
            end 
            if yy1(i)<pi/2&&yy1(i)>3*pi/8
                e(i)=0;
                mq1(2*In-1)=0;   mq1(2*In)=1;
            end 
            if yy1(i)<5*pi/8&&yy1(i)>pi/2
                e(i)=0;
                mq1(2*In-1)=0;   mq1(2*In)=1;
            end 
            if yy1(i)<3*pi/4&&yy1(i)>5*pi/8
                e(i)=1;
                mq1(2*In-1)=0;   mq1(2*In)=1;
            end 
            if yy1(i)<7*pi/8&&yy1(i)>3*pi/4
                e(i)=1;
                mq1(2*In-1)=0;   mq1(2*In)=1;
            end 
            if yy1(i)<pi&&yy1(i)>7*pi/8
                e(i)=0;
                mq1(2*In-1)=0;   mq1(2*In)=0;
            end
            In=In+1;
        end   
         
        
        Index=1;
          for i=1:1:N                           %Bob
            if yy2(i)<-3*pi/4&&yy2(i)>-pi  
                mq2(2*Index-1)=0;   mq2(2*Index)=0;
            end
            if yy2(i)<-pi/2&&yy2(i)>-3*pi/4
               if e(i)==1;
                mq2(2*Index-1)=0;   mq2(2*Index)=0;
               else  mq2(2*Index-1)=1;   mq2(2*Index)=0;
               end
            end  
            if yy1(i)<-pi/4&&yy1(i)>-pi/2
                mq2(2*Index-1)=1;   mq2(2*Index)=0;
            end    
            if yy2(i)<0&&yy2(i)>-pi/4
               if e(i)==1;
                mq2(2*Index-1)=1;   mq2(2*Index)=0;
               else      mq2(2*Index-1)=1;   mq2(2*Index)=1;
               end
            end  
            if yy2(i)<pi/4&&yy2(i)>0  
                mq2(2*Index-1)=1;   mq2(2*Index)=1;
            end
            if yy2(i)<pi/2&&yy2(i)>pi/4
               if e(i)==1;
                mq2(2*Index-1)=1;   mq2(2*Index)=1;
               else  mq2(2*Index-1)=0;   mq2(2*Index)=1;
               end
            end  
            if yy2(i)<3*pi/4&&yy2(i)>pi/2
                mq2(2*Index-1)=0;   mq2(2*Index)=1;
            end    
            if yy2(i)<pi&&yy2(i)>3*pi/4
               if e(i)==1;
                mq2(2*Index-1)=0;   mq2(2*Index)=1;
               else      mq2(2*Index-1)=0;   mq2(2*Index)=0;
               end
            end
            Index=Index+1;
          end
         mBE=0;
        for  j=1:1:(2*N)
            if   mq1(j)~=mq2(j);
                mBE=mBE+1;
            end
        end
        mBER(Snr)=mBE/(N*2); %比特不一致率
        %生成速率为2 
        %自己===========================================================================================
         
              inn=1;
              rm=1;
          for i=1:1:N
               if L(i)==0
                       if yy2(i)<pi&&yy2(i)>A11
                           wq2(2*inn-1)=0;
                           wq2(2*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<pi/2&&yy2(i)>A21
                           wq2(2*inn-1)=1;
                           wq2(2*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<0&&yy2(i)>A31
                           wq2(2*inn-1)=1;
                           wq2(2*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<-pi/2&&yy2(i)>A41
                           wq2(2*inn-1)=0;
                           wq2(2*inn)=1;
                           inn=inn+1;
                           else
                               list(rm)=i;
                               rm=rm+1;
                       end   
                         
               end
               if L(i)==2
                    if yy2(i)<A42&&yy2(i)>pi/2
                           wq2(2*inn-1)=0;
                           wq2(2*inn)=0;
                           inn=inn+1;
                    elseif yy2(i)<A12&&yy2(i)>0
                           wq2(2*inn-1)=1;
                           wq2(2*inn)=0;
                           inn=inn+1;
                    elseif yy2(i)<A22&&yy2(i)>-pi/2
                           wq2(2*inn-1)=1;
                           wq2(2*inn)=1;
                           inn=inn+1;
                    elseif yy2(i)<A32&&yy2(i)>-pi
                           wq2(2*inn-1)=0;
                           wq2(2*inn)=1;
                           inn=inn+1;
                    else  %0就记录其位置
                               list(rm)=i;
                               rm=rm+1;
                    end 
                         
               end
                if L(i)==1
                    if yy2(i)<pi&&yy2(i)>pi/2
                           wq2(2*inn-1)=0;
                           wq2(2*inn)=0;
                           inn=inn+1;
                    elseif yy2(i)<pi/2&&yy2(i)>0
                           wq2(2*inn-1)=1;
                           wq2(2*inn)=0;
                           inn=inn+1;
                    elseif yy2(i)<0&&yy2(i)>-pi/2
                           wq2(2*inn-1)=1;
                           wq2(2*inn)=1;
                           inn=inn+1;
                    elseif yy2(i)<-pi/2&&yy2(i)>-pi
                           wq2(2*inn-1)=0;
                           wq2(2*inn)=1;
                           inn=inn+1;
                    else
                               list(rm)=i;
                               rm=rm+1;
                    end   
                           
                end
          end
          %删除yy1的对应位置的值
          for o=rm-1:-1:1
            yy1(list(o))=[];
          end
          
               In=1;
               for i=1:1:inn-1  
                if yy1(i)<pi&&yy1(i)>pi/2
                           wq1(2*In-1)=0;
                           wq1(2*In)=0;
                       end
                       if yy1(i)<pi/2&&yy1(i)>0
                           wq1(2*In-1)=1;
                           wq1(2*In)=0;
                       end
                       if yy1(i)<0&&yy1(i)>-pi/2
                           wq1(2*In-1)=1;
                           wq1(2*In)=1;
                       end
                         if yy1(i)<-pi/2&&yy1(i)>-pi
                           wq1(2*In-1)=0;
                           wq1(2*In)=1;
                         end   
                           In=In+1;
               end
               wBE=0;
                  for i=1:1:(2*(inn-1))
                      if wq1(i)~=wq2(i)
                           wBE=wBE+1;  
                      end
                  end   
                   wBER(Snr)=wBE/((inn-1)*2); %比特不一致率
                   wR(Snr)=2*(inn-1)/N;
   
  %========================公共部分============================================================       
    end %信噪比K的end
   
    for i=10:1:30
        resBER(num,i)=BER(i);
           resR(num,i)=R(i);
        rescBER(num,i)=cBER(i);  
         resmBER(num,i)=mBER(i);   
       reswBER(num,i)=wBER(i);
          reswR(num,i)=wR(i);
    end

end  %循环次数num的end
avgBER=mean(resBER);
   avgR=mean(resR);
avgcBER=mean(rescBER); 
  avgmBER=mean(resmBER); 
  avgwBER=mean(reswBER);
avgwR=mean(reswR);
%不一致率比较=================================================================================
figure(1)
plot(avgBER,'-r');
hold on
plot(avgcBER,'-k*');
hold on
plot(avgmBER,'-b+');
hold on
plot(avgwBER,'-m');
grid on
xlim([10,30]);
xlabel('信噪比');ylabel('不一致率')
title('BER');
legend('CQG','CQA','MAQ','自己');

%生成速率比较==============================================================================================
figure(2)
plot(avgR,'-r');
hold on
plot(avgwR,'-m');
grid on
xlim([10,30]);
xlabel('信噪比');ylabel('比特生成率') 
title('R');
legend('CQG','自己');
