function A=read_history(n_history,method)
% This function reads several history.out files from different GTC runs. 
% The argument n_history is an integer indicating the number of history.out
% you want to read in.
% The argument method indicates the way you want to select the history.out. 
% method=1 picks the default places specified in the code
% method=2 picks the files manually through graphic UI


    % provide default method.
    if nargin < 2
        method=1;
    end
    
    A = cell(1, n_history);
   
    for i=1:n_history
        if(method==2)
            [filename,pathname]=uigetfile('h*.out','Select a history.out');
        elseif(method==1)
            filename='history.out';
            % You can specify your default pathname for each i here
            pathname='./';
        else
            error('Error: method must be either 1 or 2!');
        end
        
        A{i}.pathname=pathname;
        
        tmp=importdata([pathname,filename]);
        
        A{i}.ndstep=tmp(1);
        A{i}.nspecies=tmp(2);
        A{i}.mpdiag=tmp(3);
        A{i}.nfield=tmp(4);
        A{i}.modes=tmp(5);
        A{i}.mfdiag=tmp(6);
        A{i}.tstep=tmp(7);
        
        fprintf('File %2d: %s%s\n', i, pathname, filename);
        fprintf('steps: %5d n_species: %1d n_fields: %1d t_step: %e \n', A{i}.ndstep,A{i}.nspecies,A{i}.nfield,A{i}.tstep);
        
        ndstep=tmp(1);
        nspecies=tmp(2);
        mpdiag=tmp(3);
        nfield=tmp(4);
        modes=tmp(5);
        mfdiag=tmp(6);
        tstep=tmp(7);
        
        A{i}.parthist=zeros(ndstep,mpdiag,nspecies);
        A{i}.fieldhist=zeros(ndstep,mfdiag,nfield);
        A{i}.modehist=zeros(ndstep,3,modes,nfield);
        
        index0=8;
        for j=1:ndstep
            A{i}.parthist(j,:,:)=reshape(tmp(index0:mpdiag*nspecies+index0-1),[mpdiag,nspecies]);
            index0=index0+mpdiag*nspecies;
            A{i}.fieldhist(j,:,:)=reshape(tmp(index0:mfdiag*nfield+index0-1),[mfdiag,nfield]);
            index0=index0+mfdiag*nfield;
            A{i}.modehist(j,1:2,:,:)=reshape(tmp(index0:2*modes*nfield+index0-1),[2,modes,nfield]);
            index0=index0+2*modes*nfield;
            
        end
        
        [tmp1,tmp2]=cart2pol(A{i}.modehist(:,1,:,:),A{i}.modehist(:,2,:,:));
        A{i}.modehist(:,3,:,:)=tmp2;
        A{i}.modehist(:,4,:,:)=tmp1;
        A{i}.t = (1:ndstep)*tstep;
        A{i}.tag = fliplr(strtok(strtok(fliplr(A{i}.pathname), '/'), '/'));
        if strcmp(A{i}.tag , '')
            A{i}.tag = 'i';
        end
    end
        
    
    
    
    