function [] = matToTxt(A, fileName)

    % Prints the coordinates of non-zero elements in A to the text file 
    % fileName.txt

    fileName=strcat(fileName, '.txt');
    fileID=fopen(fileName, 'w');

    % Header, includes information about the image. Could potentially also
    % include things such as coordinates of image, scale and such if these 
    % are known.
    fprintf(fileID, 'Size of image: %4.0f by %4.0f \n', size(A,1), size(A,2));
    
    k=find(A, sum(sum(A)));

    [x, y]=ind2sub(size(A), k);
    
    X=[x, y]';

    fprintf(fileID, '%4.0f %4.0f\n', X);

end

