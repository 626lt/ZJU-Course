#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <cmath>

void ppmRead(char* filename, unsigned char* data, int* w, int* h) {
	char header[1024];
	FILE* fp = NULL;
	int line = 0;

	fp = fopen(filename, "rb");
	while (line < 2) {
		fgets(header, 1024, fp);
		if (header[0] != '#') {
			++line;
		}
	}
	sscanf(header, "%d %d\n", w, h);
	fgets(header, 20, fp);
	fread(data, (*w)*(*h) * 3, 1, fp);

	fclose(fp);
}
void ppmWrite(const char* filename, unsigned char* data, int w, int h) {
	FILE* fp;
	fp = fopen(filename, "wb");

	fprintf(fp, "P6\n%d %d\n255\n", w, h);
	fwrite(data, w*h * 3, 1, fp);

	fclose(fp);
}

void draw(unsigned char* data, int w, int h, int cx, int cy, int ra, int rb, float rotate = 0, int method = 0) {
	float dtheta = 0.01;
	float cos_dtheta = cos(dtheta);
	float sin_dtheta = sin(dtheta);

	float cos_rotate = cos(rotate);
	float sin_rotate = sin(rotate);

	float x_i = ra, y_i = 0, x_i_prev, y_i_prev;
	for (float theta = 0; theta < 2 * M_PI; theta += dtheta) {
		if(method == 0){
			// 参数方程计算，需要大量 cos sin 计算 
			x_i = ra * cos(theta);
			y_i = rb * sin(theta);
		}else{
			// 迭代计算，会累积迭代误差
			x_i_prev = x_i;
			y_i_prev = y_i;
			x_i = x_i_prev * cos_dtheta - y_i_prev * sin_dtheta * ra / rb;
			y_i = y_i_prev * cos_dtheta + x_i_prev * sin_dtheta * rb / ra;
		}
		// rotate
		int x = x_i * cos_rotate - y_i * sin_rotate + cx;
		int y = x_i * sin_rotate + y_i * cos_rotate + cy;
		// 检查是否在画布内部
		if (x >= 0 && x < w && y >= 0 && y < h) {
			data[(y*w + x) * 3 + 0] = 255;
			data[(y*w + x) * 3 + 1] = 255;
			data[(y*w + x) * 3 + 2] = 255;
		}
	}
	return;
}

int main() {
	unsigned char data[400*300*3] = { 0 };
	draw(data, 400, 300, 200, 150, 100, 50, 3 * M_PI / 4, 0);
	ppmWrite("test1.ppm", data, 400, 300);
	unsigned char data1[400*300*3] = { 0 };
	draw(data1, 400, 300, 200, 150, 100, 50, M_PI / 4, 1);
	ppmWrite("test2.ppm", data1, 400, 300);
	return 0;
}