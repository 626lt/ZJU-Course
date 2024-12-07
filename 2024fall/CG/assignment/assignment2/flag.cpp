#include <cmath>
#define GL_SILENCE_DEPRECATION
#include <GLUT/glut.h>
#include <iostream>
#include <vector>

// 绘制波多黎各国旗
void display() {
    glClear(GL_COLOR_BUFFER_BIT);

    // 绘制红色条纹
    glColor3f(237.0f / 255.0f, 0.0f / 255.0f, 0.0f / 255.0f); // 红色
    glBegin(GL_QUADS);
        glVertex2f(-1.0f, 1.0f);
        glVertex2f(1.0f, 1.0f);
        glVertex2f(1.0f, 0.6f);
        glVertex2f(-1.0f, 0.6f);
    glEnd();

    glBegin(GL_QUADS);
        glVertex2f(-1.0f, 0.2f);
        glVertex2f(1.0f, 0.2f);
        glVertex2f(1.0f, -0.2f);
        glVertex2f(-1.0f, -0.2f);
    glEnd();

    glBegin(GL_QUADS);
        glVertex2f(-1.0f, -0.6f);
        glVertex2f(1.0f, -0.6f);
        glVertex2f(1.0f, -1.0f);
        glVertex2f(-1.0f, -1.0f);
    glEnd();

    // 绘制白色条纹
    glColor3f(255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0f); // 白色
    glBegin(GL_QUADS);
        glVertex2f(-1.0f, 0.6f);
        glVertex2f(1.0f, 0.6f);
        glVertex2f(1.0f, 0.2f);
        glVertex2f(-1.0f, 0.2f);
    glEnd();

    glBegin(GL_QUADS);
        glVertex2f(-1.0f, -0.2f);
        glVertex2f(1.0f, -0.2f);
        glVertex2f(1.0f, -0.6f);
        glVertex2f(-1.0f, -0.6f);
    glEnd();

    // 绘制蓝色三角形
    glColor3f(8.0f / 255.0f, 68.0f / 255.0f, 255.0f / 255.0f); // 蓝色
    glBegin(GL_TRIANGLES);
        glVertex2f(-1.0f, 1.0f);
        glVertex2f(-1.0f, -1.0f);
        float x = (15 * std::sqrt(3) - 22.5) / 22.5;
        glVertex2f(x, 0.0f);
    glEnd();

    // 绘制白色星星
    glColor3f(255.0f / 255.0f, 255.0f / 255.0f,255.0f / 255.0f); // 白色
    glBegin(GL_POLYGON);
        float x_center = (15 * std::sqrt(3) / 3 - 22.5) / 22.5;
        float y_center = 0.0f;
        float radius = 0.3f;
        float angle = M_PI / 5.0f; // 36 degrees
        float a = cos(angle / 2) /(1 + sin(angle / 2)) * radius;
        float r = sqrt(a * a + radius * radius - 2 * a * radius * cos(angle / 2));
        
        glVertex2f(x_center, y_center);
        for (int i = 0; i < 5; ++i) {
            glVertex2f(x_center + radius * sin(2 * i * angle), 1.5 * radius * cos(2 * i * angle));
            glVertex2f(x_center + r * sin((2 * i + 1) * angle), 1.5 * r * cos((2 * i + 1) * angle));
        }
        glVertex2f(x_center, 1.5 * radius);
    glEnd();

    glFlush();
}

// 初始化设置
void init() {
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // 背景颜色为白色
    glColor3f(0.0f, 0.0f, 0.0f); // 默认绘制颜色
    glOrtho(-1.0, 1.0, -1.0, 1.0, -1.0, 1.0); // 正交投影
}



int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(450, 300);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Puerto Rico Flag");
    init();
    glutDisplayFunc(display);
    glutMainLoop();
    return 0;
}
