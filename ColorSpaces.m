% Simulate sRGB vs. Adobe RGB and ProPhoto RGB with extreme exaggeration for sRGB gamut limitation
imgSize = [600, 1200]; % Image size for visibility

% Define highly saturated colors that are out of gamut for sRGB but fit in AdobeRGB and ProPhotoRGB
purple_sRGB = [1.5, 0, 1.5];   % Extremely saturated purple
cyan_sRGB = [0, 2.0, 2.0];     % Extremely saturated cyan
green_sRGB = [0, 2.0, 0];      % Extremely saturated green
red_sRGB = [2.0, 0, 0];        % Extremely saturated red
blue_sRGB = [0, 0, 2.0];       % Extremely saturated blue

% Create blank images for each color space
img_sRGB = ones(imgSize(1), imgSize(2), 3);
img_AdobeRGB = img_sRGB;
img_ProPhotoRGB = img_sRGB;
img_Difference = img_sRGB;

% Define a threshold for out-of-gamut colors (where sRGB would fail)
gamutLimit = 1.0;
compressionFactor = 0.5;  % Exaggerated factor to desaturate out-of-gamut colors

% Simulate sRGB: desaturate out-of-gamut colors aggressively
for i = 1:imgSize(2)
    if i <= imgSize(2)/5
        color = purple_sRGB;
    elseif i <= 2*imgSize(2)/5
        color = cyan_sRGB;
    elseif i <= 3*imgSize(2)/5
        color = green_sRGB;
    elseif i <= 4*imgSize(2)/5
        color = red_sRGB;
    else
        color = blue_sRGB;
    end
    
    % Apply extreme desaturation to simulate sRGB limitations (shift to grayscale for out-of-gamut)
    clippedColor = min(color, gamutLimit);
    outOfGamutMask = color > gamutLimit;  % Detect out-of-gamut colors
    
    % If out-of-gamut, reduce the saturation drastically, else leave it unchanged
    finalColor_sRGB = clippedColor + outOfGamutMask .* (compressionFactor * (color - clippedColor));
    % Convert to grayscale for a dramatic effect in out-of-gamut regions
    grayscale_sRGB = repmat(mean(clippedColor), 1, 3);
    img_sRGB(:, i, :) = repmat(reshape(finalColor_sRGB .* (1-outOfGamutMask) + grayscale_sRGB .* outOfGamutMask, [1, 1, 3]), imgSize(1), 1);
    
    % Adobe RGB and ProPhoto RGB can represent full colors without clipping
    img_AdobeRGB(:, i, :) = repmat(reshape(color, [1, 1, 3]), imgSize(1), 1);
    img_ProPhotoRGB(:, i, :) = repmat(reshape(color, [1, 1, 3]), imgSize(1), 1);
    
    % Create a difference image to highlight the differences between sRGB and Adobe RGB
    img_Difference(:, i, :) = abs(img_AdobeRGB(:, i, :) - img_sRGB(:, i, :));
end

% Plot the three images and the difference image
figure;
subplot(1, 4, 1);
imshow(img_sRGB);
title('Simulated sRGB (Desaturated Out-of-Gamut)');

subplot(1, 4, 2);
imshow(img_AdobeRGB);
title('Adobe RGB');

subplot(1, 4, 3);
imshow(img_ProPhotoRGB);
title('ProPhoto RGB');

subplot(1, 4, 4);
imshow(img_Difference);
title('Difference (Adobe RGB vs sRGB)');
