#ifndef OPENGL_H
#define OPENGL_H

#if defined (__APPLE__)
    #define GL_SILENCE_DEPRECATION
    #include <GLUT/glut.h>
#elif defined(_WIN32) || defined(_WIN64) || defined(__linux__)
    #include <GL/glut.h>
#endif
// #include <OpenGL/gl3.h>
#include <iostream>
#include <math.h>

#endif