clear all

[hsv_image, img_rgb] = loadImage();

[orange_centroids, ROI_mask] = orangeDots(hsv_image);

[purple_centroids, ROI_mask_purple] = purpleDots(hsv_image);

[transformation,transformation_purple, homography_matrix,homography_matrix_purple] = computeHomography(orange_centroids, purple_centroids);

[green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats] = detectGamePieces(hsv_image, ROI_mask);

displayResults(img_rgb, transformation_purple, green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats);
