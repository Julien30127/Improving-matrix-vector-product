cmake_minimum_required(VERSION 3.25)
project(top.matrix_product LANGUAGES CXX)

find_package(OpenMP REQUIRED)

include(FetchContent)

# === Kokkos ===
set(Kokkos_ENABLE_OPENMP ON CACHE BOOL "" FORCE)
set(Kokkos_ENABLE_SERIAL OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
  Kokkos
  GIT_REPOSITORY https://github.com/kokkos/kokkos
  GIT_TAG 4.6.00
)
FetchContent_MakeAvailable(Kokkos)

# === fmt ===
FetchContent_Declare(
  fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt
  GIT_TAG 11.1.4
)
FetchContent_MakeAvailable(fmt)

add_subdirectory(src)
