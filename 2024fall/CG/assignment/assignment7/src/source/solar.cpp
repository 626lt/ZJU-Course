#include "solar.h"

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
const float sphereOfSun[3] = {100, 50, 50};
const float sphereOfPlanet1[3] = {25, 20, 20};
const float sphereOfPlanet2[3] = {50, 40, 40};
const float sphereOfSatellite1[3] = {10, 10, 10};
// define the orbit's radius of the sun, planet1, planet2 and satellite1
const int orbitOfSun = 500;
const int orbitOfPlanet1 = 160;
const int orbitOfPlanet2 = 240;
const int orbitOfSatellite1 = 80;

void star(const float* color, const float* sphere){
    glColor3f(color[0], color[1], color[2]);
    glutSolidSphere(sphere[0], sphere[1], sphere[2]);
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

void draw_solar(){
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
}