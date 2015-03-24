function [num_obj,out_img]=an_pas_obj(in_img)
cleanimage = noisecomp(in_img, 2, 6, 2, 6, 0.5);
bw_img=bwlabel(bwareaopen(an_gray(cleanimage),100),8);

obj_area_meas=regionprops(bw_img,'Area','MajorAxisLength');
obj_areas=[obj_area_meas.Area];
obj_major_axis=[obj_area_meas.MajorAxisLength];
% disp(max(obj_major_axis))
% allowableAreaIndexes = (obj_areas > area_low) & (obj_areas < area_high);
allowableAreaIndexes = (obj_major_axis<200 );
keeperIndexes = find(allowableAreaIndexes); 
keeperBlobsImage = ismember(bw_img, keeperIndexes); 

out_img=[keeperBlobsImage,mat2gray(cleanimage),mat2gray(in_img)];

%%
CC = bwconncomp(keeperBlobsImage);
num_obj=CC.NumObjects;



end

% 
% % Now I'll demonstrate how to select certain blobs based using the ismember function.
% % Let's say that we wanted to find only those blobs 
% % with an area between 1500 and 20000 pixels.
% allBlobAreas = [blobMeasurements.Area];
% % Get a list of the blobs that meet our criteria and we need to keep. 
% allowableAreaIndexes = (allBlobAreas > 1500) & (allBlobAreas < 20000);
% % That's a logical map of what indexed acceptable blobs are at.
% % Like 0 0 1 0 1 0 0 1 1 0 0 1 0 1 0 0 1
% % We need the actual index, like blobs #3, 5, 8, 9, 12, 14, and 17
% % (to use the above logical array as an example).
% keeperIndexes = find(allowableAreaIndexes); 
% % Extract only those blobs that meet our criteria, and 
% % eliminate those blobs that don't meet our criteria. 
% % Note how we use ismember() to do this.
% keeperBlobsImage = ismember(labeledImage, keeperIndexes); 
% % Re-label with only the keeper blobs kept.
% newLabeledImage = bwlabel(keeperBlobsImage, 8);     % Label each blob so we can make measurements of it
% % Now we're done.  We have a labeled image of blobs that meet our specified criteria.
% imshow(newLabeledImage , []);
% title('"Keeper" blobs');