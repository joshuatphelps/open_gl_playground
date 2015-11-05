//
//  main.m
//  open-gl-playground
//
//  Created by Phelps, Josh on 11/4/15.
//  Copyright © 2015 MLB. All rights reserved.
//

#include <glew.h>
#import <Cocoa/Cocoa.h>
#include <SDL.h>

// c++
#include <string>
#include <iostream>
#include <fstream>

#define GLEW_STATIC

using namespace std;

std::string fileContentsForShader(std::string shaderName) {
  std::string filePath = "/Users/phelps/Library/Developer/Xcode/DerivedData/open-gl-playground-ggasfuugjomjeqbwrnqvaidwhusa/Build/Products/Debug/open-gl-playground.app/Contents/Resources/";
  filePath.append(shaderName);
  
  std::string line = "";
  std::string fileContents = "";
  ifstream myfile;
  myfile.open (filePath, ios::in);
  if (myfile.is_open())
  {
    while ( getline (myfile,line)) {
      fileContents.append(line).append("\n");
    }
    myfile.close();
  }
  
  else {
    cout << "Unable to open file";
    cout << strerror(errno);
  }
  
  return fileContents;
}

int main(int argc, const char * argv[]) {
  SDL_Init(SDL_INIT_EVERYTHING);
  
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);

  SDL_Window* window = SDL_CreateWindow("OpenGL", 100, 100, 800, 600, SDL_WINDOW_OPENGL);
  
  SDL_GLContext context = SDL_GL_CreateContext(window);
  
  glewExperimental = GL_TRUE;
  glewInit();
  
  GLuint vertexBuffer = 0;
  glGenBuffers(1, &vertexBuffer);
  
  printf("%u\n", vertexBuffer);
  
  float vertices[] = {
    0.0f,  0.5f, // Vertex 1 (X, Y)
    0.5f, -0.5f, // Vertex 2 (X, Y)
    -0.5f, -0.5f  // Vertex 3 (X, Y)
  };
  
  GLuint vbo; // vertex buffer eobject
  glGenBuffers(1, &vbo);
  glBindBuffer(GL_ARRAY_BUFFER, vbo);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
  
  __unused const GLchar *source = "vertext_shader.vert";
  
  const GLubyte *string = glGetString(GL_SHADING_LANGUAGE_VERSION);
  printf("%s\n.", string);

  
//  std::string line = "";
//  std::string fileContents = "";
//  ifstream myfile;
//  myfile.open ("/Users/phelps/Library/Developer/Xcode/DerivedData/open-gl-playground-ggasfuugjomjeqbwrnqvaidwhusa/Build/Products/Debug/open-gl-playground.app/Contents/Resources/vertex_shader.vert", ios::in);
//  if (myfile.is_open())
//  {
//    while ( getline (myfile,line)) {
//      fileContents.append(line).append("\n");
//    }
//    myfile.close();
//  }
//  
//  else {
//    cout << "Unable to open file";
//    cout << strerror(errno);
//  }

  std::string vertextShader = fileContentsForShader("vertex_shader.vert");
  
  GLchar const* files[] = { vertextShader.c_str() };
  GLint lengths[]       = { static_cast<GLint>(vertextShader.size())  };

  GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(vertexShader, 1, files, lengths);
  glCompileShader(vertexShader);
  
  std::string fragmentShaderFile = fileContentsForShader("fragment_shader.frag");
  
  GLchar const* fragFiles[] = { fragmentShaderFile.c_str() };
  GLint fragLengths[] = { static_cast<GLint>(fragmentShaderFile.size()) };
  
  GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(fragmentShader, 1, fragFiles, fragLengths);
  glCompileShader(fragmentShader);

  GLint status;
  glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &status);

  char buffer[512];
  glGetShaderInfoLog(vertexShader, 512, NULL, buffer);
  printf("%s", buffer);
  
  SDL_Event windowEvent;
  while (true)
  {
    if (SDL_PollEvent(&windowEvent))
    {
      if (windowEvent.type == SDL_QUIT) break;
      
      if (windowEvent.type == SDL_KEYUP &&
          windowEvent.key.keysym.sym == SDLK_ESCAPE) break;
    }
    
    SDL_GL_SwapWindow(window);
  }

  
  SDL_GL_DeleteContext(context);
  SDL_Quit();
  return 0;
}


