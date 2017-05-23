                
close all
clc

        N=2000;%�źų���
        signal=randi([0,1],1,N);
        psksignal = pskmod(signal,2); %bpsk����
        f= 2.4*10^9; %�ز�Ƶ�� ��λHz
        ts=0.0002; %��������
        Snr = 18;%�����  

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
               g=0.25;  %С����ռ��
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
         BER1(Snr)=BER(Snr);
         laJ=laJ+1;
     end
       %,q1,q2
           
           R(Snr)=length(lateq1)/N;  %��������
       
       %�Լ�===========================================================================================
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
                   w1BER(Snr)=wBER(Snr);
                   laJw=laJw+1;
              end
                   wR(Snr)=length(latewq1)/N;
                   
                   %wq1,wq21
   
  %========================��������============================================================       


