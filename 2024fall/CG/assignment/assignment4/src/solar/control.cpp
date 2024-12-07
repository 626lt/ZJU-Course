#include<iostream>
#include<math.h>
#define GL_SILENCE_DEPRECATION
#include <GLUT/glut.h>
#include "control.h"

bool rotate = true;
float eyePosition[3] = {0.0, 20.0, 10.0};
bool Dragging = false;
int drag_x_origin = 0;
int drag_y_origin = 0;
float mouse_sensitivity = 0.1;
float camera_angle_v = 0.0;
float camera_angle_h = 0.0;


void onKeyboard(unsigned char key, int x, int y) {
    printf("eyePosition: %f %f %f\n", eyePosition[0], eyePosition[1], eyePosition[2]);
    switch (key){
        case 'r':
            rotate = !rotate;
            break;
        case 27:
            exit(0);
            break;
        case 'w':
            eyePosition[1] += 10;
            break;
        case 's':
            eyePosition[1] -= 10;
            break;
        case 'a':
            eyePosition[0] -= 10;
            break;
        case 'd':
            eyePosition[0] += 10;
            break;
        default:
            break;
    }
}

void onSpecialKey(int key, int x, int y) {
    printf("eyePosition: %f %f %f\n", eyePosition[0], eyePosition[1], eyePosition[2]);
    switch (key){
        case GLUT_KEY_UP:
            eyePosition[2] -= 10;
            break;
        case GLUT_KEY_DOWN:
            eyePosition[2] += 10;
            break;
        default:
            break;
    }
}

void mouseButton(int button, int state, int x, int y){
    if(button == GLUT_LEFT_BUTTON){
        if(state == GLUT_DOWN){
            Dragging = true;
            drag_x_origin = x;
            drag_y_origin = y;
        }
        else{
            Dragging = false;
        }
    }
}

void mouseMove(int x, int y){
    if(Dragging){
        camera_angle_h += (x - drag_x_origin) * mouse_sensitivity;
        camera_angle_v += (y - drag_y_origin) * mouse_sensitivity;
        drag_x_origin = x;
        drag_y_origin = y;
    }
    return;
}