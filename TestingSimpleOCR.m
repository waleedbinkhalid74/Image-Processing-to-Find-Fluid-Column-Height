imAdd = 'test13.jpg';
image = imread(imAdd);
ocrtxt = ocr(image,'CharacterSet','ABCDEFGHIJKLMNOP', 'TextLayout', 'Block');
letter = ocrtxt.Text;
% letter = ocrtxt;
display(letter);