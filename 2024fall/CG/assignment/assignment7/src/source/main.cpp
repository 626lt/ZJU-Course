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
void draw_Bézier();
void drawAxes();
void drawBranch(int depth, float length);

int main(int argc, char** argv){
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(screenWidth, screenHeight);
    glutInitWindowPosition(0, 0);
    glutCreateWindow("Assignment 7");

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

    // 绘制 obj 模型
    glPushMatrix();
    glTranslatef(relativePosition[0], relativePosition[1], relativePosition[2]);
    glTranslatef(0.0, 0.0, 10.0);
    glRotatef(180, 0.0, 1.0, 0.0);
    glScalef(50, 50, 50);
    OBJ obj("obj/_car1.obj");
    obj.draw();
    glPopMatrix();

    // 绘制 Bézier 曲面
    glPushMatrix();
    glTranslatef(0.0, 35.0, 0.0); // Adjust the position of the Bézier surface
    glScalef(20.0, 20.0, 20.0); // Scale the Bézier surface
    glColor3f(0, 0, 0.8); // Set the color of the Bézier surface
    draw_Bézier(); // Draw the Bézier surface
    glPopMatrix();

    // 绘制 solar system
    draw_solar();
    
    // 绘制形状连接模型
    glPushMatrix();
    glTranslatef(0.0, -50.0, 0.0); // Adjust the position of the pattern
    glScalef(10.0, 10.0, 10.0); // Scale the pattern
    for (int i = 0; i < 6; ++i) {
        glPushMatrix();
        glColor3f(0.8, 0.8, 1.0); // Light blue color for the snowflake
        glTranslatef(0.0, 15.0, -15.0); // Translate to create the snowflake
        glRotatef(i * 60.0, 0.0, 1.0, 0.0); // Rotate to create 6 branches
        glPushMatrix();
        glTranslatef(0.0, -1.5, 0.0); // Translate to create the branch
        glutSolidCube(1.0);
        glPopMatrix();

        for (int j = 0; j < 5; ++j) {
            glPushMatrix();
            glTranslatef(0.0, 0.0, j * 2.0); // Translate to create segments of the branch
            glutSolidCube(1.0);
            glPopMatrix();
        }
        glPopMatrix();
    }
    glPopMatrix();

    // 绘制 L-system pattern
    for (int i = 0; i < 6; ++i) {
        glPushMatrix();
        glScalef(10, 10, 10);
        glColor3f(0.8, 0.8, 1.0); // Light blue color for the snowflake
        glTranslatef(0.0, 16.0, -15.0); // Translate to create the snowflake
        glRotatef(i * 60.0, 0.0, 1.0, 0.0); // Rotate to create 6 branches
        glPushMatrix();
        glTranslatef(0.0, -1.5, 0.0); // Translate to create the branch
        drawBranch(4, 3.0); // 递归绘制分支，深度为3，初始长度为1.0
        glPopMatrix();
        glPopMatrix();
    }

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

void draw_Bézier(){
    GLfloat ctrlpoints[4][4][3] = {
        {{-3, -1.5, 0.0}, {-0.5, -1.5, 0.0}, {0.5, -1.5, 0.0}, {3, -1.5, 0.0}},
        {{-3, -0.5, -2.0}, {-0.5, -0.5, -2.0}, {0.5, -0.5, -2.0}, {3, -0.5, -2.0}},
        {{-3, 0.5, -2.0}, {-0.5, 0.5, -2.0}, {0.5, 0.5, -2.0}, {3, 0.5, -2.0}},
        {{-3, 1.5, 0.0}, {-0.5, 1.5, 0.0}, {0.5, 1.5, 0.0}, {3, 1.5, 0.0}}
    };
    glEnable(GL_AUTO_NORMAL);
    glEnable(GL_NORMALIZE);
    // 2D Bézier surface
    glMap2f(GL_MAP2_VERTEX_3, 0.0, 1.0, 3, 4, 0.0, 1.0, 12, 4, &ctrlpoints[0][0][0]);
    glEnable(GL_MAP2_VERTEX_3);
    glMapGrid2f(50, 0.0, 1.0, 50, 0.0, 1.0);
    glEvalMesh2(GL_FILL, 0, 50, 0, 50);

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

void drawBranch(int depth, float length){
    if (depth == 0) {
        glutSolidCube(length);
        return;
    }

    // 绘制当前段
    glutSolidCube(length);

    // 生成三个子块向外扩散
    for (int k = 0; k < 6; ++k) {
        glPushMatrix();
        glRotatef(k * 60.0, 0.0, 0.0, 1.0); // Rotate to create 3 sub-branches
        glTranslatef(length, 0.0, 0.0); // Translate to position the sub-branch
        drawBranch(depth - 1, length * 0.5); // 递归绘制子块
        glPopMatrix();
    }

    // 在 Y 轴方向上延伸
    glPushMatrix();
    glTranslatef(0.0, length, 0.0); // Translate along Y axis
    drawBranch(depth - 1, length * 0.5); // 递归绘制子块
    glPopMatrix();
}