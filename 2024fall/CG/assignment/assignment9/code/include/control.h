#ifndef CONTROL_H
#define CONTROL_H

#include "opengl.h"
extern bool rotate;
extern float eyePosition[3];
extern bool Dragging;
extern int drag_x_origin;
extern int drag_y_origin;
extern float mouse_sensitivity;
extern float camera_angle_v;
extern float camera_angle_h;

void onKeyboard(unsigned char key, int x, int y);
void onSpecialKey(int key, int x, int y);
void mouseButton(int button, int state, int x, int y);
void mouseMove(int x, int y);

#endif