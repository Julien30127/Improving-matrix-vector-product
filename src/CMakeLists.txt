# === EXÉCUTABLE NAIVE LEFT ===
add_executable(top.matrix_naive_left main_naive_left.cpp)

# Lier les bibliothèques nécessaires pour top.matrix_naive_left
target_compile_options(top.matrix_naive_left PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(top.matrix_naive_left PRIVATE Kokkos::kokkos fmt::fmt OpenMP::OpenMP_CXX)

# === EXÉCUTABLE NAIVE RIGHT ===
add_executable(top.matrix_naive_right main_naive_right.cpp)

# Lier les bibliothèques nécessaires pour top.matrix_naive_right
target_compile_options(top.matrix_naive_right PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(top.matrix_naive_right PRIVATE Kokkos::kokkos fmt::fmt OpenMP::OpenMP_CXX)

# === EXÉCUTABLE BLOCKED ===
add_executable(top.matrix_blocked main_blocked.cpp)

# Lier les bibliothèques nécessaires pour top.matrix_blocked
target_compile_options(top.matrix_blocked PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(top.matrix_blocked PRIVATE Kokkos::kokkos fmt::fmt OpenMP::OpenMP_CXX)
