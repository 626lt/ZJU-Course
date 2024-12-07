#ifndef SOLAR_H
#define SOLAR_H

#include "opengl.h"
#include <string>

extern GLint angle;

extern const float speedOfSun;
extern const float speedOfPlanet1;
extern const float speedOfPlanet2;
extern const float speedOfSatellite1;
// define the angle of the self-rotation
extern const float angleOfSun;
extern const float angleOfPlanet1;
extern const float angleOfPlanet2;
extern const float angleOfSatellite1;
extern const float colorOfSun[3];
extern const float colorOfSun1[3];
extern const float colorOfPlanet1[3];
extern const float colorOfPlanet2[3];
extern const float colorOfSatellite1[3];
extern const float colorOfOrbit[3];
extern const float sphereOfSun[3];
extern const float sphereOfPlanet1[3];
extern const float sphereOfPlanet2[3];
extern const float sphereOfSatellite1[3];
extern const int orbitOfSun;
extern const int orbitOfPlanet1;
extern const int orbitOfPlanet2;
extern const int orbitOfSatellite1;

void orbit(const int radius);
void star(const float* color, const float* sphere, GLuint textureID);
void draw_solar();
#endif

