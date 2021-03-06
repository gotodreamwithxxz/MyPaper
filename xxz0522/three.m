                
close all
clc
for num=1:1:30
    for k=10:1:30
        N=4000;%信号长度
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
               g=0.3;  %小区间占比
               A21=pi/2+g*pi/4;     A22=pi/2-g*pi/4;  %小区间门限
               A41=g*pi/4;          A42=-g*pi/4;
               A61=-pi/2+g*pi/4;    A62=-pi/2-g*pi/4;
               A81=-pi+g*pi/4;      A82=pi-g*pi/4;
               A11=3*pi/4+g*pi/4;   A12=3*pi/4-g*pi/4;  %小区间门限
               A31=pi/4+g*pi/4;     A32=pi/4-g*pi/4;
               A51=-pi/4+g*pi/4;    A52=-pi/4-g*pi/4;
               A71=-3*pi/4+g*pi/4;  A72=-3*pi/4-g*pi/4;
               ind=1;
               for i=1:1:N
                   if yy1(i)<A82&&yy1(i)>A11|| yy1(i)<A12&&yy1(i)>A21|| yy1(i)<A22&&yy1(i)>A31|| yy1(i)<A32&&yy1(i)>A41 || yy1(i)<A42&&yy1(i)>A51|| yy1(i)<A52&&yy1(i)>A61|| yy1(i)<A62&&yy1(i)>A71|| yy1(i)<A72&&yy1(i)>A81
                       if  yy2(i)<A82&&yy2(i)>A11|| yy2(i)<A12&&yy2(i)>A21|| yy2(i)<A22&&yy2(i)>A31|| yy2(i)<A32&&yy2(i)>A41 || yy2(i)<A42&&yy2(i)>A51|| yy2(i)<A52&&yy2(i)>A61|| yy2(i)<A62&&yy2(i)>A71|| yy2(i)<A72&&yy2(i)>A81
                           %yy1和yy2都在区间范围内
                           if  yy1(i)<A82&&yy1(i)>A11
                               q1(3*ind-2)=0;
                               q1(3*ind-1)=0;
                               q1(3*ind)=0;
                           end
                           if   yy1(i)<A12&&yy1(i)>A21
                               q1(3*ind-2)=0;
                               q1(3*ind-1)=0;
                               q1(3*ind)=1;
                           end  
                           if yy1(i)<A22&&yy1(i)>A31
                               q1(3*ind-2)=0;
                               q1(3*ind-1)=1;
                               q1(3*ind)=1;
                           end   
                           if yy1(i)<A32&&yy1(i)>A41
                               q1(3*ind-2)=0;
                               q1(3*ind-1)=1;
                               q1(3*ind)=0;
                           end  
                           if  yy1(i)<A42&&yy1(i)>A51
                               q1(3*ind-2)=1;
                               q1(3*ind-1)=1;
                               q1(3*ind)=0;
                           end
                           if   yy1(i)<A52&&yy1(i)>A61
                               q1(3*ind-2)=1;
                               q1(3*ind-1)=1;
                               q1(3*ind)=1;
                           end  
                           if yy1(i)<A62&&yy1(i)>A71
                               q1(3*ind-2)=1;
                               q1(3*ind-1)=0;
                               q1(3*ind)=1;
                           end   
                           if yy1(i)<A72&&yy1(i)>A81
                               q1(3*ind-2)=1;
                               q1(3*ind-1)=0;
                               q1(3*ind)=0;
                           end

                           if    yy2(i)<A82&&yy2(i)>A11 
                               q2(3*ind-2)=0;
                               q2(3*ind-1)=0;
                               q2(3*ind)=0;
                           end
                           if  yy2(i)<A12&&yy2(i)>A21
                               q2(3*ind-2)=0;
                               q2(3*ind-1)=0;
                               q2(3*ind)=1;
                           end  
                           if  yy2(i)<A22&&yy2(i)>A31
                               q2(3*ind-2)=0;
                               q2(3*ind-1)=1;
                               q2(3*ind)=1;
                           end   
                           if yy2(i)<A32&&yy2(i)>A41
                               q2(3*ind-2)=0;
                               q2(3*ind-1)=1;
                               q2(3*ind)=0;
                           end
                           if    yy2(i)<A42&&yy2(i)>A51 
                               q2(3*ind-2)=1;
                               q2(3*ind-1)=1;
                               q2(3*ind)=0;
                           end
                           if  yy2(i)<A52&&yy2(i)>A61
                               q2(3*ind-2)=1;
                               q2(3*ind-1)=1;
                               q2(3*ind)=1;
                           end  
                           if  yy2(i)<A62&&yy2(i)>A71
                               q2(3*ind-2)=1;
                               q2(3*ind-1)=0;
                               q2(3*ind)=1;
                           end   
                           if yy2(i)<A72&&yy2(i)>A81
                               q2(3*ind-2)=1;
                               q2(3*ind-1)=0;
                               q2(3*ind)=0;
                           end

                            ind=ind+1;
                       end %yy2的if结束
                   end %yy1的if结束   
               end %for循环判断结束

     BE1=0;
        for  j=1:1:(3*(ind-1))
            if   q1(j)~=q2(j);
                BE1=BE1+1;
            end
        end
       BER1(Snr)=BE1/((ind-1)*3); %比特不一致率
       R1(Snr)=((ind-1)*3)/N;  %生成速率
       BERbf(Snr)=BER1(Snr);  %存储一下协商前的不一致率
     laJ=0;
     while BER1(Snr)>0.0001
        [lateq1,lateq2]=function1(q1,q2);
          BE=0;
            for  j=1:1:length(lateq1)
                if   lateq1(j)~=lateq2(j);
                    BE=BE+1;
                end
            end
            BER(Snr)=BE/length(lateq1); %比特不一致率
         q1=[];
         q2=[];
         q1=lateq1;
         q2=lateq2;
         lateq1=[];
         lateq2=[];
         BER1=BER;
         laJ=laJ+1;
     end
     lJ(Snr)=laJ;
     R(Snr)=length(q1)/N;  %生成速率
     q1=[];
     q2=[];
     rateCQG(Snr) = R(Snr)/R1(Snr);
     %  sum=0;      %熵值
   
     %MAQ----------------------------------------------------------------------------------------------------------
     In=1;
     for i=1:1:N
            if yy1(i)<-15*pi/16&&yy1(i)>-pi || yy1(i)<pi&&yy1(i)>15*pi/16
                e(i)=0;
               mq1(3*In-2)=0; mq1(3*In-1)=0;  mq1(3*In)=0;
            end
            if yy1(i)<-13*pi/16&&yy1(i)>-15*pi/16
                e(i)=1;
                mq1(3*In-2)=1; mq1(3*In-1)=0;  mq1(3*In)=0;
            end  
            if yy1(i)<-11*pi/16&&yy1(i)>-13*pi/16
                e(i)=0;
                mq1(3*In-2)=1; mq1(3*In-1)=0;  mq1(3*In)=0;
            end    
            if yy1(i)<-9*pi/16&&yy1(i)>-11*pi/16
                e(i)=1;
                mq1(3*In-2)=1; mq1(3*In-1)=0;  mq1(3*In)=1;
            end     
             if yy1(i)<-7*pi/16&&yy1(i)>-9*pi/16
                e(i)=0;
                mq1(3*In-2)=1; mq1(3*In-1)=0;  mq1(3*In)=1;
             end  
            if yy1(i)<-5*pi/16&&yy1(i)>-7*pi/16
                e(i)=1;
                mq1(3*In-2)=1; mq1(3*In-1)=1;  mq1(3*In)=1;
            end 
            if yy1(i)<-3*pi/16&&yy1(i)>-5*pi/16
                e(i)=0;
                mq1(3*In-2)=1; mq1(3*In-1)=1;  mq1(3*In)=1;
            end 
            if yy1(i)<-pi/16&&yy1(i)>-3*pi/16
                e(i)=1;
                mq1(3*In-2)=1; mq1(3*In-1)=1;  mq1(3*In)=0;
            end 
            if yy1(i)<pi/16&&yy1(i)>-pi/16
                e(i)=0;
                mq1(3*In-2)=1; mq1(3*In-1)=1;  mq1(3*In)=0;
            end 
            if yy1(i)<3*pi/16&&yy1(i)>pi/16
                e(i)=1;
                mq1(3*In-2)=0; mq1(3*In-1)=1;  mq1(3*In)=0;
            end 
            if yy1(i)<5*pi/16&&yy1(i)>3*pi/16
                e(i)=0;
                mq1(3*In-2)=0; mq1(3*In-1)=1;  mq1(3*In)=0;
            end 
            if yy1(i)<7*pi/16&&yy1(i)>5*pi/16
                e(i)=1;
                mq1(3*In-2)=0; mq1(3*In-1)=1;  mq1(3*In)=1;
            end 
            if yy1(i)<9*pi/16&&yy1(i)>7*pi/16
                e(i)=0;
                mq1(3*In-2)=0; mq1(3*In-1)=1;  mq1(3*In)=1;
            end 
            if yy1(i)<11*pi/16&&yy1(i)>9*pi/16
                e(i)=1;
                mq1(3*In-2)=0; mq1(3*In-1)=0;  mq1(3*In)=1;
            end 
            if yy1(i)<13*pi/16&&yy1(i)>11*pi/16
                e(i)=0;
                mq1(3*In-2)=0; mq1(3*In-1)=0;  mq1(3*In)=1;
            end 
            if yy1(i)<15*pi/16&&yy1(i)>13*pi/16
                e(i)=1;
                mq1(3*In-2)=0; mq1(3*In-1)=0;  mq1(3*In)=0;
            end
            In=In+1;
     end
     
     In=1;
          for i=1:1:N                           %Bob
            if yy2(i)<-7*pi/8&&yy2(i)>-pi  
                if e(i)==1;
                    mq2(3*In-2)=1; mq2(3*In-1)=0;  mq2(3*In)=0;
                else
                   mq2(3*In-2)=0; mq2(3*In-1)=0;  mq2(3*In)=0;
               end
            end
            if yy2(i)<-5*pi/8&&yy2(i)>-6*pi/8  
                if e(i)==1;
                    mq2(3*In-2)=1; mq2(3*In-1)=0;  mq2(3*In)=1;
                else
                   mq2(3*In-2)=1; mq2(3*In-1)=0;  mq2(3*In)=0;
               end
            end
            if yy2(i)<-3*pi/8&&yy2(i)>-4*pi/8  
                if e(i)==1;
                    mq2(3*In-2)=1; mq2(3*In-1)=1;  mq2(3*In)=1;
                else
                   mq2(3*In-2)=1; mq2(3*In-1)=0;  mq2(3*In)=1;
               end
            end
            if yy2(i)<-1*pi/8&&yy2(i)>-2*pi/8  
                if e(i)==1;
                    mq2(3*In-2)=1; mq2(3*In-1)=1;  mq2(3*In)=0;
                else
                   mq2(3*In-2)=1; mq2(3*In-1)=1;  mq2(3*In)=1;
               end
            end
            if yy2(i)<pi/8&&yy2(i)>0  
                if e(i)==1;
                    mq2(3*In-2)=0; mq2(3*In-1)=1;  mq2(3*In)=0;
                else
                   mq2(3*In-2)=1; mq2(3*In-1)=1;  mq2(3*In)=0;
               end
            end
            if yy2(i)<3*pi/8&&yy2(i)>2*pi/8
                if e(i)==1;
                    mq2(3*In-2)=0; mq2(3*In-1)=1;  mq2(3*In)=1;
                else
                   mq2(3*In-2)=0; mq2(3*In-1)=1;  mq2(3*In)=0;
               end
            end
            if yy2(i)<5*pi/8&&yy2(i)>4*pi/8  
                if e(i)==1;
                    mq2(3*In-2)=0; mq2(3*In-1)=0;  mq2(3*In)=1;
                else
                   mq2(3*In-2)=0; mq2(3*In-1)=1;  mq2(3*In)=1;
               end
            end
            if yy2(i)<7*pi/8&&yy2(i)>6*pi/8  
                if e(i)==1;
                    mq2(3*In-2)=0; mq2(3*In-1)=0;  mq2(3*In)=0;
                else
                   mq2(3*In-2)=0; mq2(3*In-1)=0;  mq2(3*In)=1;
               end
            end
            if yy2(i)<-6*pi/8&&yy2(i)>-7*pi/8  
                   mq2(3*In-2)=1; mq2(3*In-1)=0;  mq2(3*In)=0;
            end
            if yy2(i)<-4*pi/8&&yy2(i)>-5*pi/8  
                   mq2(3*In-2)=1; mq2(3*In-1)=0;  mq2(3*In)=1;
            end
            if yy2(i)<-2*pi/8&&yy2(i)>-3*pi/8  
                   mq2(3*In-2)=1; mq2(3*In-1)=1;  mq2(3*In)=1;
            end
            if yy2(i)<0&&yy2(i)>-pi/8  
                   mq2(3*In-2)=1; mq2(3*In-1)=1;  mq2(3*In)=0;
            end
            if yy2(i)<2*pi/8&&yy2(i)>pi/8  
                   mq2(3*In-2)=0; mq2(3*In-1)=1;  mq2(3*In)=0;
            end
            if yy2(i)<4*pi/8&&yy2(i)>3*pi/8  
                   mq2(3*In-2)=0; mq2(3*In-1)=1;  mq2(3*In)=1;
            end
            if yy2(i)<6*pi/8&&yy2(i)>5*pi/8  
                   mq2(3*In-2)=0; mq2(3*In-1)=0;  mq2(3*In)=1;
            end
            if yy2(i)<pi&&yy2(i)>7*pi/8  
                   mq2(3*In-2)=0; mq2(3*In-1)=0;  mq2(3*In)=0;
            end
            In=In+1;
         end
           
         m1BE=0;
        for  j=1:1:(3*N)
            if   mq1(j)~=mq2(j);
                m1BE=m1BE+1;
            end
        end
        m1BER(Snr)=m1BE/(N*3); %比特不一致率
                   mBERbf(Snr)=m1BER(Snr);
                   
                   laJm=0;   
              while m1BER(Snr)>0.0001
                  [latemq1,latemq2]=function1(mq1,mq2); 
                  mBE=0;
                  for i=1:1:length(latemq1)
                      if latemq1(i)~=latemq2(i)
                           mBE=mBE+1;  
                      end
                  end   
                   mBER(Snr)=mBE/length(latemq1); %比特不一致率
                   mq1=[];
                   mq2=[];
                   mq1=latemq1;
                   mq2=latemq2;
                   latemq1=[];
                   latemq2=[];
                   m1BER=mBER;
                   laJm=laJm+1;
              end
                   lJm(Snr)=laJm; 
                   mR(Snr)=length(mq1)/N;
                   mq1=[];
                   mq2=[];
                   rateMAQ(Snr) = mR(Snr)/3;
     
     
       
       
       %CQA======================================================================
    for i=1:1:N
                   if  yy1(i)<pi&&yy1(i)>A82|| yy1(i)<3*pi/4&&yy1(i)>A12|| yy1(i)<pi/2&&yy1(i)>A22|| yy1(i)<pi/4&&yy1(i)>A32 ||yy1(i)<0&&yy1(i)>A42|| yy1(i)<-pi/4&&yy1(i)>A52|| yy1(i)<-pi/2&&yy1(i)>A62|| yy1(i)<-3*pi/4&&yy1(i)>A72
                       L(i)=0;
                   end
                    if  yy1(i)<A82&&yy1(i)>A11|| yy1(i)<A12&&yy1(i)>A21|| yy1(i)<A22&&yy1(i)>A31|| yy1(i)<A32&&yy1(i)>A41 ||yy1(i)<A42&&yy1(i)>A51|| yy1(i)<A52&&yy1(i)>A61|| yy1(i)<A62&&yy1(i)>A71|| yy1(i)<A72&&yy1(i)>A81  
                         L(i)=1;  
                    end
                    if  yy1(i)<A11&&yy1(i)>3*pi/4 || yy1(i)<A21&&yy1(i)>pi/2|| yy1(i)<A31&&yy1(i)>pi/4|| yy1(i)<A41&&yy1(i)>0 || yy1(i)<A51&&yy1(i)>-pi/4 || yy1(i)<A61&&yy1(i)>-pi/2|| yy1(i)<A71&&yy1(i)>-3*pi/4|| yy1(i)<A81&&yy1(i)>-pi
                       L(i)=2;
                    end
     end
        %自己===========================================================================================
         
              inn=1;
              rm=1;
          for i=1:1:N
               if L(i)==0
                       if yy2(i)<pi&&yy2(i)>A11
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<3*pi/4&&yy2(i)>A21
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<pi/2&&yy2(i)>A31
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<pi/4&&yy2(i)>A41
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<0&&yy2(i)>A51
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<-pi/4&&yy2(i)>A61
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<-pi/2&&yy2(i)>A71
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<-3*pi/4&&yy2(i)>A81
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=0;
                           inn=inn+1;
                           else
                               list(rm)=i;
                               rm=rm+1;
                       end   
                         
               end
               if L(i)==2
                    if yy2(i)<A82&&yy2(i)>3*pi/4
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<A12&&yy2(i)>pi/2
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<A22&&yy2(i)>pi/4
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<A32&&yy2(i)>0
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<A42&&yy2(i)>-pi/4
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<A52&&yy2(i)>-pi/2
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<A62&&yy2(i)>-3*pi/4
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<A72&&yy2(i)>-pi
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=0;
                           inn=inn+1;
                    else  %0就记录其位置
                               list(rm)=i;
                               rm=rm+1;
                    end 
                         
               end
                if L(i)==1
%                     if yy2(i)<A42 && yy2(i)>A11
%                            wq2(2*inn-1)=0;
%                            wq2(2*inn)=0;
%                            inn=inn+1;
%                     elseif yy2(i)<A12 && yy2(i)>A21
%                            wq2(2*inn-1)=1;
%                            wq2(2*inn)=0;
%                            inn=inn+1;
%                     elseif yy2(i)<A22 &&yy2(i)>A31
%                            wq2(2*inn-1)=1;
%                            wq2(2*inn)=1;
%                            inn=inn+1;
%                     elseif yy2(i)<A32 &&yy2(i)>A41
%                            wq2(2*inn-1)=0;
%                            wq2(2*inn)=1;
%                            inn=inn+1;
                   if yy2(i)<pi&&yy2(i)>3*pi/4
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<3*pi/4&&yy2(i)>pi/2
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<pi/2&&yy2(i)>pi/4
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<pi/4&&yy2(i)>0
                           wq2(3*inn-2)=0;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<0&&yy2(i)>-pi/4
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=0;
                           inn=inn+1;
                       elseif yy2(i)<-pi/4&&yy2(i)>-pi/2
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=1;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<-pi/2&&yy2(i)>-3*pi/4
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=1;
                           inn=inn+1;
                       elseif yy2(i)<-3*pi/4&&yy2(i)>-pi
                           wq2(3*inn-2)=1;
                           wq2(3*inn-1)=0;
                           wq2(3*inn)=0;
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
                       if yy1(i)<pi&&yy1(i)>3*pi/4
                           wq1(3*In-2)=0;
                           wq1(3*In-1)=0;
                           wq1(3*In)=0;
                       end
                       if yy1(i)<3*pi/4&&yy1(i)>pi/2
                           wq1(3*In-2)=0;
                           wq1(3*In-1)=0;
                           wq1(3*In)=1;
                       end
                       if yy1(i)<pi/2&&yy1(i)>pi/4
                           wq1(3*In-2)=0;
                           wq1(3*In-1)=1;
                           wq1(3*In)=1;
                       end
                         if yy1(i)<pi/4&&yy1(i)>0
                           wq1(3*In-2)=0;
                           wq1(3*In-1)=1;
                           wq1(3*In)=0;
                         end 
                         if yy1(i)<0&&yy1(i)>-pi/4
                           wq1(3*In-2)=1;
                           wq1(3*In-1)=1;
                           wq1(3*In)=0;
                       end
                       if yy1(i)<-pi/4&&yy1(i)>-pi/2
                           wq1(3*In-2)=1;
                           wq1(3*In-1)=1;
                           wq1(3*In)=1;
                       end
                       if yy1(i)<-pi/2&&yy1(i)>-3*pi/4
                           wq1(3*In-2)=1;
                           wq1(3*In-1)=0;
                           wq1(3*In)=1;
                       end
                         if yy1(i)<-3*pi/4&&yy1(i)>-pi
                           wq1(3*In-2)=1;
                           wq1(3*In-1)=0;
                           wq1(3*In)=0;
                         end
                           In=In+1;
               end
              w1BE=0;
                  for i=1:1:(3*(inn-1))
                      if wq1(i)~=wq2(i)
                           w1BE=w1BE+1;  
                      end
                  end   
                   w1BER(Snr)=w1BE/((inn-1)*3); %比特不一致率
                   w1R(Snr)=3*(inn-1)/N;
                   wBERbf(Snr)=w1BER(Snr);
                   
                   laJw=0;   
              while w1BER(Snr)>0.0001
                  [latewq1,latewq2]=function1(wq1,wq2); 
                  wBE=0;
                  for i=1:1:length(latewq1)
                      if latewq1(i)~=latewq2(i)
                           wBE=wBE+1;  
                      end
                  end   
                   wBER(Snr)=wBE/length(latewq1); %比特不一致率
                   wq1=[];
                   wq2=[];
                   wq1=latewq1;
                   wq2=latewq2;
                   latewq1=[];
                   latewq2=[];
                   w1BER=wBER;
                   laJw=laJw+1;
              end
                   lJw(Snr)=laJw; 
                   wR(Snr)=length(wq1)/N;
                   wq1=[];
                   wq2=[];
                   rateMy(Snr) = wR(Snr)/w1R(Snr);
  %========================公共部分============================================================       
    end %信噪比K的end
   
    for i=10:1:30
           resBER(num,i)=BERbf(i);
           resR(num,i)=R1(i);
           lateR(num,i)=R(i);
           rate(num,i)=rateCQG(i);
 
          resmBER(num,i)=mBERbf(i);   
          resm1R(num,i)=2;
          resmR(num,i)=mR(i);
          ratemaq(num,i)=rateMAQ(i);
          
          reswBER(num,i)=wBERbf(i);
          reswR(num,i)=w1R(i);
          latewR(num,i)=wR(i);
          ratew(num,i)=rateMy(i);
    end
end  %循环次数num的end

   avgBER=mean(resBER);
   avgR=mean(resR);
   avgLR=mean(lateR);
   avgrate=mean(rate);

   avgmBER=mean(resmBER); 
   avgmR=2;
   avgLmR=mean(resmR);
   avgratemaq=mean(ratemaq);
   
    avgwBER=mean(reswBER);
    avgwR=mean(reswR);
    avgLwR=mean(latewR);
    avgratew=mean(ratew);

%不一致率比较=================================================================================
figure(1)
plot(avgwBER,'-^m');
hold on
plot(avgmBER,'-^b');
hold on
plot(avgBER,'-*r');
grid on
xlim([10,30]);
xlabel('信噪比');ylabel('不一致率')
title('BER');
legend('自己','MAQ','CQG');

%生成速率比较==============================================================================================

figure(2)
plot(avgwR,'-^m');
hold on
plot(avgmR,'-^b');
hold on
plot(avgR,'-*r');
grid on
xlim([10,30]);
xlabel('信噪比');ylabel('比特生成率') 
title('R');
legend('自己','MAQ','CQG');

%协商后的
figure(3)
plot(avgLwR,'-^m');
hold on
plot(avgLmR,'-^b');
hold on
plot(avgLR,'-*r');
grid on
xlim([10,30]);
xlabel('信噪比');ylabel('协商后比特生成率') 
title('LateR');
legend('自己','MAQ','CQG');

%协商后的rate
figure(4)
plot(avgratew,'-^m');
hold on
plot(avgratemaq,'-^b');
hold on
plot(avgrate,'-*r');
grid on
xlim([10,30]);
xlabel('信噪比');ylabel('协商后rate') 
title('Rate');
legend('自己','MAQ','CQG');

% %平滑曲线,测试的
% a = 10:1:30;  %横坐标
% b = avgrate(10:30);
% c = polyfit(a, b, 2);  %进行拟合，c为2次拟合后的系数
% d = polyval(c, a, 1);  %拟合后，每一个横坐标对应的值即为d
% figure(5);
% plot(a, d, 'r');  
% hold on %拟合后的曲线
% plot(a, b, '-*')
% hold on
