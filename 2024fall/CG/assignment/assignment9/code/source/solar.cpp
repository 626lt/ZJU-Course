#include "solar.h"
#include "texture.h"
#include <vector>

GLint angle = 0;
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
const float sphereOfSun[3] = {100, 1000, 1000};
const float sphereOfPlanet1[3] = {25, 100, 100};
const float sphereOfPlanet2[3] = {50, 100, 100};
const float sphereOfSatellite1[3] = {10, 100, 100};
// define the orbit's radius of the sun, planet1, planet2 and satellite1
const int orbitOfSun = 500;
const int orbitOfPlanet1 = 160;
const int orbitOfPlanet2 = 240;
const int orbitOfSatellite1 = 80;

extern GLuint sunTexture, planet1Texture, planet2Texture, satelliteTexture, skyboxTexture, skyboxTexture1;

void star(const float* color, const float* sphere, GLuint textureID) {
    // 设置颜色
    glColor3f(color[0], color[1], color[2]);

    // 启用纹理
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureID);

    // 绘制带有纹理的球体
    GLUquadric* quad = gluNewQuadric();
    gluQuadricTexture(quad, GL_TRUE); // 启用纹理坐标生成
    gluQuadricNormals(quad, GLU_SMOOTH); // 设置平滑法线

    // 绘制球体
    gluSphere(quad, sphere[0], (int)sphere[1], (int)sphere[2]);

    // 清理
    gluDeleteQuadric(quad);
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
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

void setupLighting(GLfloat *lightPos, GLfloat *_diffuseLight = NULL, GLfloat *_specularLight = NULL, int _num = 0) {
    // 启用光照
    glEnable(GL_LIGHTING);
    int lightNum = 0;
    lightNum = GL_LIGHT0 + _num;
    // 启用光源
    glEnable(lightNum);
    // 设置光源位置
    glLightfv(lightNum, GL_POSITION, lightPos);

    // 设置漫反射光
    if(_diffuseLight != NULL){
        glLightfv(lightNum, GL_DIFFUSE, _diffuseLight);
    }
    
    // 设置镜面反射光
    if (_specularLight != NULL) {
        glLightfv(lightNum, GL_SPECULAR, _specularLight);
    }
}


void draw_solar() {    
    GLfloat light[] = {0.0, 0.0, 0.0, 1.0};
    GLfloat diffuseLight[] = {1.0, 0.9, 0.6, 1.0}; // 接近太阳颜色的漫反射光
    GLfloat specularLight[] = {1.0, 0.9, 0.6, 1.0}; // 白色镜面反射光
    float sphereSun[3] = {150, 100, 100};
    setupLighting(light, NULL, specularLight, 0);
    setupLighting(light, diffuseLight, NULL, 1);

    GLfloat emission[] = {1.0f, 1.0f, 0.8f, 1.0f}; // 设置发光颜色（暖黄色）
    glMaterialfv(GL_FRONT, GL_EMISSION, emission);
    
    star(colorOfSun, sphereSun,sunTexture); // 太阳
    GLfloat no_emission[] = {0.0f, 0.0f, 0.0f, 1.0f}; // 关闭发光
    glMaterialfv(GL_FRONT, GL_EMISSION, no_emission);
    

    // solar system 1
    glPushMatrix();
    {
        glRotatef(angle * speedOfSun, 0.0, 1.0, 0.0); // 公转
        orbit(orbitOfSun); // 太阳轨道
        glTranslatef(orbitOfSun, 0.0, 0.0); // 太阳位置
        star(colorOfSun, sphereOfSun, sunTexture); // 太阳
        // planet 1
        glPushMatrix();
        {
            glRotatef(angleOfPlanet1, 0.0, 0.0, 1.0); // 轨道角度
            glRotatef(angle * speedOfPlanet1, 0.0, 1.0, 0.0); // 行星1公转
            orbit(orbitOfPlanet1); // 行星1轨道
            glTranslatef(orbitOfPlanet1, 0.0, 0.0); // 行星1位置
            star(colorOfPlanet1, sphereOfPlanet1, planet1Texture); // 行星1
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
        star(colorOfSun1, sphereOfSun, sunTexture); // 太阳
        glPushMatrix();
        {
            glRotatef(angleOfPlanet1, 0.0, 0.0, 1.0); // 轨道角度
            glRotatef(angle * speedOfPlanet1, 0.0, 1.0, 0.0); // 行星1公转
            orbit(orbitOfPlanet1); // 行星1轨道
            glTranslatef(orbitOfPlanet1, 0.0, 0.0); // 行星1位置
            star(colorOfPlanet1, sphereOfPlanet1, planet1Texture); // 行星1
        }
        glPopMatrix();
        // planet 2
        glPushMatrix();
        {
            glRotatef(angleOfPlanet2, 0.0, 0.0, 1.0); //  轨道角度
            glRotatef(angle * speedOfPlanet2, 0.0, 1.0, 0.0); // 行星2公转
            orbit(orbitOfPlanet2); // 行星2轨道
            glTranslatef(orbitOfPlanet2, 0.0, 0.0); // 行星2位置
            star(colorOfPlanet2, sphereOfPlanet2, planet2Texture); // 行星2
            // satellite 1
            glPushMatrix();
            {
                glRotatef(angleOfSatellite1, 0.0, 0.0, 1.0); //  轨道角度
                glRotatef(angle * speedOfSatellite1, 0.0, 1.0, 0.0); // 卫星1公转
                orbit(orbitOfSatellite1); // 卫星1轨道
                glTranslatef(orbitOfSatellite1, 0.0, 0.0); // 卫星1位置
                star(colorOfSatellite1, sphereOfSatellite1, satelliteTexture); // 卫星1
            }
            glPopMatrix();
        }
        glPopMatrix();
    }
    glPopMatrix();
}