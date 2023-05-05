function [cpIdx1,cpIdx2,players,isSubstitute,showSubstitute,yellowCardRecord] = YellowCard(nPlayers,cpIdx1,cpIdx2,players,yellowCardRecord)
    % This function define the collision foul

    cardPos = (players{1}(cpIdx1,:)+players{1}(cpIdx2,:))/2;
    rectangle('Position',[cardPos(1)+2.5 cardPos(2)+2.5 3 4],'FaceColor','#FFC90E','EdgeColor','none');
    text(0,-33,'Collision foul!','HorizontalAlignment','center','Color','y','FontSize',15);
    if rand(1) < 0.5
        fIdx = cpIdx1;
    else
        fIdx = cpIdx2;
    end
    players{4}(fIdx,1) = players{4}(fIdx,1) + 1;
    ycIdx = fIdx + players{4}(fIdx,2)*nPlayers; % If the player had been subsitituted, the idx is different
    yellowCardRecord = [yellowCardRecord ycIdx];
    text(-10,-43,'#','HorizontalAlignment','center','Color','w','FontSize',12);
    if players{3}(fIdx) == 0
        text(-9,-43,num2str(ycIdx),'HorizontalAlignment','left','Color','#FF5656','FontSize',12);
    else
        text(-9,-43,num2str(ycIdx),'HorizontalAlignment','left','Color','#0092FF','FontSize',12);
    end
    if players{4}(fIdx,1) == 1
        text(-6,-43,'get a yellow card!','HorizontalAlignment','left','Color','w','FontSize',12);
        isSubstitute = false;
        showSubstitute = false;
    elseif players{4}(fIdx,1) == 2
        text(-6,-43,'get a second yellow card!','HorizontalAlignment','left','Color','w','FontSize',12);
        isSubstitute = true;
        showSubstitute = true;
        players{4}(fIdx,2) = players{4}(fIdx,2) + 1;
        players{4}(fIdx,1) = 0;
    else
        isSubstitute = false;
        showSubstitute = false;
    end
    pause(2)
    repulsion = 3;
    players{1}(cpIdx1,1) = players{1}(cpIdx1,1) + repulsion;
    players{1}(cpIdx2,1) = players{1}(cpIdx2,1) - repulsion;
    players{1}(cpIdx1,2) = players{1}(cpIdx1,2) - repulsion;
    players{1}(cpIdx2,2) = players{1}(cpIdx2,2) - repulsion;

end

