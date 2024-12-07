#include<iostream>
#include<math.h>
#if defined (__APPLE__)
    #define GL_SILENCE_DEPRECATION
    #include <GLUT/glut.h>
#elif defined(_WIN32) || defined(_WIN64) || defined(__linux__)
    #include <GL/glut.h>
#endif
#include "control.h"

const int screenWidth = 1200;
const int screenHeight = 900;

GLint angle = 0;
// bool rotate = true;
// bool Dragging = false;
// // define the drag position
// int drag_x_origin = 0;
// int drag_y_origin = 0;
// // set the mouse sensitivity
// float mouse_sensitivity = 0.1;

// // camera position and angle
// float eyePosition[3] = {0.0, 200.0, 1000.0};
// float camera_angle_v = 0.0;
// float camera_angle_h = 0.0;
// revolution speed
const float speedOfSun = 360.0 / 1080;
const float speedOfPlanet1 = 360.0 / 720;
const float speedOfPlanet2 = 360.0 / 540;
const float speedOfSatellite1 = 360.0 / 180;
// define the angle of the self-rotation
const float angleOfSun = 0.0;
const float angleOfPlanet1 = 20.0;
const float angleOfPlanet2 = -20.0;
const float angleOfSatellite1 = 30.0;
// define the color of the sun, planet1, planet2 and satellite1
const float colorOfSun[3] = {1.0, 0.0, 0.0};
const float colorOfSun1[3] = {1.0, 0.3, 0.05};
const float colorOfPlanet1[3] = {0.8, 0.3, 0.3};
const float colorOfPlanet2[3] = {0.3, 0.3, 0.8};
const float colorOfSatellite1[3] = {0.0, 0.8, 0.8};
const float colorOfOrbit[3] = {1.0, 1.0, 1.0};
// define the radius of the sun, planet1, planet2 and satellite1
const float sphereOfSun[3] = {100, 50, 50};
const float sphereOfPlanet1[3] = {25, 20, 20};
const float sphereOfPlanet2[3] = {50, 40, 40};
const float sphereOfSatellite1[3] = {10, 10, 10};
// define the orbit's radius of the sun, planet1, planet2 and satellite1
const int orbitOfSun = 500;
const int orbitOfPlanet1 = 160;
const int orbitOfPlanet2 = 240;
const int orbitOfSatellite1 = 80;

void init();
void display();
void reshape(int w, int h);
void idle();


int main(int argc, char** argv){
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(screenWidth, screenHeight);
    glutInitWindowPosition(0, 0);
    glutCreateWindow("Assignment 4");
    glClearColor(0.0, 0.0, 0.0, 0.0);

    init();

    glutKeyboardFunc(onKeyboard); // 键盘事件
    glutSpecialFunc(onSpecialKey); // 特殊键盘事件
    glutDisplayFunc(display); // 显示事件
    glutIdleFunc(idle); // 空闲事件
    glutReshapeFunc(reshape); // 设置视图
    glutMouseFunc(mouseButton); // 鼠标点击事件
    glutMotionFunc(mouseMove); // 鼠标移动事件

    glutMainLoop();
    return 0;
}

void init()
{
    glClearColor(0.0, 0.0, 0.0, 0.0);

    glEnable(GL_DEPTH_TEST); // 启用深度测试
    glEnable(GL_NORMALIZE); // 启用法向量规范化
    glEnable(GL_SMOOTH); // 启用阴影平滑
}

void orbit(const int radius)
{
    #ifdef ORBIT
    glBegin(GL_LINE_LOOP);
    glColor3f(colorOfOrbit[0],colorOfOrbit[1],colorOfOrbit[2]);
    for(int i = 0; i < 360; i++)
    {
        float theta = i * M_PI / 180;
        glVertex3f(radius * cos(theta), 0.0, radius * sin(theta));
    }
    glEnd();
    #endif
    return;
}

void star(const float* color, const float* sphere)
{
    glColor3f(color[0], color[1], color[2]);
    glutSolidSphere(sphere[0], sphere[1], sphere[2]);
}

void display(){
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // 清除颜色缓冲区和深度缓冲区
    if(rotate) angle += 3; // angle 更新才能开始转动
    glLoadIdentity();
    gluLookAt(eyePosition[0], eyePosition[1], eyePosition[2], 0.0, 0.0, 0.0, 0.0, 1.0, 0.0); // 设置摄像机位置
    // 设置摄像机角度，围绕x轴和y轴旋转
    glRotated(camera_angle_v, 1.0, 0.0, 0.0); 
    glRotated(camera_angle_h, 0.0, 1.0, 0.0);
    // solar system 1
    glPushMatrix();
    {
        glRotatef(angle * speedOfSun, 0.0, 1.0, 0.0); // 公转
        orbit(orbitOfSun); // 太阳轨道
        glTranslatef(orbitOfSun, 0.0, 0.0); // 太阳位置
        star(colorOfSun, sphereOfSun); // 太阳
        // planet 1
        glPushMatrix();
        {
            glRotatef(angleOfPlanet1, 0.0, 0.0, 1.0); //  轨道角度
            glRotatef(angle * speedOfPlanet1, 0.0, 1.0, 0.0); // 行星1公转
            orbit(orbitOfPlanet1); // 行星1轨道
            glTranslatef(orbitOfPlanet1, 0.0, 0.0); // 行星1位置
            star(colorOfPlanet1, sphereOfPlanet1); // 行星1
        }
        glPopMatrix();
    }
    glPopMatrix();

    // solar system 2
    glPushMatrix();
    {
        glRotatef(angleOfSun, 0.0, 0.0, 1.0); // 公转
        glRotatef(angle * speedOfSun, 0.0, 1.0, 0.0); // 公转
        orbit(orbitOfSun); // 太阳轨道
        glTranslatef(-orbitOfSun, 0.0, 0.0); // 太阳位置
        star(colorOfSun1, sphereOfSun); // 太阳
        glPushMatrix();
        {
            glRotatef(angleOfPlanet1, 0.0, 0.0, 1.0); // 轨道角度
            glRotatef(angle * speedOfPlanet1, 0.0, 1.0, 0.0); // 行星1公转
            orbit(orbitOfPlanet1); // 行星1轨道
            glTranslatef(orbitOfPlanet1, 0.0, 0.0); // 行星1位置
            star(colorOfPlanet1, sphereOfPlanet1); // 行星1
        }
        glPopMatrix();
        // planet 2
        glPushMatrix();
        {
            glRotatef(angleOfPlanet2, 0.0, 0.0, 1.0); //  轨道角度
            glRotatef(angle * speedOfPlanet2, 0.0, 1.0, 0.0); // 行星2公转
            orbit(orbitOfPlanet2); // 行星2轨道
            glTranslatef(orbitOfPlanet2, 0.0, 0.0); // 行星2位置
            star(colorOfPlanet2, sphereOfPlanet2); // 行星2
            // satellite 1
            glPushMatrix();
            {
                glRotatef(angleOfSatellite1, 0.0, 0.0, 1.0); //  轨道角度
                glRotatef(angle * speedOfSatellite1, 0.0, 1.0, 0.0); // 卫星1公转
                orbit(orbitOfSatellite1); // 卫星1轨道
                glTranslatef(orbitOfSatellite1, 0.0, 0.0); // 卫星1位置
                star(colorOfSatellite1, sphereOfSatellite1); // 卫星1
            }
            glPopMatrix();
        }
        glPopMatrix();
    }
    glPopMatrix();
    glutSwapBuffers();
}

void idle() {
    glutPostRedisplay(); // 重绘
}

void reshape(int w, int h) {
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    glMatrixMode(GL_PROJECTION); // 设置投影矩阵
    glLoadIdentity();
    gluPerspective(45.0, (GLfloat)w / (GLfloat)h, 0.01f, 2000.0f);
    glMatrixMode(GL_MODELVIEW); // 设置模型视图矩阵
    glLoadIdentity();
}
