#define STB_IMAGE_IMPLEMENTATION
#include "opengl.h"
#include "solar.h"
#include "control.h"
#include "obj.h"
#include <vector>
#include "texture.h"
#include <cmath>


const int screenWidth = 1200;
const int screenHeight = 900;
GLuint skyboxTextures[6];
GLuint sunTexture, planet1Texture, planet2Texture, satelliteTexture, skyboxTexture, skyboxTexture1;
GLUquadric* quadric;
extern float eyePosition[3];

void drawSkybox(GLuint textureID[], float translateX, float translateY, float translateZ);

void init();
void display();
void reshape(int w, int h);
void idle();
void initTextures();

void seteyes(){
    glLoadIdentity();
    gluLookAt(eyePosition[0], eyePosition[1], eyePosition[2], 
              eyePosition[0] + sin(camera_angle_v / 180 * M_PI) * cos(camera_angle_h / 180 * M_PI), eyePosition[1] + sin(camera_angle_v / 180 * M_PI) * sin(camera_angle_h / 180 * M_PI), eyePosition[2] + cos(camera_angle_v / 180 * M_PI), 
                // 0,0,0,
              0.0, 1.0, 0.0); // 设置摄像机位置
}


int main(int argc, char** argv){
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(screenWidth, screenHeight);
    glutInitWindowPosition(0, 0);
    glutCreateWindow("Assignment 9");

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

    glClearColor(1.0, 1.0, 1.0, 1.0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_NORMALIZE);
    glEnable(GL_SMOOTH);

    
    glEnable(GL_NORMALIZE); // 启用法向量规范化
    glEnable(GL_SMOOTH); // 启用阴影平滑
    initTextures();

    // 检查纹理是否加载成功
    for(int i = 0; i < 6; ++i){
        if (skyboxTextures[i] == 0){
            std::cerr << "Skybox texture " << i << " failed to load." << std::endl;
            // 您可以选择退出程序或继续不带Skybox的渲染
        }
    }
    glEnable(GL_TEXTURE_2D);

    glEnable(GL_DEPTH_TEST); // 启用深度测试

    quadric = gluNewQuadric();
    gluQuadricTexture(quadric, GL_TRUE); // 启用纹理坐标生成
    gluQuadricNormals(quadric, GLU_SMOOTH); // 平滑法线
}

void idle(){
    if (rotate){
        angle += 1;
    }
    
    glutPostRedisplay(); // 重绘
}

void display(){
    // 设置视角
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // 清除颜色缓冲区和深度缓冲区
    seteyes(); // 设置视角

    // 绘制 solar system
    drawSkybox(skyboxTextures, eyePosition[0], eyePosition[1], eyePosition[2]);
    
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


void drawSkybox(GLuint textureID[], float translateX, float translateY, float translateZ) {
    glEnable(GL_TEXTURE_2D);
    glPushMatrix();
    {   glClearColor(1.0, 1.0, 1.0, 1.0);
        glDisable(GL_LIGHTING);
        glTranslated(translateX, translateY, translateZ);
        glScaled(1.3, 1.3, 1.3);
        
        // 设置Skybox的大小
        float size = 900.0f;

        glBindTexture(GL_TEXTURE_2D, skyboxTextures[0]);
        glBegin(GL_QUADS);
        // 右
        glTexCoord2f(0.0f, 0.0f); glVertex3f(size, -size, -size);
        glTexCoord2f(1.0f, 0.0f); glVertex3f(size, -size,  size);
        glTexCoord2f(1.0f, 1.0f); glVertex3f(size,  size,  size);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(size,  size, -size);
        glEnd();

        glBindTexture(GL_TEXTURE_2D, skyboxTextures[1]);
        glBegin(GL_QUADS);
        // 左
        glTexCoord2f(0.0f, 0.0f); glVertex3f(-size, -size,  size);
        glTexCoord2f(1.0f, 0.0f); glVertex3f(-size, -size, -size);
        glTexCoord2f(1.0f, 1.0f); glVertex3f(-size,  size, -size);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(-size,  size,  size);
        glEnd();

        glBindTexture(GL_TEXTURE_2D, skyboxTextures[2]);
        glBegin(GL_QUADS);
        // 下
        glTexCoord2f(0.0f, 0.0f); glVertex3f(-size, -size, -size);
        glTexCoord2f(1.0f, 0.0f); glVertex3f( size, -size, -size);
        glTexCoord2f(1.0f, 1.0f); glVertex3f( size, -size,  size);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(-size, -size,  size);
        glEnd();

        glBindTexture(GL_TEXTURE_2D, skyboxTextures[3]);
        glBegin(GL_QUADS);
        // 上
        glTexCoord2f(0.0f, 0.0f); glVertex3f(-size, size,  size);
        glTexCoord2f(1.0f, 0.0f); glVertex3f( size, size,  size);
        glTexCoord2f(1.0f, 1.0f); glVertex3f( size, size, -size);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(-size, size, -size);
        glEnd();

        glBindTexture(GL_TEXTURE_2D, skyboxTextures[4]);
        glBegin(GL_QUADS);
        // 前
        glTexCoord2f(0.0f, 0.0f); glVertex3f(-size, -size, size);
        glTexCoord2f(1.0f, 0.0f); glVertex3f( size, -size, size);
        glTexCoord2f(1.0f, 1.0f); glVertex3f( size,  size, size);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(-size,  size, size);
        glEnd();

        glBindTexture(GL_TEXTURE_2D, skyboxTextures[5]);
        glBegin(GL_QUADS);
        // 后
        glTexCoord2f(0.0f, 0.0f); glVertex3f( size, -size, -size);
        glTexCoord2f(1.0f, 0.0f); glVertex3f(-size, -size, -size);
        glTexCoord2f(1.0f, 1.0f); glVertex3f(-size,  size, -size);
        glTexCoord2f(0.0f, 1.0f); glVertex3f( size,  size, -size);
        glEnd();
    }
    glPopMatrix();

    glEnable(GL_LIGHTING);
    glDisable(GL_TEXTURE_2D);
}

void initTextures() {
    sunTexture = loadTexture("textures/sun.jpg");
    planet1Texture = loadTexture("textures/planet1.jpg");
    planet2Texture = loadTexture("textures/planet2.jpg");
    satelliteTexture = loadTexture("textures/satellite.jpg");

    skyboxTextures[0] = loadSkyboxTexture("textures/skybox/right.jpeg");  // 右
    skyboxTextures[1] = loadSkyboxTexture("textures/skybox/left.jpeg");   // 左
    skyboxTextures[2] = loadSkyboxTexture("textures/skybox/bottom.jpeg");  // 上
    skyboxTextures[3] = loadSkyboxTexture("textures/skybox/top.jpeg"); // 下
    skyboxTextures[4] = loadSkyboxTexture("textures/skybox/front.jpeg");  // 前
    skyboxTextures[5] = loadSkyboxTexture("textures/skybox/back.jpeg");   // 后
}