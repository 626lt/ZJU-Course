#include "obj.h"
#include <iostream>

OBJ::OBJ(const char* filename) {
    this->load(filename); // Replace
}

bool OBJ::load(const char* filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Failed to open file: " << filename << std::endl;
        return false;
    }

    vertices.reserve(10000);
    indices.reserve(10000);

    std::string line;
    while (std::getline(file, line)) {
        if (line.substr(0, 2) == "v ") {
            std::istringstream s(line.substr(2));
            GLfloat x, y, z;
            s >> x; s >> y; s >> z;
            vertices.push_back(x);
            vertices.push_back(y);
            vertices.push_back(z);
        } else if (line.substr(0, 2) == "f ") {
            std::istringstream s(line.substr(2));
            std::string a, b, c;
            s >> a; s >> b; s >> c;
            indices.push_back(std::stoi(a.substr(0, a.find('/'))) - 1);
            indices.push_back(std::stoi(b.substr(0, b.find('/'))) - 1);
            indices.push_back(std::stoi(c.substr(0, c.find('/'))) - 1);
        }
    }
    file.close();
    return true;
}

void OBJ::draw() const {
    glColor3f(0.8, 0.8, 0.0);
    glBegin(GL_TRIANGLES);
    for (size_t i = 0; i < indices.size(); i += 3) {
        glVertex3f(vertices[indices[i] * 3], vertices[indices[i] * 3 + 1], vertices[indices[i] * 3 + 2]);
        glVertex3f(vertices[indices[i + 1] * 3], vertices[indices[i + 1] * 3 + 1], vertices[indices[i + 1] * 3 + 2]);
        glVertex3f(vertices[indices[i + 2] * 3], vertices[indices[i + 2] * 3 + 1], vertices[indices[i + 2] * 3 + 2]);
    }
    glEnd();
}