function [output_args] = add_ground_levelV0(XT,YT,ZGL,CHAR_SP,LW,LT,FS,ZTXT)

%XT is horizontal distnce from vertical axis
%YT is the location of the text from the top - YT
% Z is the coordinate of the groundlevel
% CHAR_SP it the color spec: [0 0.5 0] is dark green, [1 0 0] is read
% LW is  line width
%LT is  linetype, '--', etc
% FS is  font size
%ZTXT is text to apear for the groundlevel
%add_ground_level(100,0.05,ZGL,[0 0.5 0],3,'-',12,ZTXT)

%     ZTXT = ['Z ' ZTYPE '=' num2str(ZGL,3) ' ft'];
    x=get(gca,'xlim');
    h=plot(x,[ZGL ZGL],LT,'LineWidth',LW,'Color',CHAR_SP);
    
    YLIM=get(gca,'ylim');
    DIFF = YLIM(2)-YLIM(1);
    YSCALE = DIFF/YLIM(2);
    YLIM(1)+YT*DIFF;
    text(XT,YLIM(1)+YT*DIFF,ZTXT,'color',get(h,'color'),'FontName','times','FontSize',FS);
    
end
