#include <iostream>
#include "main.h"
#include <Eigen/Dense>

using namespace Eigen;

int main() {
  
  MatrixXd m(2,2);
  std::cout << "Hello from main.cc " << swag::getFive() << " times." << std::endl; 
  
  return 0;
}
