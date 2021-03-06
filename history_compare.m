function history_compare(history,nfield, scales, outputtype, mmode)
% This function compares history output from several different gtc runs.
%
% "history" is a structure generated by read_history
%
% "nfield" is the field you want to diagonose. The default fields are
% 1: phi     % 2: apara     % 3: fluidne
%
% "Scales" should be a vector with the same length as "history",
% characterizing the scales you want for each history
%
% "outputtype":
% 0: total RMS plot     1: individual m-harmonics plot
%
% "mmode":
% mmode can be either a number, or a vector with length(history)
% specifying the m-harmonic we plot if outputtype = 1
%

    n_history=length(history);
    
    %default value is nfield = 1, plotting the phi history
    if ~exist('nfield','var') || isempty(nfield)
        nfield = 1;
    end

    %scale factor for each history.out, to make them more similar
    %default value is an all 1 vector
    if ~exist('scales','var') || isempty(scales)
        scales = ones(n_history, 1);
    elseif (length(scales) ==1)
        scales = ones(n_history, 1);
    elseif (length(scales) ~= n_history)
        error('Error: "history" and "scales" length mismatch');
    end    
    
    %default value is to use the 4th (middle) m-harmonic
    if ~exist('mmode','var') || isempty(mmode)
        mmodes = ones(n_history, 1) * 4;
    elseif (length(mmode) == 1)
        mmodes = ones(n_history,1) * mmode;
    elseif (length(mmode) ~= n_history)
        error('Error: "history" and "mode" length mismatch');
    else
        mmodes = mmode;
    end
    
    %
    if ~exist('outputtype', 'var') || isempty(outputtype)
        outputtype = 0;
    elseif outputtype > 1
        error('Error: Outputtype can only be 0 or 1');
    end    

    colors = get(0,'DefaultAxesColorOrder');
    if (n_history>6)
        print('Warning: Line colors are only defined for the first six lines' )
    end    
    
    
    tmax=0;
    for i=1:size(history,2)
        tmax=max(max(history{i}.t(:)),tmax);
    end
    
    names=cell(1,n_history);
    y1=cell(1,n_history);
    y2=cell(1,n_history);
    for i = 1:n_history
        if (outputtype ==1)
            y1{i} = history{i}.modehist(:,3,mmodes(i), nfield) * scales(i);
            y2{i} = abs(history{i}.modehist(:,1,mmodes(i), nfield)) * scales(i);
        elseif(outputtype == 0)
            y1{i} = history{i}.fieldhist(:,4,nfield)*scales(i);
            y2{i} = history{i}.fieldhist(:,3,nfield)*scales(i);
        end    
        names{i}=history{i}.tag;      
    end
    
    %plots
    for i = 1:n_history
        semilogy(history{i}.t, y1{i}, 'Color', colors(i,:),'linewidth',2);
             if (i==1)
                if (nfield==1)
                    minibound = 10^-7;
                elseif(nfield==2)
                    minibound = 10^-12;
                end
                axis([0,tmax,minibound,10]);
                hold on
             end 
    end
    
    for i= 1:n_history
        semilogy(history{i}.t, y2{i}, '-.', 'Color',colors(i,:), 'linewidth', 2);
    end    
    hold off
    
    % legends
    legend(names,'Location','SouthEast');
    
    % title
    if (nfield==2)
        title('Apara evolution');
    elseif(nfield==1)
        title('phi evolution');
    end
        
end
    
    