                
close all
clc
for num=1:1:30
    for k=10:1:30
        N=2000;%�źų���
        signal=randi([0,1],1,N);
        psksignal = pskmod(signal,2); %bpsk����
        f= 2.4*10^9; %�ز�Ƶ�� ��λHz
        ts=0.0002; %��������
        Snr = k;%�����  

        %�Ϸ���������źŷ�ֵ�ĶԱ�
        v=60;%�Ϸ�������ٶ�
        c=3*10^8; %����
        fd=v*f/c;%��������Ƶ�� 
        chan=rayleighchan(ts,fd);
        y1=filter(chan,psksignal);%ͨ������˥���ŵ�
        y2=y1; 
        rsignal1 = awgn(y1,Snr);  
        rsignal2 =awgn(y2,Snr);
        re1=real(rsignal1);
        im1=imag(rsignal1);
        yy1=atan2(re1,im1);%Alice���յ����źŷ�ֵ
        re2=real(rsignal2);
        im2=imag(rsignal2);
        yy2=atan2(re2,im2);%Bob���յ����źŷ�ֵ
 
        %CQG=====================================================================================
               g=0.45;  %С����ռ��
               A11=pi/2+g*pi/2;A12=pi/2-g*pi/2;  %С��������
               A21=g*pi/2;A22=-g*pi/2;
               A31=-pi/2+g*pi/2;A32=-pi/2-g*pi/2;
               A41=-pi+g*pi/2;A42=pi-g*pi/2;
               ind=1;
               for i=1:1:N
                   if yy1(i)<A42&&yy1(i)>A11|| yy1(i)<A12&&yy1(i)>A21|| yy1(i)<A22&&yy1(i)>A31|| yy1(i)<A32&&yy1(i)>A41
                       if  yy2(i)<A42&&yy2(i)>A11|| yy2(i)<A12&&yy2(i)>A21|| yy2(i)<A22&&yy2(i)>A31|| yy2(i)<A32&&yy2(i)>A41
                           %yy1��yy2�������䷶Χ��
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
                       end %yy2��if����
                   end %yy1��if����   
               end %forѭ���жϽ���

     BE1=0;
        for  j=1:1:(2*(ind-1))
            if   q1(j)~=q2(j);
                BE1=BE1+1;
            end
        end
       BER1(Snr)=BE1/((ind-1)*2); %���ز�һ����
       R1(Snr)=((ind-1)*2)/N;  %��������
       BERbf(Snr)=BER1(Snr);  %�洢һ��Э��ǰ�Ĳ�һ����
     laJ=0;
     while BER1(Snr)>0.0001
        [lateq1,lateq2]=function1(q1,q2);
          BE=0;
            for  j=1:1:length(lateq1)
                if   lateq1(j)~=lateq2(j);
                    BE=BE+1;
                end
            end
            BER(Snr)=BE/length(lateq1); %���ز�һ����
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
     R(Snr)=length(q1)/N;  %��������
     q1=[];
     q2=[];
     rateCQG(Snr) = R(Snr)/R1(Snr);
     %  sum=0;      %��ֵ
   
     %MAQ----------------------------------------------------------------------------------------------------------
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
     
     
          for i=1:1:N                           %Bob
            if yy2(i)<-3*pi/4&&yy2(i)>-pi  
                mq2(2*i-1)=0;   mq2(2*i)=0;
            end
            if yy2(i)<-pi/2&&yy2(i)>-3*pi/4
               if e(i)==1;
                mq2(2*i-1)=0;   mq2(2*i)=0;
               else  mq2(2*i-1)=1;   mq2(2*i)=0;
               end
            end  
            if yy2(i)<-pi/4&&yy2(i)>-pi/2
                mq2(2*i-1)=1;   mq2(2*i)=0;
            end    
            if yy2(i)<0&&yy2(i)>-pi/4
               if e(i)==1;
                mq2(2*i-1)=1;   mq2(2*i)=0;
               else      mq2(2*i-1)=1;   mq2(2*i)=1;
               end
            end  
            if yy2(i)<pi/4&&yy2(i)>0  
                mq2(2*i-1)=1;   mq2(2*i)=1;
            end
            if yy2(i)<pi/2&&yy2(i)>pi/4
               if e(i)==1;
                mq2(2*i-1)=1;   mq2(2*i)=1;
               else  mq2(2*i-1)=0;   mq2(2*i)=1;
               end
            end  
            if yy2(i)<3*pi/4&&yy2(i)>pi/2
                mq2(2*i-1)=0;   mq2(2*i)=1;
            end    
            if yy2(i)<pi&&yy2(i)>3*pi/4
               if e(i)==1;
                mq2(2*i-1)=0;   mq2(2*i)=1;
               else      mq2(2*i-1)=0;   mq2(2*i)=0;
               end
            end
          end
         m1BE=0;
        for  j=1:1:(2*N)
            if   mq1(j)~=mq2(j);
                m1BE=m1BE+1;
            end
        end
        m1BER(Snr)=m1BE/(N*2); %���ز�һ����
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
                   mBER(Snr)=mBE/length(latemq1); %���ز�һ����
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
                   rateMAQ(Snr) = mR(Snr)/2;
     
     
       
       
       %CQA======================================================================
    for i=1:1:N
                   if  yy1(i)<pi&&yy1(i)>A42|| yy1(i)<pi/2&&yy1(i)>A12|| yy1(i)<0&&yy1(i)>A22|| yy1(i)<-pi/2&&yy1(i)>A32
                       L(i)=0;
                   end
                    if  yy1(i)<A42&&yy1(i)>A11|| yy1(i)<A12&&yy1(i)>A21|| yy1(i)<A22&&yy1(i)>A31|| yy1(i)<A32&&yy1(i)>A41  
                         L(i)=1;  
                    end
                    if  yy1(i)<A11&&yy1(i)>pi/2|| yy1(i)<A21&&yy1(i)>0|| yy1(i)<A31&&yy1(i)>-pi/2|| yy1(i)<A41&&yy1(i)>-pi
                       L(i)=2;
                    end
     end
        %�Լ�===========================================================================================
         
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
                    else  %0�ͼ�¼��λ��
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
          %ɾ��yy1�Ķ�Ӧλ�õ�ֵ
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
              w1BE=0;
                  for i=1:1:(2*(inn-1))
                      if wq1(i)~=wq2(i)
                           w1BE=w1BE+1;  
                      end
                  end   
                   w1BER(Snr)=w1BE/((inn-1)*2); %���ز�һ����
                   w1R(Snr)=2*(inn-1)/N;
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
                   wBER(Snr)=wBE/length(latewq1); %���ز�һ����
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
  %========================��������============================================================       
    end %�����K��end
   
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

end  %ѭ������num��end

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

%��һ���ʱȽ�=================================================================================
figure(1)
plot(avgwBER,'-^m');
hold on
plot(avgmBER,'-^b');
hold on
plot(avgBER,'-*r');
grid on
xlim([10,30]);
xlabel('�����');ylabel('��һ����')
title('BER');
legend('�Լ�','MAQ','CQG');

%�������ʱȽ�==============================================================================================

figure(2)
plot(avgwR,'-^m');
hold on
plot(avgmR,'-^b');
hold on
plot(avgR,'-*r');
grid on
xlim([10,30]);
xlabel('�����');ylabel('����������') 
title('R');
legend('�Լ�','MAQ','CQG');

%Э�̺��
figure(3)
plot(avgLwR,'-^m');
hold on
plot(avgLmR,'-^b');
hold on
plot(avgLR,'-*r');
grid on
xlim([10,30]);
xlabel('�����');ylabel('Э�̺����������') 
title('LateR');
legend('�Լ�','MAQ','CQG');

%Э�̺��rate
figure(4)
plot(avgratew,'-^m');
hold on
plot(avgratemaq,'-^b');
hold on
plot(avgrate,'-*r');
grid on
xlim([10,30]);
xlabel('�����');ylabel('Э�̺�rate') 
title('Rate');
legend('�Լ�','MAQ','CQG');

% %ƽ������,���Ե�
% a = 10:1:30;  %������
% b = avgrate(10:30);
% c = polyfit(a, b, 2);  %������ϣ�cΪ2����Ϻ��ϵ��
% d = polyval(c, a, 1);  %��Ϻ�ÿһ���������Ӧ��ֵ��Ϊd
% figure(5);
% plot(a, d, 'r');  
% hold on %��Ϻ������
% plot(a, b, '-*')
% hold on
