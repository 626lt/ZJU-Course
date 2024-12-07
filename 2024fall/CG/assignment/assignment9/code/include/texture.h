#ifndef TEXTURE_H
#define TEXTURE_H

#include <iostream>
#include <vector>
#include <string>

#include "opengl.h"
GLuint loadTexture(char const* path, bool ifSkybox=false);
GLuint loadSkyboxTexture(const char* filepath, bool ifSkybox=false);
#endif