add_executable(top.matrix_product)
target_sources(top.matrix_product PRIVATE main.cpp)

target_compile_options(top.matrix_product PRIVATE -Wall -Wextra -Wpedantic)
target_compile_features(top.matrix_product PRIVATE cxx_std_17)  # Ajoute ça si ce n’est pas déjà forcé par Kokkos

target_link_libraries(top.matrix_product
  PRIVATE
    Kokkos::kokkos
    fmt::fmt
    OpenMP::OpenMP_CXX          # <-- Ajoute ça pour gérer OMP_NUM_THREADS
)
