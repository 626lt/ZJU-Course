#ifndef OBJ_H
#define OBJ_H

#include "opengl.h"
#include <fstream>
#include <vector>
#include <string>
#include <sstream>

class OBJ {
public:
    OBJ(const char* filename);
    bool load(const char* filename);
    void draw() const;

private:
    std::vector<GLfloat> vertices;
    std::vector<GLuint> indices;
};
#endif