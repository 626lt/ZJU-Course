#include "opengl.h"
#include "solar.h"
#include "control.h"
#include "obj.h"

const int screenWidth = 1200;
const int screenHeight = 900;
float relativePosition[3] = {0.0, 5.0, 5.0};

void init();
void display();
void reshape(int w, int h);
void idle();
void drawAxes();


int main(int argc, char** argv){
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(screenWidth, screenHeight);
    glutInitWindowPosition(0, 0);
    glutCreateWindow("Assignment 8");

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

void init(){
    glClearColor(0.0, 0.0, 0.0, 0.0);

    glEnable(GL_DEPTH_TEST); // 启用深度测试
    glEnable(GL_NORMALIZE); // 启用法向量规范化
    glEnable(GL_SMOOTH); // 启用阴影平滑
}

void idle(){
    glutPostRedisplay(); // 重绘
}

void display(){
    // 设置视角
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // 清除颜色缓冲区和深度缓冲区
    if(rotate) angle += 3; // angle 更新才能开始转动
    glLoadIdentity();
    gluLookAt(eyePosition[0], eyePosition[1], eyePosition[2], 0.0, 0.0, 0.0, 0.0, 1.0, 0.0); // 设置摄像机位置
    // 设置摄像机角度，围绕x轴和y轴旋转
    glRotated(camera_angle_v, 1.0, 0.0, 0.0); 
    glRotated(camera_angle_h, 0.0, 1.0, 0.0);

    // 绘制坐标轴
    drawAxes();


    // 绘制 solar system
    draw_solar();
    
    glutSwapBuffers();
}

void reshape(int w, int h){
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    glMatrixMode(GL_PROJECTION); // 设置投影矩阵
    glLoadIdentity();
    gluPerspective(45.0, (GLfloat)w / (GLfloat)h, 0.01f, 2000.0f);
    glMatrixMode(GL_MODELVIEW); // 设置模型视图矩阵
    glLoadIdentity();
}


void drawAxes(){
    glBegin(GL_LINES);
    
    // X axis - Red
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(1.0, 0.0, 0.0);
    
    // Y axis - Green
    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 1.0, 0.0);
    
    // Z axis - Blue
    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 1.0);
    
    glEnd();
}
