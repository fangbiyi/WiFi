function display_matrix(matrix,varargin)
%DISPLAY_MATRIX   Display contents of a matrix for easy viewing
%   DISPLAY_MATRIX(matrix) display an on-screen matrix of an input matrix
%   for easy viewing. Additional parameters are allowed to enable column
%   and title headers and matrix titles.
%
%   DISPLAY_MATRIX(matrix,'rowheader',rowheader,'colheader',colheader,...)
%   displays row and column headers.
%
%   DISPLAY_MATRIX(matrix,'title',titletext,...) additionally displays a
%   single row at the top with the title of the matrix.
%
%   Written by Marshall Crumiller
%   email: mcrumiller@gmail.com
%--------------------------------------------------------------------------
% define colors
indigo  =         [0.2471 0.3176 0.7098];
dark_indigo =     [0.1882 0.2431 0.6314];
header_gray =     [0.9176 0.9176 0.9176];
line_gray =       [0.8118 0.8118 0.8118];
divider_gray =    [0.9020 0.9020 0.9020];
background_gray = [0.9804 0.9804 0.9804];
title_gray =      [0.9098 0.9176 0.9647];
status_gray =     [0.7725 0.7922 0.9137];
text_gray =       [0.4588 0.4588 0.4588];
text_darkgray =   [0.3804 0.3804 0.3804];
diagonal_gray=    [0.1294 0.1294 0.1294];
purple =          [0.7922 0.5725 0.8510];

M=size(matrix);

% grab input arguments
rowheader=[]; colheader=[]; title_text=[];
while(~isempty(varargin))
    if(length(varargin)<2)
        error('Argument <strong>%s</strong> has invalid value argument.',varargin{1});
    end
    switch varargin{1}
        case 'rowheader', rowheader=varargin{2};
        case 'colheader', colheader=varargin{2};
        case 'title', title_text=varargin{2};
    end
    varargin(1:2)=[];
end

% determine orientation of output paper
rows=M(1); cols=M(2);
if(rows>cols),orientation='portrait';
else orientation='landscape';
end

% generate figure
fig_width=11; fig_height=8.5;
f=figure('units','inches','dockcontrols','off','paperpositionmode','manual',...
    'paperorientation',orientation,'toolbar','none','menubar','none','paperunits','normalized',...
    'paperposition',[0 0 1 1],'renderer','painters','color',background_gray,'inverthardcopy','off');
oldUnits=get(0,'units'); set(0,'units','inches');
scrsz = get(0,'ScreenSize'); set(0,'units',oldUnits);
left=(scrsz(3)-fig_width)*.5; bot=(scrsz(4)-fig_height)*.5;
set(f,'outerposition',[left bot fig_width fig_height]);

if(isempty(rowheader)), rowheader=1:cols; end
if(~ischar(rowheader)), rowheader=strtrim(cellstr(int2str(rowheader(:)))); end
if(isempty(colheader)), colheader=1:rows; end
if(~ischar(colheader)), colheader=strtrim(cellstr(int2str(colheader(:)))); end
if(isempty(title_text)),title_text=sprintf('Matrix: %s',inputname(1)); end
rowheader_p=.05;
marg=.01;

status_p=.03; % status bar height
title_p=.06;  % title bar height
max_colheader_len=max(cellfun(@length,colheader));
colheader_p=min(.02+.01*max_colheader_len,.1);
row_p=(1-status_p-title_p)/rows; % row height
col_p=1/cols; % column height


axes('position',[0 0 1 1],'box','off','xtick',[],'ytick',[],'xlim',[0 1],'ylim',[0 1],'color',background_gray); hold all;

% display status bar
patch('Xdata',[-.1 -.1 1.1 1.1],'YData',[1-title_p 1 1 1-title_p],'FaceColor',dark_indigo,'EdgeColor','none');

% display title bar
ytop=1-status_p; ybot=1-status_p-title_p;
patch('XData',[-.1 -.1 1.1 1.1],'YData',[ybot ytop ytop ybot],'FaceColor',indigo,'EdgeColor','none');

% display header row
ytop=1-status_p-title_p;
ybot=1-status_p-title_p-rowheader_p;
patch('XData',[-.1 -.1 1.1 1.1],'YData',[ybot ytop ytop ybot],'FaceColor',header_gray,'EdgeColor','none');

% draw lines
plot([0 1],[1 1]*1-status_p-title_p-rowheader_p,'linewidth',1,'color',line_gray);

X=repmat([colheader_p+marg 1 nan],1,M(1)-1);
y=linspace(0,(1-status_p-title_p-rowheader_p),M(1)+1); y([1 end])=[];
Y=reshape([y;y;nan(1,M(1)-1)],1,[]);
plot(X,Y,'linewidth',1,'color',divider_gray);

% print date on the top right of page
text(.99,1-status_p/2,datestr(now,'mmmm dd, yyyy, HH:MM AM'),'horizontalalignment','right',...
    'verticalalignment','middle','fontunits','normalized','fontsize',status_p*.6,'color',status_gray,'fontangle','italic');
text(0.5,1-status_p-title_p/2,title_text,'horizontalalignment','center',...
    'verticalalignment','middle','fontunits','normalized','fontsize',title_p*.8,'color',title_gray);

% convert to text
M2=matrix(:);
mat_string=reshape(arrayfun(@(x) strtrim(cellstr(sprintf('%2.2f',x))),M2),M);

X=linspace(colheader_p+marg,1,M(2)+1); X(end)=[];
X=X+(X(2)-X(1))/2;
Y=linspace(1-status_p-title_p-rowheader_p,0,M(1)+1); Y(end)=[];
Y=Y+(Y(2)-Y(1))/2;
colheader_X=colheader_p/2; rowheader_y=(1-status_p-title_p-rowheader_p/2);
header_size=min([row_p col_p colheader_p rowheader_p .4])*.5;
% rows
for i = 1:M(1)
    y=Y(i);
    
    % colheader first
    text(colheader_X,y,colheader{i},'horizontalalignment','center','verticalalignment','middle',...
        'fontunits','normalized','fontsize',header_size,'color',text_darkgray,'fontweight','bold');
    
    for j = 1:M(2)
        x=X(j);
        if(i==1)
            text(x,rowheader_y,rowheader{j},'horizontalalignment','center','verticalalignment','middle',...
                'fontunits','normalized','fontsize',header_size,'color',text_darkgray,'fontweight','bold');
        end
        if(i==j),textcolor=diagonal_gray;
        else textcolor=text_gray;
        end
        text(x,y,mat_string{i,j},'horizontalalignment','center','verticalalignment','middle','fontunits','normalized','fontsize',min(row_p,col_p)*.4,'color',textcolor);
    end
end

% add print button
uicontrol('style','pushbutton','units','normalized','position',[.005 1-status_p*.9 .05 status_p*.8],...
    'String','PDF','backgroundcolor',purple,'foregroundcolor',text_darkgray,'CallBack',{@print_matrix,f,title_text});

function print_matrix(hObject,~,fig_handle,title_text)
set(hObject,'visible','off');
filename=sprintf('%s.pdf',strrep(title_text,' ','_'));
print(fig_handle,filename,'-dpdf','-r600');
set(hObject,'visible','on');