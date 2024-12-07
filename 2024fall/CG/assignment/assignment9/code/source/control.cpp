#include "control.h"

bool rotate = true;
// float eyePosition[3] = {10.0, 10.0, 10.0};
float eyePosition[3] = {190.0, 620.0, 660.0};

bool Dragging = false;
int drag_x_origin = 0;
int drag_y_origin = 0;
float mouse_sensitivity = 0.3;
float camera_angle_v = -132;
float camera_angle_h = 69;


void onKeyboard(unsigned char key, int x, int y) {
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
    printf("eyePosition: %f %f %f\n", eyePosition[0], eyePosition[1], eyePosition[2]);
}

void onSpecialKey(int key, int x, int y) {
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
    printf("eyePosition: %f %f %f\n", eyePosition[0], eyePosition[1], eyePosition[2]);
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
    printf("camera_angle_h: %f, camera_angle_v: %f\n", camera_angle_h, camera_angle_v);
    return;
}