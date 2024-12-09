% Plot the color gamuts of sRGB, Adobe RGB, and ProPhoto RGB in CIELAB space with enhanced visualization
figure;
hold on;
title('Comparison of sRGB, Adobe RGB, and ProPhoto RGB in CIELAB Space');

% Create a grid of RGB values
n = 30; % Fewer points for better visual distinction
[r, g, b] = ndgrid(linspace(0, 1, n), linspace(0, 1, n), linspace(0, 1, n));

% Convert the grid of RGB values to XYZ
xyz_sRGB = rgb2xyz([r(:), g(:), b(:)], 'ColorSpace', 'srgb');
xyz_AdobeRGB = rgb2xyz([r(:), g(:), b(:)], 'ColorSpace', 'adobe-rgb-1998');
xyz_ProPhotoRGB = rgb2xyz([r(:), g(:), b(:)], 'ColorSpace', 'prophoto');

% Convert XYZ to LAB
lab_sRGB = xyz2lab(xyz_sRGB);
lab_AdobeRGB = xyz2lab(xyz_AdobeRGB);
lab_ProPhotoRGB = xyz2lab(xyz_ProPhotoRGB);

% Reshape to 3D grid for plotting
lab_sRGB = reshape(lab_sRGB, [n, n, n, 3]);
lab_AdobeRGB = reshape(lab_AdobeRGB, [n, n, n, 3]);
lab_ProPhotoRGB = reshape(lab_ProPhotoRGB, [n, n, n, 3]);

% Extract L, a, b components for each color space
L_sRGB = lab_sRGB(:,:,:,1); a_sRGB = lab_sRGB(:,:,:,2); b_sRGB = lab_sRGB(:,:,:,3);
L_AdobeRGB = lab_AdobeRGB(:,:,:,1); a_AdobeRGB = lab_AdobeRGB(:,:,:,2); b_AdobeRGB = lab_AdobeRGB(:,:,:,3);
L_ProPhotoRGB = lab_ProPhotoRGB(:,:,:,1); a_ProPhotoRGB = lab_ProPhotoRGB(:,:,:,2); b_ProPhotoRGB = lab_ProPhotoRGB(:,:,:,3);

% Plot sRGB gamut with circles and transparency
scatter3(a_sRGB(:), b_sRGB(:), L_sRGB(:), 36, 'o', 'MarkerEdgeColor', 'r', 'MarkerEdgeAlpha', 0.5, 'DisplayName', 'sRGB');

% Plot Adobe RGB gamut with squares and transparency
scatter3(a_AdobeRGB(:), b_AdobeRGB(:), L_AdobeRGB(:), 36, 's', 'MarkerEdgeColor', 'g', 'MarkerEdgeAlpha', 0.5, 'DisplayName', 'Adobe RGB');

% Plot ProPhoto RGB gamut with diamonds and transparency
scatter3(a_ProPhotoRGB(:), b_ProPhotoRGB(:), L_ProPhotoRGB(:), 36, 'd', 'MarkerEdgeColor', 'b', 'MarkerEdgeAlpha', 0.5, 'DisplayName', 'ProPhoto RGB');

% Plot convex hulls to outline the boundaries of each color space (for better volume comparison)
% Convex hull for sRGB
K_sRGB = convhull(a_sRGB(:), b_sRGB(:), L_sRGB(:));
trisurf(K_sRGB, a_sRGB(:), b_sRGB(:), L_sRGB(:), 'FaceColor', 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'sRGB Hull');

% Convex hull for Adobe RGB
K_AdobeRGB = convhull(a_AdobeRGB(:), b_AdobeRGB(:), L_AdobeRGB(:));
trisurf(K_AdobeRGB, a_AdobeRGB(:), b_AdobeRGB(:), L_AdobeRGB(:), 'FaceColor', 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'Adobe RGB Hull');

% Convex hull for ProPhoto RGB
K_ProPhotoRGB = convhull(a_ProPhotoRGB(:), b_ProPhotoRGB(:), L_ProPhotoRGB(:));
trisurf(K_ProPhotoRGB, a_ProPhotoRGB(:), b_ProPhotoRGB(:), L_ProPhotoRGB(:), 'FaceColor', 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'ProPhoto RGB Hull');

% Customize plot
xlabel('a* (green to red)');
ylabel('b* (blue to yellow)');
zlabel('L* (lightness)');
legend;
grid on;
axis tight;
view(3);
