yy=1:10:110;
       xx=5./yy;
       xx1=10./yy;
       xx2=20./yy;
       zz=-(1./yy).*log(exp((-yy).*(log2(1+xx))));
       zz1=-(1./yy).*log(exp((-yy).*(log2(1+xx1))));
       zz2=-(1./yy).*log(exp((-yy).*(log2(1+xx2))));
       plot(yy,zz,'r-o',yy,zz1,'b-^',yy,zz2,'g-v','linewidth',2,'markersize',10);
       grid on;


set(gca,'fontsize',17.5);


xlim([1,101]);
set(gca,'XTick',1:10:110)  

set(gca,'XTickLabel',{'1','10','20','30','40','50','60','70','80','90','100'})  
set(gca,'YTick',0:0.5:20)  
set(gca,'YTickLabel',{'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0','5.5','6.0','6.5','7.0','7.5','8.0','9.0','9.5','10.0','10.5','11.0','11.5','12.0','12.5','13.0','13.5','14.0','14.5','15.0','15.5','16.0','16.5','17.0','17.5','18.0','18.5','19.0','19.5','20.0'})  
 
xlabel('\fontname{宋体}QoS指数\theta','fontsize',17.5);ylabel('\fontname{宋体}标准化有效容量E(\theta)（bit/s/Hz）','fontsize',17.5)

legend('SNR=12dB','SNR=15dB','SNR=20dB');
legend('boxoff');
