function ResultMap = GetAlgorithmInputMap( Input, Algorithm )
    %GETALGORITHMINPUTMAP Summary of this function goes here
    %   Detailed explanation goes here
    if strcmp(Algorithm,'04')
        ResultMap=Input.Result;
    elseif strcmp(Algorithm,'05')
        ResultMap=Input.Result(5,1:2);
    elseif strcmp(Algorithm,'08')
        ResultMap=Input.Results.dispImages;
    elseif strcmp(Algorithm,'12')
        Names=fieldnames(Input.Result);
        for Name=1:length(Names)
           for subArray=1:size(Input.Result.(Names{Name}),3)
               ResultMap{(Name-1)*size(Input.Result.(Names{Name}),3)+subArray}=Input.Result.(Names{Name})(:,:,subArray);
           end
        end
    elseif strcmp(Algorithm,'16')
        ResultMap={Input.Result.F1Map,Input.Result.F2Map};
    else
        ResultMap={Input.Result};
    end
end
